//
//  YWTSelectServerManager.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/20.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTLoginManager.h"

@implementation YWTLoginManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance ;
}
// 保存用户信息
+ (void) saveLoginModel:(NSDictionary*)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:dict forKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
// 删除用户信息
+ (void) delLoginModel{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    //用户信息
    [userD removeObjectForKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
// 判断是否登录
+ (BOOL) judgePassLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Login"]) {
        return YES;
    }else{
        return NO;
    }
}

// -----------------取出数据---------
//获取 用户id
+(NSString *) obtainWithUserId{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"user_id"]];
    return userIdStr;
}
//获取 登录名称
+(NSString *) obtainWithUsername{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"username"]];
    return userIdStr;
}
//获取 token
+(NSString *) obtainWithToken{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"token"]];
    return userIdStr;
}
//获取 用户名称
+(NSString *) obtainWithRealName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"real_name"]];
    return userIdStr;
}
//获取 用户电话
+(NSString *) obtainWithPhone{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"phone"]];
    return userIdStr;
}
//获取 用户电话
+(NSString *) obtainWithOrganizationName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",dict[@"organization_name"]];
    return userIdStr;
}

@end
