//
//  YWTFaceCameraView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTFaceCameraView.h"

#define scaleValue 0.5

@interface YWTFaceCameraView ()
<
CaptureDataOutputProtocol
>
@property (nonatomic,strong) UIView *topCoverView;
@property (nonatomic,strong) UIView *leftCoverView;
@property (nonatomic,strong) UIView *rightCoverView;
@property (nonatomic,strong) UIView *bottomCoverView;

@end


@implementation YWTFaceCameraView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    
    // 初始化相机处理类
    self.videoCapture = [[VideoCaptureDevice alloc]init];
    self.videoCapture.delegate = self;
    self.videoCapture.position =  AVCaptureDevicePositionBack;
    
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
    
   
    self.showPhotoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    self.showPhotoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.showPhotoImageV];
   
    self.topCoverView = [[UIView alloc]init];
    self.topCoverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.topCoverView];
    self.topCoverView.alpha = 0.65;
    [self.topCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.equalTo(@(KSIphonScreenH(130)));
    }];
    
    self.leftCoverView = [[UIView alloc]init];
    self.leftCoverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.leftCoverView];
    self.leftCoverView.alpha = 0.65;
    [self.leftCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topCoverView.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.equalTo(@(KSIphonScreenW(25)));
        make.height.equalTo(@(KSIphonScreenH(250)));
    }];
    
    self.rightCoverView = [[UIView alloc]init];
    self.rightCoverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.rightCoverView];
    self.rightCoverView.alpha = 0.65;
    [self.rightCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topCoverView.mas_bottom);
        make.left.equalTo(@(KScreenW-KSIphonScreenW(25)));
        make.right.equalTo(weakSelf);
        make.height.equalTo(weakSelf.leftCoverView.mas_height);
    }];
    
    self.bottomCoverView = [[UIView alloc]init];
    self.bottomCoverView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomCoverView];
    self.bottomCoverView.alpha = 0.65;
    [self.bottomCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rightCoverView.mas_bottom);
        make.left.bottom.right.equalTo(weakSelf);
    }];
    
    self.bgImageV = [[UIImageView alloc]init];
    [self addSubview:self.bgImageV];
    self.bgImageV.image = [UIImage imageChangeName:@"cjrl_pic_bg"];
    self.bgImageV.contentMode =  UIViewContentModeScaleAspectFit;
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topCoverView.mas_bottom);
        make.left.equalTo(weakSelf.leftCoverView.mas_right);
        make.right.equalTo(weakSelf.rightCoverView.mas_left);
        make.bottom.equalTo(weakSelf.leftCoverView.mas_bottom);
    }];
    
    self.showWarninLab = [[UILabel alloc]init];
    [self addSubview:self.showWarninLab];
    self.showWarninLab.text = @"";
    self.showWarninLab.textColor = [UIColor colorTextWhiteColor];
    self.showWarninLab.font = Font(13);
    [self.showWarninLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.topCoverView.mas_bottom).offset(-KSIphonScreenH(5));
        make.centerX.equalTo(weakSelf.topCoverView.mas_centerX);
    }];
 
}

#pragma mark - CaptureDataOutputProtocol
- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.showPhotoImageV.image = image;
    });
    
    if (weakSelf.facePhoto !=NULL ) {
        weakSelf.facePhoto(image);
    }
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
    });
}
-(void)setIsCapDeviceBack:(BOOL)isCapDeviceBack{
    _isCapDeviceBack = isCapDeviceBack;
    self.videoCapture.position = isCapDeviceBack ? AVCaptureDevicePositionBack :  AVCaptureDevicePositionFront;
}
-(void)setHasFinished:(BOOL)hasFinished{
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

@end
