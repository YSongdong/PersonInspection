//
//  LFCamera.m
//  LFCamera
//
//  Created by 张林峰 on 2017/4/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFCamera.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "UIImage+ZXResize.h"

// OCR 识别最大次数
#define MaxNumberOCR  20

@interface LFCamera () <UIGestureRecognizerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    NSTimer *_borderDetectTimeKeeper;
    BOOL _borderDetectFrame;
}

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

/**记录开始的缩放比例*/
@property(nonatomic,assign) CGFloat beginGestureScale;

/** 最后的缩放比例*/
@property(nonatomic,assign) CGFloat effectiveScale;

@property(nonatomic, strong) CMMotionManager * motionManager;
@property(nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property (nonatomic, strong) CAShapeLayer * maskLayer;//半透明黑色遮罩
@property (nonatomic, strong) CAShapeLayer * effectiveRectLayer;//有效区域框
@property (nonatomic) BOOL isAuthorized;
//是否前摄像头
@property (nonatomic) BOOL isFront;

@property (nonatomic,strong) UIView *scanView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIImageView *lineImageV;
@property (nonatomic, assign) NSInteger distance;
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

// 任务线程数组
@property (nonatomic,strong) NSMutableArray *taskThreadArr;
// 帧数计算
@property (nonatomic,assign) NSInteger  numberPage;
// 计算OCR次数
@property (nonatomic,assign) NSInteger  numberOCR;

@end

@implementation LFCamera

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isAuthorized = [self canUseCamear];
        self.numberPage = 0 ;
        self.numberOCR = 0 ;
        self.identSuccess = NO;
        [self configCotionManager];
        if (self.isAuthorized) {
            [self configCamera];
        }
        self.effectiveRectBorderColor = [UIColor colorBlueTextColor];
        self.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
       
        //聚焦视图
        [self addSubview:self.focusView];
        
       // 缩放手势
        self.effectiveScale = self.beginGestureScale = 1.0f;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
    
    }
    return self;
}
// 停止
- (void)stopScanning{
    [_session stopRunning];
    _session = nil;
    [self removeTimer];
}
- (void)layoutSubviews {
    self.maskLayer.path = [self getMaskPathWithRect:self.bounds exceptRect:self.effectiveRect].CGPath;
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat minX = CGRectGetMinX(self.effectiveRect);
    CGFloat maxX = CGRectGetMaxX(self.effectiveRect);
    CGFloat minY = CGRectGetMinY(self.effectiveRect);
    CGFloat maxY = CGRectGetMaxY(self.effectiveRect);
    CGFloat cornerW = 26.0f;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(minX, minY, cornerW, cornerW)];
    [self drawImageForImageView:imgView];
    [self addSubview:imgView];
   
    UIImageView *topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(maxX-cornerW, minY, cornerW, cornerW)];
    topImageV.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * 1);
    [self drawImageForImageView:topImageV];
    [self addSubview:topImageV];
    
    UIImageView *leftBottomImageV = [[UIImageView alloc] initWithFrame:CGRectMake(minX, maxY-cornerW, cornerW, cornerW)];
    leftBottomImageV.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (2 - 1));
    [self drawImageForImageView:leftBottomImageV];
    [self addSubview:leftBottomImageV];

    UIImageView *rightBottomImageV = [[UIImageView alloc] initWithFrame:CGRectMake(maxX-cornerW, maxY-cornerW, cornerW, cornerW)];
    rightBottomImageV.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (3 - 1));
    [self drawImageForImageView:rightBottomImageV];
    [self addSubview:rightBottomImageV];
}
//绘制角图片
- (void)drawImageForImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [[UIColor colorBlueTextColor] CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
- (void)setEffectiveRect:(CGRect)effectiveRect {
    _effectiveRect = effectiveRect;
    if (_effectiveRect.size.width > 0) {
        [self setupEffectiveRect];
    }
}

- (void)configCotionManager {
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (!_motionManager.deviceMotionAvailable) {
        _motionManager = nil;
    }
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
        [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
    }];
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            _deviceOrientation = UIDeviceOrientationPortrait;
        }
    }
    else{
        if (x >= 0){
            _deviceOrientation = UIDeviceOrientationLandscapeRight;
        }
        else{
            _deviceOrientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}

- (void)configCamera{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //在修改devicce之前一定要调用lock方法,否则会引起崩溃
    [device lockForConfiguration:nil];
   
    // 聚焦
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    // 白平衡
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }

    //设置完成后调用unlock
    [device unlockForConfiguration];
    _device = device;
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)}];
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:dataOutput];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    //自动对象,苹果提供了对应的通知api接口,可以直接添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    if ([self.session canAddOutput:dataOutput]) {
        [self.session addOutput:dataOutput];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    [self.layer insertSublayer:self.previewLayer atIndex:0];
    
    //开始启动
    [self.session commitConfiguration];
    [self.session startRunning];
    
    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:scanView];
    self.scanView = scanView;
       
    //扫描线
    UIImageView *line = [[UIImageView alloc] init];
    line.image = [UIImage imageNamed:@"sm_ico_line_1"];
    [scanView addSubview:line];
    self.lineImageV = line;
    
    if (_borderDetectTimeKeeper) {
        [_borderDetectTimeKeeper invalidate];
    }
    // 每隔2监测
    _borderDetectTimeKeeper = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(enableBorderDetectFrame) userInfo:nil repeats:YES];
}
-(void)enableBorderDetectFrame{
    CGPoint point = CGPointMake(self.effectiveRect.origin.x+self.effectiveRect.size.width/2, self.effectiveRect.origin.y+self.effectiveRect.size.height/2);
    [self focusAtPoint:point];
}
//通过给屏幕上的view添加手势,获取手势的坐标.将坐标用setFocusPointOfInterest方法赋值给device
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.input device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}
- (void)subjectAreaDidChange:(NSNotification *)notification{
    CGPoint point = CGPointMake(self.effectiveRect.origin.x+self.effectiveRect.size.width/2, self.effectiveRect.origin.y+self.effectiveRect.size.height/2);
    CGSize size = self.frame.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    //先进行判断是否支持控制对焦
    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [_device lockForConfiguration:nil];
        [_device setFocusPointOfInterest:focusPoint];
        [_device setFocusMode:AVCaptureFocusModeAutoFocus];
        //操作完成后，记得进行unlock。
        [_device unlockForConfiguration];
    }
    if (_device.isExposurePointOfInterestSupported && [_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [_device lockForConfiguration:nil];
        [_device setExposurePointOfInterest:focusPoint];
        [_device setExposureMode:AVCaptureExposureModeAutoExpose];
        //操作完成后，记得进行unlock。
        [_device unlockForConfiguration];
    }
    //设置对焦动画
    _focusView.center = point;
    _focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
     [UIView animateWithDuration:0.5 animations:^{
         self.focusView.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
         self.focusView.hidden = YES;
     }];
    }];
}
#pragma mark - Action

