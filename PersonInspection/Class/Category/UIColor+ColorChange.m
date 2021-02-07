//
//  UIColor+ColorChange.m
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UIColor+ColorChange.h"

@implementation UIColor (ColorChange)

//文字白色
+ (UIColor *) colorTextWhiteColor{
    return [UIColor colorWithHexString:@"#ffffff"];
}
//文字F2F2白色
+ (UIColor *) colorF2F2TextWhiteColor{
    return  [UIColor colorWithHexString:@"#f2f2f2"];
}
//提示文字颜色
+ (UIColor *) colorPlaceholderTextColor{
    return [UIColor colorWithHexString:@"#cccccc"];
}
//文字蓝色颜色
+ (UIColor *) colorBlueTextColor{
    if (KTargetPerson_CS) {
        return [UIColor colorWithHexString:@"#00796a"];
    }else{
       return [UIColor colorWithHexString:@"#3675fc"];
    }
}
// 文字红色颜色
+ (UIColor *) colorRedTextColor{
    return [UIColor colorWithHexString:@"#ff0000"];
}
// 背景颜色
+ (UIColor *) color1e1eTextColor{
    return [UIColor colorWithHexString:@"#1e1e1e"];
}
// 默认文字98号颜色
+ (UIColor *) colorNamlCommon98TextColor{
    return [UIColor colorWithHexString:@"#989898"];
}
// 文字筛选颜色
+ (UIColor *) colorSiftTextColor{
    return [UIColor colorWithHexString:@"#f5f6f9"];
}
// 默认文字颜色
+ (UIColor *) colorNamlCommonTextColor{
    return [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#e6e6e6"] normalCorlor:[UIColor colorWithHexString:@"#282828"]];
}
// 默认文字65号颜色
+ (UIColor *) colorNamlCommon65TextColor{
    return [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorNamlCommon98TextColor] normalCorlor:[UIColor colorWithHexString:@"#656565"]];
}

// 默认线条颜色
+ (UIColor *) colorLineCommonTextColor{
    return [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#404856"] normalCorlor:[UIColor colorWithHexString:@"#e6e6e6"]];
}
//View背景白色
+ (UIColor *) colorViewBackGrounpWhiteColor{
    return [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowDarkBlackColor] normalCorlor:[UIColor colorTextWhiteColor]];
}
// viewF2f2背景白色
+ (UIColor *) colorViewF2F2BackGrounpWhiteColor{
     return  [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewDarkBlackColor] normalCorlor:[UIColor colorF2F2TextWhiteColor]];
}
// viewF2f6背景白色
+ (UIColor *) colorViewF2F6BackGrounpWhiteColor{
    return  [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowerDarkBlackColor] normalCorlor:[UIColor colorWithHexString:@"#f2f6ff"]];
}

/*------------------------  黑暗模式            -----------*/
// 深黑色 view
+ (UIColor *) colorViewDarkBlackColor{
    return [UIColor colorWithHexString:@"#151e2f"];
}
// 浅黑色 view
+ (UIColor *) colorViewShallowDarkBlackColor{
    return [UIColor colorWithHexString:@"#1e2838"];
}
// 更浅黑色 view
+ (UIColor *) colorViewShallowerDarkBlackColor{
    return [UIColor colorWithHexString:@"#263143"];
}




// 适配黑暗模式的颜色
+ (UIColor *) colorStyleLeDarkWithConstantColor:(UIColor*)ConstantColor normalCorlor:(UIColor*)normalColor{
    if (@available(iOS 13.0, *)) {
         return  [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if ([traitCollection userInterfaceStyle] == UIUserInterfaceStyleDark) {
                return ConstantColor;
            }else{
                return normalColor;
            }
        }];
    }else{
        return normalColor;
    }
}


+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat) alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

@end
