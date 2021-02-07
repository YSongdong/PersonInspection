//
//  YWTFaceCameraView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface YWTFaceCameraView : UIView

@property (nonatomic, readwrite, retain) VideoCaptureDevice *videoCapture;

@property (nonatomic, readwrite, assign) BOOL hasFinished;
 // 判断是不是前摄像头 默认YES  是
@property (nonatomic, assign) BOOL isCapDeviceBack;

@property (nonatomic,strong) UILabel *showWarninLab;

@property (nonatomic,strong) UIImageView *bgImageV;

@property (nonatomic,strong) UIImageView *showPhotoImageV;
// 提示文字
@property (nonatomic,copy) void(^showPlaceholder)(NSString *placeholderStr);
// 返回的图片
@property (nonatomic,copy) void(^facePhoto)(UIImage *faceImage);


@end

NS_ASSUME_NONNULL_END
