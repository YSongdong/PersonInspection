//
//  YWTAipOcrServiceManager.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/10/30.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAipOcrServiceManager.h"

@implementation YWTAipOcrServiceManager
// 单例
+(YWTAipOcrServiceManager*)sharedManager{
    static YWTAipOcrServiceManager *ocrManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ocrManager = [[super allocWithZone:nil]init];
    });
    return ocrManager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [YWTAipOcrServiceManager sharedManager];
}
-(instancetype)init{
    self = [super init];
    if (self) {}
    return self;
}
/// OCR 通用文字识别
/// @param image  识别的图片
/// @param isAccurate  精度选择  YES   高精度  NO 低精度
/// @param complet  结果
-(void)aipOcrDetectTextFromImage:(UIImage*)image andIsAccurateBasic:(BOOL)isAccurate complateHandle:(void(^)(id result,NSError*error))complet{
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    if (isAccurate) {
        // 高精度
        [[AipOcrService shardService]detectTextAccurateBasicFromImage:image withOptions:options successHandler:^(id result) {
            complet(result,nil);
        } failHandler:^(NSError *err) {
            complet(nil,err);
        }];
    }else{
        // 低精度
        [[AipOcrService shardService]detectTextBasicFromImage:image withOptions:options successHandler:^(id result) {
            complet(result,nil);
        } failHandler:^(NSError *err) {
            complet(nil,err);
        }];
    }
}

@end
