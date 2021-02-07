//
//  UIImage+YWTExpand.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/4.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RGB)

- (UInt32)RGBA;

@end


@interface UIImage (YWTExpand)

- (UIImage *)fixOrientation;

+(UIImage*)imageChangeName:(NSString *)nameStr;

// 添加滤镜
-(UIImage *)addImageFilterImamge:(UIImage*)image;

- (UIImage *)translatePixelColorByTargetTransColor:(UIColor *)transColor;

@end

NS_ASSUME_NONNULL_END
