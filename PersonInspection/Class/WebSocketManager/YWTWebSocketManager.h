//
//  YWTWebSocketManager.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/8.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

typedef NS_ENUM(NSUInteger,WebSocketConnectType){
    WebSocketDefault = 0, //初始状态,未连接
    WebSocketConnect,      //已连接
    WebSocketDisconnect    //连接后断开
};
@protocol WebSocketManagerDelegate <NSObject>
// 连接失败
-(void) connectionWebSocketError:(NSString*)msg;
// 验证webSocket成功回调
-(void) verificationWebSocketSuccess;
// 接收到服务器的数据
- (void)webSocketManagerDidReceiveMessageWithDict:(NSDictionary*)dict;

@end

@interface YWTWebSocketManager : NSObject
@property (nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic,weak)  id<WebSocketManagerDelegate > delegate;
@property (nonatomic, assign)   BOOL isConnect;  //是否连接
@property (nonatomic, assign)   WebSocketConnectType connectType;

+ (instancetype)shared;
//建立长连接
- (void)connectServer;
//重新连接
- (void)reConnectServer;
//关闭长连接
- (void)RMWebSocketClose;
//发送数据给服务器
- (void)sendDataToServer:(NSString *)data;

@end


