//
//  NSString+YWTExpand.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/30.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YWTExpand)
//提取字符串中的所有数字
+(NSString*) getStringNumber:(NSString*)string;
// 提取证件号
+(NSString *) getIdentNumberStr:(NSString*)string;
// 去掉空格
+(NSString*) getCharacSetString:(NSString*)string;
// 根据规则pattern  替换成空 
+(NSString*) getStringPattern:(NSString*)pattern allStr:(NSString*)string;
// 提取中文
+(NSArray*) getStringChinaStr:(NSString*)string;
// 根据中文 替换成空
+(NSString*) getStringChinaReplaceArr:(NSArray*)arr andStr:(NSString*)string;
// 提取中文 替换成空
+(NSString *)getAStringOfChineseWord:(NSString *)string;

//AES128位加密 base64编码 注：kCCKeySizeAES128点进去可以更换256位加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
// 判断字符串是否在百家姓内  
+(BOOL) jumpBookOfFamilyName:(NSString*)nameStr;

@end

NS_ASSUME_NONNULL_END
