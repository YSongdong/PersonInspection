//
//  YWTTools.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/8.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTTools : NSObject

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
// 字典转json字符串方法
+ (NSString *)convertToJsonData:(id)data;
// 对字符串base64加密
+(NSString *)base64EncodeString:(NSString *)string;
// 获取机型
+ (NSString *)getCurrentDeviceModel;
//图片显示 placeholderStr 默认图片
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString *)str andPlaceholder:(NSString *)placeholderStr;
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
// 获取当前时间的 时间戳
+(NSInteger)getNowTimestamp;
// 将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;
//判断身份证号码
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
// 通过aes 加密
+(NSString*) AES128Encrypt:(id)idt;
// 通过aes 解密
+(NSString*) AES128Decrypt:(id)idt;


@end

NS_ASSUME_NONNULL_END
