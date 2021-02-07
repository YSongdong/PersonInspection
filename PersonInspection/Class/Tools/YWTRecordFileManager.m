//
//  YWTRecordFileManager.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/2.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordFileManager.h"

@implementation YWTRecordFileManager
// 新建文件地址
+(NSString*) newFilePath{
    //获取本地沙盒Document路径
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentPath objectAtIndex:0];
    //在Document路径下拼接文件名字
    NSString *plistPath = [path stringByAppendingPathComponent:@"recodList.plist"];
    return plistPath;
}
// 判断文件地址是否存在
+(BOOL) jumpConfigFilePath:(NSString*)filePath{
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return isFile;
}
// 获取文件路径
+(NSString*) getObtainFilePath{
    //在Document路径下拼接文件名字
    NSString *plistPath = [YWTRecordFileManager newFilePath];
    BOOL isFile = [YWTRecordFileManager jumpConfigFilePath:plistPath];
    if (!isFile) {
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
    }
    return plistPath;
}

// plist 写入数据
+(void) getWritePlistFile:(NSDictionary*)dict{
    // 创建文件路径
    NSString *filePath = [YWTRecordFileManager getObtainFilePath];
    // 获取整个文件的数据
    NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:[YWTRecordFileManager getObtainAllDataFilePath:[YWTRecordFileManager getObtainFilePath]]];
    if (arr.count > 4) {
        [arr removeObjectAtIndex:0];
        [arr addObject:dict];
    }else{
        [arr addObject:dict];
    }
    // 加密
    NSString *jsonStr = [YWTTools AES128Encrypt:arr];
    
    [jsonStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
// 读取整个文件
+(NSArray*) getObtainAllDataFilePath:(NSString*)filePath{
    NSString *aesStr = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    // 解密
    NSString *jsonStr = [YWTTools AES128Decrypt:aesStr];
    // 解析
    NSArray *arr = [YWTRecordFileManager dictionaryWithJsonString:jsonStr];

    return arr;
}
// 移除地址
+ (void)removeFile:(NSString *)filePath{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

//JSON字符串转化为字典
+ (NSArray *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
           return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

@end
