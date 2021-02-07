//
//  UIViewController+YWTFaceExpand.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/13.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "UIViewController+YWTFaceExpand.h"

@implementation UIViewController (YWTFaceExpand)

// 创建采集人脸SDK
-(void) createFaceSDKImage:(UIImage*)faceImage{
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:200];
       
    // 设置截取人脸图片大小
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:400];
       
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.5];
       
     // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setIllumThreshold:40];
       
     // 设置图像模糊阀值
     [[FaceSDKManager sharedInstance] setBlurThreshold:0.7];
       
     // 设置头部姿态角度
     [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
       
     // 设置是否进行人脸图片质量检测
     [[FaceSDKManager sharedInstance] setIsCheckQuality:YES];
       
     // 设置超时时间
     [[FaceSDKManager sharedInstance] setConditionTimeout:10];
       
     // 设置人脸检测精度阀值
     [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
       
     // 设置照片采集张数
     [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
    WS(weakSelf);
    
    CGRect previewRect = CGRectMake(0, 0, 500, 500);
    CGRect detectRect = CGRectMake(0, 0, 500, 500);
    [[IDLFaceDetectionManager sharedInstance]detectStratrgyWithNormalImage:faceImage previewRect:previewRect detectRect:detectRect completionHandler:^(FaceInfo *faceinfo, NSDictionary *images, DetectRemindCode remindCode) {
        switch (remindCode) {
            case DetectRemindCodeOK:{
                if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
                    NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage* bestImage = [UIImage imageWithData:data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf faceProcesss:bestImage];
                                               
                        [weakSelf facePlaceholderStr:@""];
                     });
                }
            }
                break;
            case DetectRemindCodePitchOutofDownRange:
                [weakSelf facePlaceholderStr:@"建议略微抬头"];
                    break;
            case DetectRemindCodePitchOutofUpRange:
                [weakSelf facePlaceholderStr:@"建议略微低头"];
                    break;
            case DetectRemindCodeYawOutofLeftRange:
                [weakSelf facePlaceholderStr:@"建议略微向右转头"];
                break;
            case DetectRemindCodeYawOutofRightRange:
                [weakSelf facePlaceholderStr:@"建议略微向左转头"];
                break;
            case DetectRemindCodePoorIllumination:
                [weakSelf facePlaceholderStr:@"光线再亮些"];
                break;
            case DetectRemindCodeNoFaceDetected:
                [weakSelf facePlaceholderStr:@"把脸移入框内"];
                 break;
            case DetectRemindCodeImageBlured:
                [weakSelf facePlaceholderStr:@"请保持不动"];
                break;
            case DetectRemindCodeOcclusionLeftEye:
                [weakSelf facePlaceholderStr:@"左眼有遮挡"];
                break;
            case DetectRemindCodeTooClose:
                [weakSelf facePlaceholderStr:@"手机拿远一点"];
                break;
            case DetectRemindCodeTooFar:
                [weakSelf facePlaceholderStr:@"手机拿近一点"];
                break;
            case DetectRemindCodeTimeout:
//                [weakSelf facePlaceholderStr:@"超时"];
                [self faceIdentriyError];
                break;
            case DetectRemindCodeVerifyInitError       | DetectRemindCodeVerifyDecryptError   |
                DetectRemindCodeVerifyInfoFormatError  | DetectRemindCodeVerifyExpired        |
                DetectRemindCodeVerifyMissRequiredInfo | DetectRemindCodeVerifyInfoCheckError |
                DetectRemindCodeVerifyLocalFileError   | DetectRemindCodeVerifyRemoteDataError:
//                [weakSelf facePlaceholderStr:@"验证失败"];
                 [self faceIdentriyError];
                break;
            default:
                break;
        }
    }];
}

// 人脸提示文字
-(void) facePlaceholderStr:(NSString*)placeholderStr{
    
}
// 人脸采集成功返回
- (void)faceProcesss:(UIImage *)image{
    
}
// 验证失败
-(void) faceIdentriyError{
    
}



@end
