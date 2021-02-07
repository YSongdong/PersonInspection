//
//  LFCamera.h
//  LFCamera
//
//  Created by 张林峰 on 2017/4/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFCaptureFlashMode) {
    LFCaptureFlashModeOff  = 0,
    LFCaptureFlashModeOn   = 1,
    LFCaptureFlashModeAuto = 2
};
@protocol LFCameraDelegate <NSObject>
/*
 filterImg  滤镜图片
 uploadImg  上传图片
 type       1 扫描 2拍照
 data       数据
 */
-(void) takePhotoResultFilterImage:(UIImage*)filterImg uploadImage:(UIImage*)uploadImg  andType:(int)type  andData:(id)data;
// 达到规定的OCR次数，返回方法
-(void) getAchieveOCRNumber;
// ocr 失败多少次 显示拍照按钮
-(void) getShowTakePicBtn;
@end


@interface LFCamera : UIView

// 回调
@property (nonatomic,weak) id <LFCameraDelegate>delegate;

@property (assign, nonatomic) CGRect effectiveRect;//拍摄有效区域（（可不设置，不设置则不显示遮罩层和边框）

//有效区边框色，默认橘色
@property (nonatomic, strong) UIColor *effectiveRectBorderColor;

//遮罩层颜色，默认黑色半透明
@property (nonatomic, strong) UIColor *maskColor;

@property (nonatomic) UIView *focusView;//聚焦的view
// 识别成功
@property (nonatomic,assign) BOOL identSuccess;
// 判断是高精度，
@property (nonatomic,assign) BOOL isAccurateBasic;

/**如果用代码初始化，一定要调这个方法初始化*/
- (instancetype)initWithFrame:(CGRect)frame;

/**获取摄像头方向*/
- (BOOL)isCameraFront;

/**获取闪光灯模式*/
- (LFCaptureFlashMode)getCaptureFlashMode;

/**切换闪光灯*/
- (void)switchLight:(LFCaptureFlashMode)flashMode;

/**切换摄像头*/
- (void)switchCamera:(BOOL)isFront;

/**拍照*/
- (void)takePhoto;

/**重拍*/
- (void)restart;

/**调整图片朝向*/
+ (UIImage *)fixOrientation:(UIImage *)aImage;

// 停止
- (void)stopScanning;
@end
