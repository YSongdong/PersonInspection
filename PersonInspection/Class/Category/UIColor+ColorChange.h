//
//  UIColor+ColorChange.h
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

//文字白色
+ (UIColor *) colorTextWhiteColor;
//文字F2F2白色
+ (UIColor *) colorF2F2TextWhiteColor;
//提示文字颜色
+ (UIColor *) colorPlaceholderTextColor;
//文字蓝色颜色
+ (UIColor *) colorBlueTextColor;
// 文字红色颜色
+ (UIColor *) colorRedTextColor;
// 文字筛选颜色
+ (UIColor *) colorSiftTextColor;
// 背景颜色
+ (UIColor *) color1e1eTextColor;
// 默认文字颜色
+ (UIColor *) colorNamlCommonTextColor;
// 默认文字65号颜色
+ (UIColor *) colorNamlCommon65TextColor;
// 默认文字98号颜色
+ (UIColor *) colorNamlCommon98TextColor;
// 默认线条颜色
+ (UIColor *) colorLineCommonTextColor;
//View背景白色
+ (UIColor *) colorViewBackGrounpWhiteColor;
// viewF2f2背景白色
+ (UIColor *) colorViewF2F2BackGrounpWhiteColor;
// viewF2f6背景白色
+ (UIColor *) colorViewF2F6BackGrounpWhiteColor;
// 适配黑暗模式的颜色
+ (UIColor *) colorStyleLeDarkWithConstantColor:(UIColor*)ConstantColor normalCorlor:(UIColor*)normalColor;
// 颜色
+ (UIColor *) colorWithHexString: (NSString *)color;


/*------------------------  黑暗模式            -----------*/
// 深黑色 view
+ (UIColor *) colorViewDarkBlackColor;
// 浅黑色 view
+ (UIColor *) colorViewShallowDarkBlackColor;
// 更浅黑色 view
+ (UIColor *) colorViewShallowerDarkBlackColor;





@end
