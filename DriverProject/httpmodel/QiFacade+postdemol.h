//
//  QiFacade+postdemol.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"

@interface QiFacade (postdemol)


#pragma    mark 登录界面

-(NSInteger)postLogon:(NSString *)phone password:(NSString *)password;


#pragma    mark 忘记密码

-(NSInteger)postForgetPassord:(NSString *)phone password:(NSString *)password vcode:(NSString *)code;


#pragma    mark 发送验证码
-(NSInteger)postGetCodeWithphone:(NSString *)phone;



#pragma    mark 心跳  持续定位
-(NSInteger)postHeartbeat:(NSString *)lat pointlon:(NSString *)lon;


@end
