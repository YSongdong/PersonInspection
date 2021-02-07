//
//  YWTPreciseSearchController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTBaseQueryController.h"

#import "YWTSearchResultController.h"
#import "YWTRecognResultController.h"
#import "YWTResultDetailController.h"

#import "LFCamera.h"
#import "YWTQueryProgressView.h"
#import "YWTFaceCameraView.h"
#import "YWTPromptTextDescView.h"
#import "YWTPromptIdentiryView.h"

@interface YWTBaseQueryController ()
<
WebSocketManagerDelegate,
TZImagePickerControllerDelegate,
LFCameraDelegate
>

@property (nonatomic,strong) UIScrollView *queryScrollView;

@property (nonatomic,strong) UIView *queryBgView;
// 人脸相机层
@property (nonatomic,strong) YWTFaceCameraView *faceCameraView;
//
@property (strong, nonatomic) LFCamera *lfCamera;
// 进度view
@property (nonatomic,strong) YWTQueryProgressView *progressView;
// 成功图片imageV
@property (nonatomic,strong) UIImageView  *successImageV;
// 提示文字view
@property (nonatomic,strong) YWTPromptTextDescView *promptTextView;
// 识别中
@property (nonatomic,strong) YWTPromptIdentiryView *promptIdentView;
// 拍照按钮
@property (nonatomic,strong) UIButton *taskPicBtn;
// 取消按钮
@property (nonatomic,strong) UIButton *cancelBtn;
// 手动输入按钮
@property (nonatomic,strong) UIButton *enterBtn;
//相册按钮
@property (nonatomic,strong) UIButton *photoBtn;
// 切换摄像头
@property (nonatomic,strong) UIButton *switchCameraBtn;

@property (nonatomic,strong) YWTCertificateModel *model;

// 判断证件是拍照还是重新拍照   1 拍照  2重新拍照
@property (nonatomic,strong) NSString *isTaskPic;

@end