//聚焦手势
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            self.device.smoothAutoFocusEnabled = YES;
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            self.device.smoothAutoFocusEnabled = YES;
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = self.scanView.center;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
}
/**切换闪光灯*/
- (void)switchLight:(LFCaptureFlashMode)flashMode {
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        if ((AVCaptureFlashMode)flashMode == self.device.flashMode) {
            return;
        }
        //修改前必须先锁定
        [self.device lockForConfiguration:nil];
        self.device.flashMode = (AVCaptureFlashMode)flashMode;
        self.device.torchMode = (AVCaptureTorchMode)flashMode;
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
    }
}

/**切换摄像头*/
- (void)switchCamera:(BOOL)isFront {
    NSArray *inputs = self.session.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = isFront ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
            AVCaptureDevice *newCamera = [self cameraWithPosition:position];
            AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            if (newInput) {
                [self.session addInput:newInput];
            }
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            self.isFront = isFront;
            break;
        }
    }
}

- (void)takePhoto{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    // 停止扫描操作
    self.identSuccess = YES;
    
    //如果是前摄像头，则加镜像
    if (self.isFront) {
        videoConnection.videoMirrored = YES;
    } else {
        videoConnection.videoMirrored = NO;
    }
    __weak typeof(self) weakSelf = self;
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *img = [UIImage imageWithData:imageData];
        UIImage *image = [LFCamera fixOrientationImage:img];
        [weakSelf.session stopRunning];
        __block UIImage *wImage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.effectiveRect.size.width > 0) {
                wImage = [weakSelf cutImage:wImage];
            }
            // 添加滤镜
