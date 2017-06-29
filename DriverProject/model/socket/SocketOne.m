//
//  SocketOne.m
//  trip
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州丽新汽车服务有限公司. All rights reserved.
//

#import "SocketOne.h"

@implementation SocketOne


static SocketOne *sharedInstance = nil;
// 单例模式
+(SocketOne *)sharedInstance {
    if (nil == sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^(void) {
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

-(void)connect:(NSString *)ip withPort:(NSInteger)port {
    self.ip = ip;
    self.port = port;
    
    // 连接前先断开已有连接，否则会异常
    self.socket.userData = DisconnectByUser;
    [self disconnect];
    
    self.socket.userData = DisconnectByServer;
    [self connect];
}

// 连接端口
-(void)connect {
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError* err = nil;
    [self.socket connectToHost:self.ip onPort:self.port error:&err];
}

// 主动断开连接
-(void)disconnect {
    self.socket.userData = DisconnectByUser;
    [self.keepAliveTimer invalidate];
    [self.socket disconnect];
}

// 发送数据
-(void)send:(NSString *)text {
    text = [text stringByAppendingString:@"\n"];
    [self.socket writeData:[text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
}

// 心跳方法
-(void)keepAlive {
//    [self send:@"1\n"];
    NSData *data = [@"1\n" dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}

#pragma mark - 实现AsyncSocketDelegate回调
// 连接成功
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"SOCKET连接成功");
    self.keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
    [self.keepAliveTimer fire];
    
    // 开始监听数据
    [self.socket readDataWithTimeout:40 tag:0];
    
    // send
}

// 断连回调
-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"SOCKET连接断掉了, %ld", sock.userData);
    if (sock.userData == DisconnectByServer) {
        // 掉线重连
        [self connect];
    } else {
        // 用户主动断开，不需要重连
        return;
    }
}
//static int  KK=0;
// 接收数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSDictionary *orderDic=[self DicFromJson:data];
    [self.socket readDataWithTimeout:30 tag:0];
    
   
//    KK++;
//    if(KK==3)
//    {
//        KK=0;
//        
//        NSDictionary *orderDic=[[NSDictionary alloc] initWithObjectsAndKeys:@"22344",@"origin",@"12332",@"destination",@"12328",@"pre_time",@"1",@"order_type", nil];
//        
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"NewOrderNotifi" object:nil userInfo:orderDic];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    }
    
    
    
    NSString *action=[orderDic objectForKey:@"action"];

    if(orderDic) {
        if ([action isEqualToString:@"order_new"]||[action isEqualToString:@"order_accept"]) {
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"NewOrderNotifi" object:nil userInfo:orderDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else if([action isEqualToString:@"order_cancel"])//取消订单
        {
            NSNotification *notification =[NSNotification notificationWithName:@"CancelOrderNotifi" object:nil userInfo:orderDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else if([action isEqualToString:@"order_paid"])//订单已支付
        {
            NSNotification *notification =[NSNotification notificationWithName:@"PaidOrderNotifi" object:nil userInfo:orderDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else if([action isEqualToString:@"order_invoice"])  //发票
        {
            NSNotification *notification =[NSNotification notificationWithName:@"InvoiceOrderNotifi" object:nil userInfo:orderDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}

-(NSDictionary *)DicFromJson:(NSData *)response
{
    NSError *error;
    NSDictionary *orderDic=[[NSDictionary alloc] init];
    orderDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"orderDic字典里面的内容为--》%@", orderDic );
    if (error != nil)
    {
        return nil;
    }
    return orderDic;
}

/*

 {
 action = "order_new";
 "des_lat" = "23.099586";
 "des_lon" = "113.32536";
 destination = "\U7ec8\U70b9\U7b80\U79f0\Uff0c\U5982\U7436\U6d32\U58f9\U53f7";
 "destination_detail" = "\U7ec8\U70b9\U5168\U5730\U5740\Uff0c\U5e7f\U5dde\U5e02\U6d77\U73e0\U533axxx\U5546\U4e1a\U4e2d\U5fc34B-101";
 "order_id" = 257;
 "order_type" = 2;
 "ori_lat" = "23.119884";
 "ori_lon" = "113.412463";
 origin = "\U666e\U901a\U9884\U7ea6\U5355";
 "origin_detail" = "\U8d77\U70b9\U5168\U5730\U5740\Uff0c\U5e7f\U5dde\U5e02\U6d77\U73e0\U533axxx\U5546\U4e1a\U4e2d\U5fc34B-101";
 "pre_time" = "09\U670824\U65e5 06:10";
 }


*/

@end
