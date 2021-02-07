//
//  YWTAipOcrServiceManager.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/10/30.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTAipOcrServiceManager : NSObject
// 单例
+(YWTAipOcrServiceManager*)sharedManager;

/// OCR 通用文字识别
/// @param image  识别的图片
/// @param isAccurate  精度选择  YES   高精度  NO 低精度
/// @param complet  结果
-(void)aipOcrDetectTextFromImage:(UIImage*)image andIsAccurateBasic:(BOOL)isAccurate complateHandle:(void(^)(id result,NSError*error))complet;
@end

NS_ASSUME_NONNULL_END