//            UIImage *filterImage = [image addImageFilterImamge:image];
            __weak typeof(weakSelf) strongSelf= weakSelf;
            __block UIImage *cutImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                cutImage = [strongSelf  cutImage:cutImage];
                if ([self.delegate respondsToSelector:@selector(takePhotoResultFilterImage:uploadImage:andType:andData:)]) {
                    [self.delegate takePhotoResultFilterImage:cutImage uploadImage:wImage andType:2 andData:@""];
                }
            });
        });
    }];
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    // 1. 获取 originImage
    UIImage * originImage = [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
    
    if (self.numberOCR == MaxNumberOCR ) {
        if ([self.delegate respondsToSelector:@selector(getAchieveOCRNumber)]) {
            // 停止
            [self stopScanning];
            [self.delegate getAchieveOCRNumber];
        }
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.numberPage ++;

        if (self.identSuccess) { return;}

        // 控制帧数  15帧 取一张
        if (self.numberPage % 5 == 0) {
            if (self.taskThreadArr.count < 3) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"image"] = originImage;
                // 默认不开启任务
                dict[@"isTask"] = [NSNumber numberWithBool:NO];
                dict[@"taskKey"] = [self getTime];
                [self.taskThreadArr addObject:dict];
            }
        }
        // 开启任务线程
        [self groupEnterAndLeave];
    });
}

#pragma mark   -------  扫描功能   -----------
/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave{
    if (self.taskThreadArr.count == 0) { return; }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=0; i<self.taskThreadArr.count; i++) {
        NSMutableDictionary *dict = self.taskThreadArr[i];
        if (![dict[@"isTask"] boolValue]) {
            // 交换值，表示任务开始
            dict[@"isTask"] = [NSNumber numberWithBool:YES];
            [self.taskThreadArr replaceObjectAtIndex:i withObject:dict];
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                [self uploadOCRDcit:dict];
                dispatch_group_leave(group);
            });
        }
    }
}

