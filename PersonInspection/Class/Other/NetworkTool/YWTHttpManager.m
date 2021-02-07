//
//  YWTHttpManager.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/7.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTHttpManager.h"

static AFHTTPSessionManager *afnManager = nil;

@implementation YWTHttpManager
// 单例
+(YWTHttpManager*)sharedManager{
    static YWTHttpManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[super allocWithZone:nil]init];
    });
    return httpManager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [YWTHttpManager sharedManager];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        afnManager = [AFHTTPSessionManager manager];
        afnManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc]init];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        afnManager.securityPolicy = securityPolicy;
        //返回结果支持的类型
        NSArray *contentTypeArr = @[@"application/json",@"text/json",@"text/plain",@"text/html",@"text/xml"];
        afnManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypeArr];
        // 3.设置超时时间为20s
        afnManager.requestSerializer.timeoutInterval = 20;
        
    }
    return self;
}

// post 请求数据
-(void)postRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:(UIView * _Nullable )waitView complateHandle:(void(^)(id showdata,NSString*error))complet{
    // 转换编码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
            HUD.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
        });
    }
    
    // 将token封装入请求头
    NSString *token = [YWTLoginManager judgePassLogin] ? [YWTLoginManager obtainWithToken] : @"";
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [afnManager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    // 设备型号
    [afnManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Type"];
    // 设备型号
    [afnManager.requestSerializer setValue:[YWTTools getCurrentDeviceModel] forHTTPHeaderField:@"Model"];
           
    
    [afnManager POST:encodeUrl parameters:param  headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，2000即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        if ([code integerValue] == 2000 || [code integerValue] == 200) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"data"]= responseObject[@"data"];
            param[@"count"] = responseObject[@"count"];
            param[@"page"] = responseObject[@"page"];
            complet(param,nil);
        }else if([code integerValue] == 4008){
            // token 失效
            NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            [self showPromptView:msgStr];
        }else{
            complet(nil,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
}

-(void)getRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString*error))complet{
    // 转换编码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
            HUD.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
        });
    }
   
    // 将token封装入请求头
    NSString *token = [YWTLoginManager judgePassLogin] ? [YWTLoginManager obtainWithToken] : @"";
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [afnManager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    // 设备型号
    [afnManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Type"];
    // 设备型号
    [afnManager.requestSerializer setValue:[YWTTools getCurrentDeviceModel] forHTTPHeaderField:@"Model"];
       
    
    [afnManager GET:encodeUrl parameters:param headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，200即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        if ([code integerValue] == 2000) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"data"]= responseObject[@"data"];
            param[@"count"] = responseObject[@"count"];
            param[@"page"] = responseObject[@"page"];
            complet(param,nil);
        }else if([code integerValue] == 4008){
            // token 失效
            NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            [self showPromptView:msgStr];
        }else{
            complet(nil,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
}

///   上传
/// @param url 请求地址
/// @param param 请求参数
/// @param array 数据源
/// @param receiveStr 接收字段
/// @param waitView  请求view  (waitView 等于nil  表示不显示请求view)
/// @param complet 回调
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array andReceive:(NSString*)receiveStr  waitView:(UIView *__nullable)waitView complateHandle:(void(^)(id showdata,NSDictionary *error))complet{
    // 转换编码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
            HUD.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
        });
    }
    
    // 将token封装入请求头
    NSString *token = [YWTLoginManager judgePassLogin] ? [YWTLoginManager obtainWithToken] : @"";
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [afnManager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    // 设备型号
    [afnManager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Type"];
    // 设备型号
    [afnManager.requestSerializer setValue:[YWTTools getCurrentDeviceModel] forHTTPHeaderField:@"Model"];
    
    [afnManager POST:encodeUrl parameters:param headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<array.count; i++) {
            UIImage *image = array[i];
            NSData *imageData = [self imageCompressToData:image];
            
            // 文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyy-MM-ddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:receiveStr fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，200即为服务器查询成功，4008服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        if ([code integerValue] == 2000) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"data"]= responseObject[@"data"];
            param[@"count"] = responseObject[@"count"];
            param[@"page"] = responseObject[@"page"];
            complet(param,nil);
        }else if([code integerValue] == 4008){
            // token 失效
            NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            [self showPromptView:msgStr];
        } else{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"code"] = responseObject[@"code"];
            param[@"message"] = responseObject[@"message"];
            complet(nil,param);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"code"] = [NSNumber numberWithInteger:error.code];
        param[@"message"] = @"网络错误";
        complet(nil,param);
    }];
}
//显示
-(void) showPromptView:(NSString *)alertMsg{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //删除
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除本地用户信息
        [YWTLoginManager delLoginModel];
        
        YWTLoginController *loginVC = [[YWTLoginController alloc]init];
        appdel.window.rootViewController = loginVC;
        
    }]];
    [appdel.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
//压缩图片
- (NSData *)imageCompressToData:(UIImage *)image{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>300*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>300*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}
// 取消当前请求
- (void)cancelRequest{
    if ([afnManager.tasks count] > 0) {
        [afnManager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

#pragma mark ---- 处理从服务返回的NSDictionary值为NSNull 或者 <null> 问题
-(id) processDictionaruISNSNull:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for (NSString *key in [dt allKeys]) {
            id object =  [dt objectForKey:key];
            if ([object isEqual:[NSNull null]]) {
                [dt setObject:@"" forKey:key];
            }else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:@"" forKey:key];
                }
            }else if ([object isKindOfClass:[NSArray class]]){
                NSArray *arr =(NSArray*)object;
                arr = [self processDictionaruISNSNull:arr];
                [dt setObject:arr forKey:key];
            }else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = [self processDictionaruISNSNull:ddc];
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }else if ([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *da = [(NSMutableArray*)obj mutableCopy];
        for (int i= 0; i<[da count]; i++) {
            NSDictionary *ddc = [obj objectAtIndex:i];
            ddc = [self processDictionaruISNSNull:ddc];
            [da replaceObjectAtIndex:i withObject:ddc];
        }
        return [da copy];
    }else{
        return obj;
    }
}




@end
