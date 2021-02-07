//
//  YWTHttpManager.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/7.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface YWTHttpManager : NSObject
// 单例
+(YWTHttpManager*)sharedManager;
// 取消当前请求
- (void)cancelRequest;
/// post 请求数据
/// @param url  请求地址
/// @param param 请求参数
/// @param waitView 请求view  (waitView 等于nil  表示不显示请求view)
/// @param complet 请求数据Block
-(void)postRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:( UIView * _Nullable)waitView complateHandle:(void(^)(id showdata,NSString*error))complet;

/// get 请求数据
/// @param url  请求地址
/// @param param 请求参数
/// @param waitView 请求view  (waitView 等于nil  表示不显示请求view)
/// @param complet 请求数据Block
-(void)getRequestUrl:(NSString*)url params:(NSDictionary*)param waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString*error))complet;

///   上传
/// @param url 请求地址
/// @param param 请求参数
/// @param array 数据源
/// @param receiveStr 接收字段
/// @param waitView  请求view  (waitView 等于nil  表示不显示请求view)
/// @param complet 回调
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array andReceive:(NSString*)receiveStr  waitView:(UIView *__nullable)waitView complateHandle:(void(^)(id showdata,NSDictionary *error))complet;

// 取消当前请求
- (void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