// 上传到OCR
-(void) uploadOCRDcit:(NSDictionary*)dict{
    NSString *taskKey = dict[@"taskKey"];
    UIImage *img = dict[@"image"];
    //
    CGFloat width = self.previewLayer.bounds.size.width;
    CGFloat height = self.previewLayer.bounds.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(width*scale, height*scale);
    UIImage *scaledImage = [img zx_resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationHigh];
    // 统一修改图片方向
    UIImage *directionImage = [scaledImage fixOrientation];
    
    UIImage *filterImage = directionImage;

    //  裁剪大小
    WS(weakSelf);
    __block UIImage *wImage = filterImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        wImage = [weakSelf cutImage:wImage];
        [[YWTAipOcrServiceManager sharedManager]aipOcrDetectTextFromImage:wImage andIsAccurateBasic:self.isAccurateBasic complateHandle:^(id  _Nonnull result, NSError * _Nonnull error) {
            if (error) {
                [self removeTaskKey:taskKey];
                return;
            }
            //识别 成功
            [self removeTaskKey:taskKey];
            // 计算OCR次数
            self.numberOCR ++;
            if(![result isKindOfClass:[NSDictionary class]]){return;}
            NSArray *resulArr = result[@"words_result"];
            if (resulArr.count == 0) { return;}
            if (self.identSuccess) {return;}
            NSDictionary *resultDict = (NSDictionary*)result;
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"text"] =[YWTTools  convertToJsonData:resultDict];
            [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPBUSINESSNLP params:param waitView:nil complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
                NSLog(@"-----result--%@---",result);
                NSLog(@"-----showdata--%@---",showdata);
                if (error) {
                    if (self.numberOCR < 8) {return;}
                    NSLog(@"-----numberOCR--%ld---",(long)self.numberOCR);
                    if ([self.delegate respondsToSelector:@selector(getShowTakePicBtn)]) {
                        [self.delegate getShowTakePicBtn];
                    }
                    return;
                }
                NSDictionary *dict = showdata[@"data"];
                if (self.numberOCR >= MaxNumberOCR) {return;}
                if (self.identSuccess) { return;}
                if ([self.delegate respondsToSelector:@selector(takePhotoResultFilterImage:uploadImage:andType:andData:)]) {
                    // 播放音频
                    [self playCilckVideo];
                    [self.delegate takePhotoResultFilterImage:wImage uploadImage:wImage andType:1 andData:dict];
                    self.identSuccess = YES;
                }
            }];
        }];
    });
}
// 播放音频
-(void)playCilckVideo{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ding12" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}


-(BOOL) jumpIdentSuccessArr:(NSArray*)arr{
    BOOL isIdentSuccess = NO;
    BOOL isJobCategroy = NO;
    BOOL isName = NO;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *listDict = arr[i];
        NSString *wordsStr = listDict[@"words"];
        wordsStr = [NSString getStringPattern:@"[a-z^A-Z]" allStr:wordsStr];
        // 如果是身份证判断
        if ([wordsStr containsString:@"公民"] || [wordsStr containsString:@"身份"]) {
            isJobCategroy =  YES ;
        }
        // 证号提取
        NSString *keyStr = [NSString getStringNumber:wordsStr];
        if (keyStr.length >= 17) {
            NSLog(@"--证件号---%@---",wordsStr);
            if (keyStr.length == 17) {
                NSString *identStr = [NSString stringWithFormat:@"%@x",keyStr];
                isIdentSuccess = [YWTTools judgeIdentityStringValid:identStr];
            }else if(keyStr.length == 18){
                isIdentSuccess = [YWTTools judgeIdentityStringValid:keyStr];
            }
            continue;
        }
        
        // 作业类别
        if ([wordsStr containsString:@"类别"]) {
            if ([wordsStr containsString:@":"]) {
                wordsStr = [wordsStr componentsSeparatedByString:@":"][1];
                isJobCategroy = [wordsStr isEqualToString:@""] ? NO : YES;
            }else{
                if ([wordsStr containsString:@"别"] && [wordsStr containsString:@"业"]) {
                    isJobCategroy = YES;
                }
            }
          continue;
        }
        
        // 姓名
        if ([wordsStr containsString:@"姓名"]) {
            if ([wordsStr containsString:@":"]) {
                wordsStr = [wordsStr componentsSeparatedByString:@":"][1];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }else{
                NSRange range = [wordsStr rangeOfString:@"姓名"];
                wordsStr = [wordsStr substringFromIndex:(range.length+range.location)];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }
            continue;
        }else if ([wordsStr containsString:@"姓"]){
            if ([wordsStr containsString:@":"]) {
                wordsStr = [wordsStr componentsSeparatedByString:@":"][1];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }else{
                NSRange range = [wordsStr rangeOfString:@"姓"];
                wordsStr = [wordsStr substringFromIndex:range.length];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }
            continue;
        }else if ([wordsStr containsString:@"名"]){
            if ([wordsStr containsString:@":"]) {
                wordsStr = [wordsStr componentsSeparatedByString:@":"][1];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }else{
                NSRange range = [wordsStr rangeOfString:@"名"];
                wordsStr = [wordsStr substringFromIndex:range.length];
                isName = [wordsStr isEqualToString:@""] ? NO : YES;
            }
            continue;
        }
        
        if ([wordsStr containsString:@"电工作业"] || [wordsStr containsString:@"高处作业"] || [wordsStr containsString:@"焊接与热切割作业"]) {
            BOOL jobCatgroy = YES;
            isJobCategroy = jobCatgroy;
            if (isIdentSuccess && jobCatgroy && isName) {
                return YES;
            }
            continue;
        }
        // 百家姓
        if (wordsStr.length > 2) {
            BOOL  name = [NSString jumpBookOfFamilyName:wordsStr];
            if (isIdentSuccess && isJobCategroy && name) {
                return YES;
            }
            continue;
        }
    }
    
    bool success = NO;
    if (isIdentSuccess && isJobCategroy && isName) {
        success = YES;
    }
    return success;
}

// 通过任务key 删除任务
-(void) removeTaskKey:(NSString*)key{
    for (int i=0; i<self.taskThreadArr.count; i++) {
        NSDictionary *dict = self.taskThreadArr[i];
        if ([key isEqualToString:dict[@"taskKey"]]) {
            [self.taskThreadArr removeObjectAtIndex:i];
        }
    }
}
// 当前时间
-(NSString *)getTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}
// 添加定时器
- (void)addTimer{
    _distance = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timerAction{
    if (_distance++ > self.effectiveRect.size.height-30) _distance = 0;
    self.lineImageV.frame = CGRectMake(0, _distance, self.effectiveRect.size.width, 30);
}
- (void)removeTimer{
    [_timer invalidate];
    _timer = nil;
    [_borderDetectTimeKeeper invalidate];
    _borderDetectTimeKeeper = nil;
}

//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView{
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}