@implementation YWTBaseQueryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#151e2f"];
    // 设置导航栏
    [self setNavi];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IDLFaceDetectionManager sharedInstance] startInitial];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeConfigInfo];
    [IDLFaceDetectionManager.sharedInstance reset];
}
#pragma mark ----- 创建人脸采集 ----------
-(void) createFaceCameraDeviBack:(BOOL)isBack{
    WS(weakSelf);
    // 人脸相机层
    self.faceCameraView = [[YWTFaceCameraView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    self.faceCameraView.isCapDeviceBack = isBack;
    [self.queryBgView insertSubview:self.faceCameraView atIndex:0];
    // 显示
    self.switchCameraBtn.hidden = NO;
    // 成功返回照片
    self.faceCameraView.facePhoto = ^(UIImage * _Nonnull faceImage) {
        [weakSelf createFaceSDKImage:faceImage];
    };
}
-(void)selectSwitchBtn:(UIButton*)sender{
    [self.faceCameraView removeFromSuperview];
    sender.selected = !sender.selected;
    [self createFaceCameraDeviBack:!sender.selected];
}
// 人脸提示文字
-(void) facePlaceholderStr:(NSString*)placeholderStr{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
         weakSelf.faceCameraView.showWarninLab.text = placeholderStr;
    });
}
// 验证失败
-(void)faceIdentriyError{
    
}
// 人脸采集成功返回
- (void)faceProcesss:(UIImage *)image{
    [self.faceCameraView.videoCapture stopSession];
    WS(weakSelf);
    
    [weakSelf.faceCameraView removeFromSuperview];
    self.successImageV.hidden = NO;
    self.successImageV.image = image;
   
    //
    [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    self.promptIdentView.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.promptIdentView.activityIndicatorView startAnimating];
    });
    // 提示语
    self.promptTextView.promptTextLab.text = @"人脸分析中....";
    // 隐藏切换摄像头按钮
    self.switchCameraBtn.hidden = YES;
    // 请求人脸
    [self requestFaceScanFaceImage:image];
}
// 重新验证
-(void)createReVerify{
    self.faceCameraView.hasFinished = NO;
    [[IDLFaceDetectionManager sharedInstance] startInitial];
    self.faceCameraView.videoCapture.runningStatus = YES;
    [self.faceCameraView.videoCapture startSession];
}
// 更新UI
-(void) updateQueryUI{
    [self.progressView passFaceVerifiId];
}
#pragma mark ----- 创建拍照图片 ----------
-(void) createCameraView{
    self.lfCamera = [[LFCamera alloc] initWithFrame:self.view.bounds];
    self.lfCamera.isAccurateBasic = self.isAccurateBasic;
    //拍摄有效区域（可不设置，不设置则不显示遮罩层和边框）
    self.lfCamera.effectiveRect = CGRectMake(KSIphonScreenW(25), KSIphonScreenH(170), KScreenW-KSIphonScreenW(25)*2, KSIphonScreenH(200));
    self.lfCamera.effectiveRectBorderColor = [UIColor colorBlueTextColor];
    self.lfCamera.delegate = self;
    [self.queryBgView insertSubview:self.lfCamera atIndex:0];
    // 判断证件是拍照还是重新拍照   1 拍照  2重新拍照
    self.isTaskPic = @"1";
    // 提示语
    self.promptTextView.promptTextLab.text = @"拍照时确保证件边框完整，字体清晰，亮度均匀";
//    [self.taskPicBtn setTitle:@"立即拍照" forState:UIControlStateNormal];
}
// --------- LFCameraDelegate   ---------------
-(void) takePhotoResultFilterImage:(UIImage *)filterImg uploadImage:(UIImage *)uploadImg  andType:(int)type andData:(id)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == 1) {
            // 扫描
            [self.lfCamera stopScanning];
            [self.lfCamera removeFromSuperview];
            self.successImageV.image =  uploadImg;
            self.successImageV.hidden = NO;
            [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.promptIdentView.hidden = NO;
            [self.promptIdentView.activityIndicatorView startAnimating];

            self.enterBtn.enabled = NO;
            self.photoBtn.enabled = NO;
            [self requestCertificateScanImage:uploadImg andOCRResult:data];
        }else if(type == 2){
            // 拍照
            [self.lfCamera stopScanning];
            [self.lfCamera removeFromSuperview];
            self.successImageV.hidden = NO;
            self.successImageV.image = uploadImg;
            [self getWithPhotoOCRFilterImage:filterImg uploadImage:uploadImg];
        }
    });
}
// 达到规定的OCR次数，返回方法
-(void) getAchieveOCRNumber{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描超时" message:@"确保证件边框完整，字体清晰，亮度均匀" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 移除拍照视图
        [self.lfCamera removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self createCameraView];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"手动录入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectEnterBtn:self.enterBtn];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
// ocr 失败多少次 显示拍照按钮
-(void) getShowTakePicBtn{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@55);
        }];
    });
}
#pragma mark ---------------   创建选择相册    --------
// 创建多图选择
-(void) createTZImagePick{
    TZImagePickerController *imagePickVC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePickVC.iconThemeColor = [UIColor colorBlueTextColor];
    imagePickVC.showPhotoCannotSelectLayer = YES;
    imagePickVC.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePickVC.allowPickingImage = YES;
    imagePickVC.barItemTextColor = [UIColor colorBlueTextColor];
    imagePickVC.naviBgColor = [UIColor colorTextWhiteColor];
    imagePickVC.oKButtonTitleColorNormal = [UIColor colorBlueTextColor];
    imagePickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickVC.allowCrop = YES;
    imagePickVC.scaleAspectFillCrop = YES;
    imagePickVC.cropRect = CGRectMake(0, (KScreenH-300)/2, KScreenW, 300);
    [self presentViewController:imagePickVC animated:YES completion:nil];
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [self createCameraView];
}
#pragma mark --- TZImagePickerControllerDelegate --------
// 多图选择
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    UIImage *img = [photos firstObject];
    // 添加滤镜
    UIImage *filterImage = [img addImageFilterImamge:img];
    
    [self getWithPhotoOCRFilterImage:filterImage uploadImage:img];
}
#pragma mark ------------- 获取照片 进行OCR 识别 -----------------
-(void) getWithPhotoOCRFilterImage:(UIImage *)filterImg uploadImage:(UIImage *)uploadImg {
    WS(weakSelf);
    [weakSelf.lfCamera stopScanning];
    [weakSelf.lfCamera removeFromSuperview];
    weakSelf.successImageV.image =  uploadImg;
    weakSelf.successImageV.hidden = NO;
    [weakSelf.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    weakSelf.promptIdentView.hidden = NO;
    [weakSelf.promptIdentView.activityIndicatorView startAnimating];

    weakSelf.enterBtn.enabled = NO;
    weakSelf.photoBtn.enabled = NO;
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextAccurateBasicFromImage:filterImg withOptions:options successHandler:^(id result) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"text"] =[YWTTools  convertToJsonData:result];
        [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPBUSINESSNLP params:param waitView:nil complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.enterBtn.enabled = YES;
                    weakSelf.photoBtn.enabled = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
                    });
                });
                return;
            }
            NSDictionary *dict = showdata[@"data"];
            [weakSelf requestCertificateScanImage:uploadImg andOCRResult:dict];
        }];
    } failHandler:^(NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.enterBtn.enabled = YES;
            weakSelf.photoBtn.enabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
            });
        });
    }];
}
#pragma mark -----创建UI ----------
-(void) createUI{
    WS(weakSelf);
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.queryScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    [self.view addSubview:self.queryScrollView];
    
    self.queryBgView = [[UIView alloc]initWithFrame:self.queryScrollView.frame];
    [self.queryScrollView addSubview:self.queryBgView];
    self.queryBgView.backgroundColor = [UIColor blackColor];
    self.queryBgView.alpha = 0.9;
 
    // 进度view
    self.progressView = [[YWTQueryProgressView alloc]init];
    [self.queryBgView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.queryBgView);
        make.height.equalTo(@(KSIphonScreenH(130)));
    }];
    self.progressView.isQuickSearch = self.viewType == 0 ? NO : YES;

    // 成功图片imageV
    self.successImageV = [[UIImageView alloc]init];
    [self.queryBgView addSubview:self.successImageV];
    self.successImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.successImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.queryBgView).offset(KSIphonScreenH(130));
        make.left.equalTo(weakSelf.queryBgView).offset(KSIphonScreenW(25));
        make.right.equalTo(weakSelf.queryBgView).offset(-KSIphonScreenW(25));
        make.height.equalTo(@(KSIphonScreenH(250)));
    }];
    self.successImageV.hidden = YES;

    // 提示文字view
    self.promptTextView = [[YWTPromptTextDescView alloc]init];
    [self.queryBgView addSubview:self.promptTextView];
    [self.promptTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.successImageV.mas_bottom).offset(KSIphonScreenH(30));
        make.left.equalTo(weakSelf.successImageV.mas_left);
        make.right.equalTo(weakSelf.successImageV.mas_right);
        make.height.equalTo(@55);
    }];
    self.promptTextView.promptTextLab.text = @"采集时确保人脸正对手机，无遮挡物，光线充足";

    // 拍照按钮
    self.taskPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queryBgView addSubview:self.taskPicBtn];
    [self.taskPicBtn setTitle:@"立即拍照" forState:UIControlStateNormal];
    self.taskPicBtn.titleLabel.font = Font(16);
    if (KTargetPerson_CS) {
        [self.taskPicBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    }else{
       [self.taskPicBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    }
    [self.taskPicBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [self.taskPicBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [self.taskPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.promptTextView.mas_bottom).offset(KSIphonScreenH(8));
        make.left.equalTo(weakSelf.promptTextView.mas_left);
        make.right.equalTo(weakSelf.promptTextView.mas_right);
        make.height.equalTo(@0);
    }];
    self.taskPicBtn.layer.cornerRadius = 10/2;
    self.taskPicBtn.layer.masksToBounds = YES;
    self.taskPicBtn.layer.borderWidth = 1;
    self.taskPicBtn.layer.borderColor = [[UIColor colorWithHexString:@"1b1f29"]colorWithAlphaComponent:0.7].CGColor;
    [self.taskPicBtn addTarget:self action:@selector(selectTakePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    // 识别中
    self.promptIdentView = [[YWTPromptIdentiryView alloc]init];
    [self.queryBgView addSubview:self.promptIdentView];
    [self.promptIdentView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf.taskPicBtn.mas_bottom).offset(KSIphonScreenH(8));
       make.left.equalTo(weakSelf.taskPicBtn.mas_left);
       make.right.equalTo(weakSelf.taskPicBtn.mas_right);
       make.height.equalTo(@55);
    }];
    self.promptIdentView.hidden = YES;

    // 取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queryBgView addSubview:self.cancelBtn];
    [self.cancelBtn setImage:[UIImage imageNamed:@"pop_btn_off"] forState:UIControlStateNormal];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.promptTextView.mas_bottom).offset(KSIphonScreenH(120));
        make.centerX.equalTo(weakSelf.promptTextView.mas_centerX);
        make.width.height.equalTo(@50);
    }];
    [self.cancelBtn addTarget:self action:@selector(selectCancelBtn:) forControlEvents:UIControlEventTouchUpInside];

    // 输入手动按钮
    self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queryBgView addSubview:self.enterBtn];
    [self.enterBtn setTitle:@" 手动输入" forState:UIControlStateNormal];
    if (KTargetPerson_CS) {
        [self.enterBtn setTitleColor:[UIColor colorNamlCommon98TextColor] forState:UIControlStateNormal];
    }else{
        [self.enterBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    }
    self.enterBtn.titleLabel.font = Font(13);
    [self.enterBtn setImage:[UIImage imageChangeName:@"ico_sdsr"] forState:UIControlStateNormal];
    if (KTargetPerson_CS) {
        self.enterBtn.backgroundColor = [UIColor color1e1eTextColor];
    }else{
        self.enterBtn.backgroundColor = [UIColor colorWithHexString:@"#263143"];
    }
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.queryBgView).offset(-KSIphonScreenW(25));
        make.centerY.equalTo(weakSelf.cancelBtn.mas_centerY);
        make.width.equalTo(@(KSIphonScreenW(80)));
        make.height.equalTo(@(35));
    }];
    self.enterBtn.layer.cornerRadius = 10/2;
    self.enterBtn.layer.masksToBounds = YES;
    self.enterBtn.hidden =YES;
    [self.enterBtn addTarget:self action:@selector(selectEnterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 相册
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queryBgView addSubview:self.photoBtn];
    [self.photoBtn setTitle:@" 相册" forState:UIControlStateNormal];
    if (KTargetPerson_CS) {
        [self.photoBtn setTitleColor:[UIColor colorNamlCommon98TextColor] forState:UIControlStateNormal];
    }else{
        [self.photoBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    }
    self.photoBtn.titleLabel.font = Font(13);
    [self.photoBtn setImage:[UIImage imageNamed:@"ico_xcxz"] forState:UIControlStateNormal];
    if (KTargetPerson_CS) {
        self.photoBtn.backgroundColor = [UIColor color1e1eTextColor];
    }else{
        self.photoBtn.backgroundColor = [UIColor colorWithHexString:@"#263143"];
    }
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.queryBgView).offset(KSIphonScreenW(25));
        make.centerY.equalTo(weakSelf.cancelBtn.mas_centerY);
        make.width.equalTo(@(KSIphonScreenW(70)));
        make.height.equalTo(@(35));
    }];
    self.photoBtn.layer.cornerRadius = 10/2;
    self.photoBtn.layer.masksToBounds = YES;
    self.photoBtn.hidden =YES;
    [self.photoBtn addTarget:self action:@selector(selectPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 切换摄像头按钮
    self.switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.queryBgView addSubview:self.switchCameraBtn];
    [self.switchCameraBtn setImage:[UIImage imageNamed:@"result_camera"] forState:UIControlStateNormal];
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.queryBgView).offset(-KSIphonScreenW(25));
        make.centerY.equalTo(weakSelf.cancelBtn.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    [self.switchCameraBtn addTarget:self action:@selector(selectSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.switchCameraBtn.hidden = YES;

    if (self.viewType == showViewControllerSearchType) {
        self.enterBtn.hidden = YES;
        self.photoBtn.hidden = YES;
        [self createFaceCameraDeviBack:YES];
    }else{
        [self createCameraView];
        [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        self.enterBtn.hidden = NO;
        self.photoBtn.hidden = NO;
    }
}
// 返回按钮
-(void)selectCancelBtn:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// 点击拍照按钮
-(void) selectTakePhotos:(UIButton*)sender{
    if (self.viewType == showViewControllerSearchType) {
        // 重新加载人脸采集
        self.promptIdentView.hidden = YES;
        self.successImageV.hidden = YES;
        [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self createReVerify];
        [self createFaceCameraDeviBack:YES];
        return;
    }else{
        // 证件拍照
        if ([self.isTaskPic isEqualToString:@"1"]) {
            // 拍照
            [self.lfCamera takePhoto];
            
        }else if([self.isTaskPic isEqualToString:@"2"]){
            self.successImageV.hidden = YES;
            // 重新拍照
            [self createCameraView];
            [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                  make.height.equalTo(@0);
            }];
        }
    }
}
// 成功采集图片更新UI
-(void)successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:(BOOL)isSuccess{
    [self.promptIdentView.activityIndicatorView stopAnimating];
    if (!isSuccess) {
        if (self.viewType == showViewControllerSearchType) {
            [self.taskPicBtn setTitle:@"重新采集" forState:UIControlStateNormal];
            self.enterBtn.hidden = YES;
            self.photoBtn.hidden = YES;
            
        }else{
            [self.taskPicBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
            self.isTaskPic = @"2";
            self.enterBtn.hidden = NO;
            self.photoBtn.hidden = NO;
        }
        [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@55);
        }];
        self.promptIdentView.hidden = YES;
        return;
    }

    WS(weakSelf);
    if (self.viewType == showViewControllerSearchType) {
        // 精准查询
        self.viewType =  showViewControllerQuickSearchType;
        self.promptIdentView.hidden = YES;
        self.successImageV.hidden = YES;
        self.faceCameraView.showWarninLab.text = @"";
        [self.promptIdentView.activityIndicatorView stopAnimating];
        [self.progressView passFaceVerifiId];
        [self createCameraView];
        [self.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        weakSelf.enterBtn.hidden = NO;
        weakSelf.photoBtn.hidden = NO;
    }else{
        // 快速查询
        [weakSelf.taskPicBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        weakSelf.promptIdentView.hidden = NO;
        weakSelf.enterBtn.hidden = NO;
        weakSelf.photoBtn.hidden = NO;
    }
}

// 关闭
-(void) closeConfigInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.promptIdentView.activityIndicatorView stopAnimating];
        if (self.viewType == showViewControllerSearchType) {
            [self.faceCameraView.videoCapture stopSession];
        }else{
            [self.lfCamera stopScanning];
        }
     });
}

