//
//  YWTRecordFileManager.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/2.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTRecordFileManager : NSObject
// 新建文件地址
+(NSString*) newFilePath;
// 判断文件地址是否存在
+(BOOL) jumpConfigFilePath:(NSString*)filePath;
// 获取文件路径
+(NSString*) getObtainFilePath;
// plist 写入数据
+(void) getWritePlistFile:(NSDictionary*)dict;
// 读取整个文件
+(NSArray*) getObtainAllDataFilePath:(NSString*)filePath;
// 移除地址
+ (void)removeFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
