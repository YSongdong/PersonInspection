//
//  UIViewController+YWTFaceExpand.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/13.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YWTFaceExpand)

// 创建采集人脸SDK
-(void) createFaceSDKImage:(UIImage*)faceImage;

// 人脸提示文字
-(void) facePlaceholderStr:(NSString*)placeholderStr;
// 验证失败
-(void) faceIdentriyError;
// 人脸采集成功返回
- (void)faceProcesss:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