#pragma mark - 方法

//相机是否可用
- (BOOL)canUseCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    else{
        return NO;
    }
    return YES;
}

/**配置拍摄范围*/
- (void)setupEffectiveRect{
    [self.layer addSublayer: self.maskLayer];
    [self.layer addSublayer: self.effectiveRectLayer];
    self.scanView.frame = self.effectiveRect;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.scanView addGestureRecognizer:tapGesture];
    self.lineImageV.frame = self.scanView.frame;
    // 添加定时
    [self addTimer];
    
//    [_device lockForConfiguration:nil];
//    CGPoint focusPoint = CGPointMake(self.effectiveRect.origin.x+self.effectiveRect.size.width/2, self.effectiveRect.origin.y+self.effectiveRect.size.height/2);
//    // 聚焦
//    if ([_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//        [_device setFocusPointOfInterest:focusPoint];
//        [_device setFocusMode:AVCaptureFocusModeAutoFocus];
//    }
//    [_device unlockForConfiguration];
    
//    if (_borderDetectTimeKeeper) {
//        [_borderDetectTimeKeeper invalidate];
//    }
//    // 每隔2监测
//    _borderDetectTimeKeeper = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(enableBorderDetectFrame) userInfo:nil repeats:YES];
}

-(void)setIsAccurateBasic:(BOOL)isAccurateBasic{
    _isAccurateBasic = isAccurateBasic;
}

/**生成空缺部分rect的layer*/
- (UIBezierPath *)getMaskPathWithRect: (CGRect)rect exceptRect: (CGRect)exceptRect
{
    if (!CGRectContainsRect(rect, exceptRect)) {
        return nil;
    }
    else if (CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    
    CGFloat boundsInitX = CGRectGetMinX(rect);
    CGFloat boundsInitY = CGRectGetMinY(rect);
    CGFloat boundsWidth = CGRectGetWidth(rect);
    CGFloat boundsHeight = CGRectGetHeight(rect);
    
    CGFloat minX = CGRectGetMinX(exceptRect);
    CGFloat maxX = CGRectGetMaxX(exceptRect);
    CGFloat minY = CGRectGetMinY(exceptRect);
    CGFloat maxY = CGRectGetMaxY(exceptRect);
    CGFloat width = CGRectGetWidth(exceptRect);
    
    /** 添加路径*/
    UIBezierPath * path = [UIBezierPath bezierPathWithRect: CGRectMake(boundsInitX, boundsInitY, minX, boundsHeight)];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, boundsInitY, width, minY)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(maxX, boundsInitY, boundsWidth - maxX, boundsHeight)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, maxY, width, boundsHeight - maxY)]];
    
    return path;
}

//生成相应方向的摄像头设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
    if ( device.position == position )
    return device;
    return nil;
}

// 调整设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    switch (self.deviceOrientation) {
            case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
            case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

/**获取摄像头方向*/
- (BOOL)isCameraFront {
    return self.isFront;
}

/**获取闪光灯模式*/
- (LFCaptureFlashMode)getCaptureFlashMode {
    return (LFCaptureFlashMode)self.device.torchMode;
}

