//
//  SocketOne.h
//  trip
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州丽新汽车服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \

enum{
    DisconnectByServer,
    DisconnectByUser,
};

@interface SocketOne : NSObject <AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket *socket; // 本案Socket套接字
@property (nonatomic, copy) NSString *ip; // 服务器IP
@property (nonatomic, assign)UInt16 port; // 服务器端口
@property (nonatomic, retain)NSTimer *keepAliveTimer; //心跳

+(SocketOne*)sharedInstance;

-(void)connect:(NSString*)ip withPort:(NSInteger)port; // 开始连接
-(void)connect; // 开始socket连接
-(void)disconnect; // 断开socket连接
-(void)send:(NSString *)text; // 发送数据

@end
