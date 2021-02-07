//
//  AppDelegate.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/3/2.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "AppDelegate.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import <Bugly/Bugly.h>
#import "YWTWebSocketManager.h"
#import "YWTLoginController.h"
#import "YWTHomeController.h"
#import "FaceParameterConfig.h"

@interface AppDelegate ()<BMKLocationAuthDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 键盘
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    
//    // 崩溃收集
//    [Bugly startWithAppId:@"b95155e782"];
    
    //创建并初始化一个引擎对象
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
    BOOL ret=[manager start:@"YXSk8dpo0SisORf31vO19eD9R0WI7GYj" generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }
    // 百度定位
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"YXSk8dpo0SisORf31vO19eD9R0WI7GYj" authDelegate:self];
    
    // 人脸采集SDK
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    
    [[AipOcrService shardService] authWithAK:@"7O3xgkMCCpUquILMpDrn1pcd" andSK:@"TlTkzlvw737oolYdnvEXpQpV42UoGf4b"];
    
    //默认刷新样式
    [[KafkaRefreshDefaults standardRefreshDefaults] setHeadDefaultStyle:KafkaRefreshStyleReplicatorDot];
    [[KafkaRefreshDefaults standardRefreshDefaults] setFootDefaultStyle:KafkaRefreshStyleReplicatorDot];
    [[KafkaRefreshDefaults standardRefreshDefaults] setThemeColor:[UIColor colorBlueTextColor]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setupViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupViewController {
    if ([YWTLoginManager judgePassLogin]) {
        YWTHomeController *homeVC = [[YWTHomeController alloc]init];
        YWTNavigtationController *navi = [[YWTNavigtationController alloc]initWithRootViewController:homeVC];
        self.window.rootViewController = navi;
    }else{
       YWTLoginController *homeVC = [[YWTLoginController alloc]init];
       self.window.rootViewController = homeVC;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([YWTWebSocketManager shared].connectType == WebSocketDisconnect) {
        [[YWTWebSocketManager shared] connectServer];
    }
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    
}



@end