#pragma  mark ----------------  按钮点击事件 --------------------
- (void)onAppWillResignAction {

}
- (void)onAppBecomeActive {
     dispatch_async(dispatch_get_main_queue(), ^{
         self.faceCameraView.hasFinished = NO;
         self.faceCameraView.videoCapture.runningStatus = YES;
         [self.faceCameraView.videoCapture startSession];
     });
}
// 点击手动输入
-(void) selectEnterBtn:(UIButton*)sender{
    // 移除拍照视图
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lfCamera.identSuccess = YES;
        [self.lfCamera stopScanning];
        [self.lfCamera removeFromSuperview];
    });
    YWTRecognResultController *resultVC = [[YWTRecognResultController alloc]init];
    resultVC.model = self.model;
    resultVC.isEnter = YES;
    resultVC.isAccurateQuery = self.isAccurateQuery;
    [self.navigationController pushViewController:resultVC animated:YES];
}
// 点击相册
-(void) selectPhotoBtn:(UIButton*)sender{
    // 移除拍照视图
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lfCamera.identSuccess = YES;
        [self.lfCamera stopScanning];
        [self.lfCamera removeFromSuperview];
    });
    [self createTZImagePick];
}
#pragma  mark ---------------- 连接WebSocket --------------------
-(void) getWebScoket{
    [self.promptIdentView.activityIndicatorView startAnimating];
    // 连接webSocket
    [[YWTWebSocketManager shared] connectServer];
    [YWTWebSocketManager shared].delegate = self;
}
-(void) sendDataWebSocket{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    mutableDict[@"code"]= [NSNumber numberWithInteger:202];
    mutableDict[@"unit"] = [NSNumber numberWithInteger:2];
    //
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [userD objectForKey:@"UidKey"];
    mutableDict[@"uid"] = uidStr;
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"name"] = self.model.name;
    dataDict[@"certificate_url"] = self.model.certificate_url;
    dataDict[@"face_url"] = self.model.face_url;
    dataDict[@"certificate_type"] = self.model.certificate_name;
    dataDict[@"certificate_num"] =  self.model.certificate_num;
    dataDict[@"id_card"] =  self.model.id_card;
    dataDict[@"user_id"] = [YWTLoginManager obtainWithUserId];
    mutableDict[@"data"] = dataDict;
     
    // 字典转字符串
    NSString *jsonStr = [YWTTools convertToJsonData:mutableDict];
    // 发送消息给服务器
    [[YWTWebSocketManager shared] sendDataToServer:jsonStr];
}
// 连接失败
-(void) connectionWebSocketError:(NSString *)msg{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.promptIdentView.activityIndicatorView stopAnimating];
        weakSelf.promptIdentView.bgLab.text = @"识别失败!";
        [weakSelf.view showErrorWithTitle:msg];
    });
}
// 验证webSocket成功回调
-(void) verificationWebSocketSuccess{
    // 发送信息给WebSocket
    [self sendDataWebSocket];
}
// 接收到WebSocket数据
-(void)webSocketManagerDidReceiveMessageWithDict:(NSDictionary *)dict{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.promptIdentView.activityIndicatorView stopAnimating];
    });
   
    YWTSearchResultController *resultVC = [[YWTSearchResultController alloc]init];
    resultVC.model = self.model;
    resultVC.webDataSource = dict;
    resultVC.isAccurateQuery = self.isAccurateQuery;
    [self.navigationController pushViewController:resultVC animated:YES];
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    if (self.viewType == showViewControllerSearchType) {
        self.customNavBar.title =@"精准查询";
    }else{
        self.customNavBar.title =@"快速查询";
    }
}
#pragma  mark ----------------  get 方法--------------------
-(void)setViewType:(showViewControllerType)viewType{
    _viewType = viewType;
}
-(void)setIsAccurateBasic:(BOOL)isAccurateBasic{
    _isAccurateBasic = isAccurateBasic;
}
-(void)setIsAccurateQuery:(BOOL)isAccurateQuery{
    _isAccurateQuery = isAccurateQuery;
}
-(YWTCertificateModel *)model{
    if (!_model) {
        _model = [[YWTCertificateModel alloc]init];
        _model.certificate_name =@"";
        _model.constructor_id = @"";
        _model.certificate_num = @"";
        _model.certificate_type = @"";
        _model.certificate_url = @"";
        _model.face_url = @"";
        _model.id_card = @"";
        _model.name = @"";
        _model.record_id = @"";
        _model.errorMsg = @"";
    }
    return _model;
}
#pragma  mark ----------------  数据相关   --------------------
// 人脸扫描结果
-(void) requestFaceScanFaceImage:(UIImage*)faceImage{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableArray *faceArr = [NSMutableArray array];
    [faceArr addObject:faceImage];
    [[YWTHttpManager sharedManager]upLoadData:HTTP_ATTAPPBUSINESSFACESCANURL params:param andData:faceArr andReceive:@"file" waitView:nil complateHandle:^(id  _Nonnull showdata, NSDictionary * _Nonnull error) {
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.promptIdentView.activityIndicatorView stopAnimating];
        });
        if (error) {
            NSNumber *code = error[@"code"];
            if ([code integerValue] == 4001 ) {
                NSString *msg = [NSString stringWithFormat:@"%@",error[@"message"]];
                [self.view showErrorWithTitle:msg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
                });
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",error[@"message"]];
                [self.view showErrorWithTitle:msg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
                });
            }
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据格式错误"];
            return;
        }
        NSDictionary *dict = (NSDictionary*)data;
        //保存人脸图片
        self.model.faceImage = faceImage;
        //保存人脸图片地址
        self.model.face_url = [NSString stringWithFormat:@"%@",dict[@"face_url"]];
        self.model.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.model.id_card = [NSString stringWithFormat:@"%@",dict[@"id_card"]];
        self.model.constructor_id = [NSString stringWithFormat:@"%@",dict[@"constructor_id"]];
        self.model.certificate_num = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
        self.model.result_status = [NSString stringWithFormat:@"%@",dict[@"result_status"]];
        self.model.certificate_name = [NSString stringWithFormat:@"%@",dict[@"certificate_name"]];
        if ([[dict allKeys] containsObject:@"record_id"]) {
            self.model.record_id = [NSString stringWithFormat:@"%@",dict[@"record_id"]];
        }
        // status 状态 是否扫描证件状态：1-扫；2-不扫
        NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
        if ([statuStr isEqualToString:@"1"]) {
            [self successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:YES];
        }else{
            [self.promptIdentView.activityIndicatorView stopAnimating];
            YWTSearchResultController *resultVC = [[YWTSearchResultController alloc]init];
            resultVC.isAccurateQuery = self.isAccurateQuery;
            resultVC.model = self.model;
            resultVC.webDataSource = dict;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    }];
}
// 证件扫描
-(void) requestCertificateScanImage:(UIImage*)image andOCRResult:(id)result{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *jsonStr = [YWTTools  convertToJsonData:result];
    param[@"data"] = jsonStr;
    param[@"face_url"] = self.model.face_url == nil ? @"" : self.model.face_url;
    NSMutableArray *faceArr = [NSMutableArray array];
    [faceArr addObject:image];
    [[YWTHttpManager sharedManager]upLoadData:HTTP_ATTAPPBUSINESCERIFICSTESCAN params:param andData:faceArr andReceive:@"file" waitView:nil complateHandle:^(id  _Nonnull showdata, NSDictionary * _Nonnull error) {
        [self.promptIdentView.activityIndicatorView stopAnimating];
        self.enterBtn.enabled = YES;
        self.photoBtn.enabled = YES;
        if (error) {
            NSNumber *code = error[@"code"];
            if ([code integerValue] == 4001 ) {
                NSString *msg = [NSString stringWithFormat:@"%@",error[@"message"]];
                [self.view showErrorWithTitle:msg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
                });
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",error[@"message"]];
                [self.view showErrorWithTitle:msg];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self successCollectPicUpdateUIIdentSuccessOrFailIsSuccess:NO];
                });
            }
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据格式错误"];
            return;
        }
        NSDictionary *dict = (NSDictionary*)data;
        //保存人脸图片
        self.model.certificateImage = image;
        //保存人脸图片地址
        self.model.certificate_url = [NSString stringWithFormat:@"%@",dict[@"certificate_url"]];
        self.model.face_url = [NSString stringWithFormat:@"%@",dict[@"face_url"]];
        self.model.certificate_num = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
        self.model.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.model.constructor_id = [NSString stringWithFormat:@"%@",dict[@"constructor_id"]];
        self.model.certificate_name = [NSString stringWithFormat:@"%@",dict[@"certificate_name"]];
        self.model.id_card = [NSString stringWithFormat:@"%@",dict[@"id_card"]];
        if ([[dict allKeys] containsObject:@"record_id"]) {
            self.model.record_id = [NSString stringWithFormat:@"%@",dict[@"record_id"]];
        }
        //  是否扫描证件状态：1-打开类型选择页面；2-不打开类型选择页面直接请求websocket接口；3-跳转列表页面
        NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
        if ([statuStr isEqualToString:@"1"]) {
            YWTRecognResultController *resultVC = [[YWTRecognResultController alloc]init];
            resultVC.model = self.model;
            resultVC.dataDict = dict;
            resultVC.isAccurateQuery = self.isAccurateQuery;
            [self.navigationController pushViewController:resultVC animated:YES];
        }else if([statuStr isEqualToString:@"2"]){
            [self getWebScoket];
        }else if([statuStr isEqualToString:@"3"]){
            YWTSearchResultController *resultVC = [[YWTSearchResultController alloc]init];
            resultVC.isAccurateQuery = self.isAccurateQuery;
            resultVC.model = self.model;
            resultVC.webDataSource = dict;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    }];
}
@end
