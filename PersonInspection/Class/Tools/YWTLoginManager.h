//
//  YWTSelectServerManager.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWTLoginManager : NSObject

+ (instancetype)shareInstance;

// 保存用户信息
+ (void) saveLoginModel:(NSDictionary*)dict;
// 删除用户信息
+ (void) delLoginModel;
// 判断是否登录
+ (BOOL) judgePassLogin;


// ----------------取出数据----------
//获取 用户id
+(NSString *) obtainWithUserId;
//获取 登录名称
+(NSString *) obtainWithUsername;
//获取 token
+(NSString *) obtainWithToken;
//获取 用户名称
+(NSString *) obtainWithRealName;
//获取 用户电话
+(NSString *) obtainWithPhone;
//获取 单位名称 
+(NSString *) obtainWithOrganizationName;

@end