//裁剪
- (UIImage *)cutImage:(UIImage *)image {
//        NSLog(@"图片朝向%@",@(image.imageOrientation));
//        image = [LFCamera fixOrientation:image];
    //图片缩放比例
    float imageZoomRate = 1;//预览视图相对图片大小的缩放比例
    CGFloat offsetH = 0;
    CGFloat offsetW = 0;
    float orignY = self.effectiveRect.origin.y;
    float orignX = self.effectiveRect.origin.x;
    //相对图片高宽比例修正裁剪区（因为本控件高宽比不一定等于图片高宽比，而用户看到的裁剪框是相对本控件的）
    if (image.size.height > image.size.width) {//竖着拍
        if ((self.frame.size.height/self.frame.size.width) < (image.size.height/image.size.width)) {//本控件宽度刚好填满，高度超出
            imageZoomRate = self.frame.size.width/image.size.width;
        } else {//本控件高度刚好填满，宽度超出
            imageZoomRate = self.frame.size.height/image.size.height;
        }
        offsetH = image.size.height-self.frame.size.height/imageZoomRate;
        offsetW = image.size.width-self.frame.size.width/imageZoomRate;
        orignY = self.effectiveRect.origin.y/imageZoomRate + offsetH/2;
        orignX = self.effectiveRect.origin.x/imageZoomRate + offsetW/2;
        
        //当然这里可以写手机朝下的算法，但我拒绝为这种愚蠢行为写算法
        
    } else {//横着拍，图片的宽对应本控件的高
        if ((self.frame.size.height/self.frame.size.width) < (image.size.width/image.size.height)) {//本控件宽度刚好填满，高度超出
            imageZoomRate = self.frame.size.width/image.size.height;
        } else {//本控件高度刚好填满，宽度超出
            imageZoomRate = self.frame.size.height/image.size.width;
        }
        
        //手机顶部朝左
        offsetH = image.size.width-self.frame.size.height/imageZoomRate;
        offsetW = image.size.height-self.frame.size.width/imageZoomRate;
        orignY = (self.frame.size.width - self.effectiveRect.origin.x - self.effectiveRect.size.width)/imageZoomRate + offsetW/2;
        orignX = (self.effectiveRect.origin.y)/imageZoomRate + offsetH/2;
        
        //手机顶部朝右
        if (image.imageOrientation == 1 || image.imageOrientation == 4) {
            offsetH = image.size.width-self.frame.size.height/imageZoomRate;
            offsetW = image.size.height-self.frame.size.width/imageZoomRate;
            orignY = (self.effectiveRect.origin.x)/imageZoomRate + offsetW/2;
            orignX = (self.frame.size.height - self.effectiveRect.origin.y - self.effectiveRect.size.height)/imageZoomRate + offsetH/2;
        }
    }
    
    CGRect cutImageRect = CGRectZero;
    cutImageRect.origin.x = orignX;
    cutImageRect.origin.y = orignY;
    cutImageRect.size.width = self.effectiveRect.size.width/imageZoomRate;
    cutImageRect.size.height = self.effectiveRect.size.height/imageZoomRate;
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(image.size);
    
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [scaledImage CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cutImageRect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    // 释放内存
    CGImageRelease(newImageRef);
    
    return newImage;
    
}
/*
 ** 此方法只在照片存入相册是调用
 */
+ (UIImage *)fixOrientationImage:(UIImage *)aImage
{
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationUpMirrored:
        case UIImageOrientationUp:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
    return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (UIImage *) imageFromSamplePlanerPixelBuffer:(CMSampleBufferRef)sampleBuffer{
    @autoreleasepool {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
        // Get the pixel buffer width and height
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        // Create a device-dependent RGB color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                     bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
        // Create a Quartz image from the pixel data in the bitmap graphics context
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        // Free up the context and color space
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        // Create an image object from the Quartz image
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        
        // Release the Quartz image
        CGImageRelease(quartzImage);
        return (image);
    }
}
- (void)restart {
    [self.session startRunning];
}

#pragma mark - 手势缩放焦距
//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches];
    for (NSInteger i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor) {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - 懒加载

/** 有效区域框*/
- (CAShapeLayer *)effectiveRectLayer {
    if (!_effectiveRectLayer) {
        CGRect scanRect = self.effectiveRect;
        scanRect.origin.x -= 1;
        scanRect.origin.y -= 1;
        scanRect.size.width += 2;
        scanRect.size.height += 2;
        
        _effectiveRectLayer = [CAShapeLayer layer];
        _effectiveRectLayer.path = [UIBezierPath bezierPathWithRect:scanRect].CGPath;
        _effectiveRectLayer.fillColor = [UIColor clearColor].CGColor;
        _effectiveRectLayer.strokeColor = self.effectiveRectBorderColor.CGColor;
    }
    return _effectiveRectLayer;
}


/**黑色半透明遮掩层*/
- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.path = [self getMaskPathWithRect:self.bounds exceptRect:self.effectiveRect].CGPath;
        _maskLayer.fillColor = self.maskColor.CGColor;
    }
    return _maskLayer;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor greenColor].CGColor;
        _focusView.layer.borderWidth = 1;
        _focusView.hidden = YES;
    }
    return _focusView;
}
-(NSMutableArray *)taskThreadArr{
    if (!_taskThreadArr) {
        _taskThreadArr = [NSMutableArray array];
    }
    return _taskThreadArr;
}

@end
