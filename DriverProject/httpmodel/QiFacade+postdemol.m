//
//  QiFacade+postdemol.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+postdemol.h"

@implementation QiFacade (postdemol)


#pragma mark   登录
- (NSInteger)postLogon:(NSString *)phone password:(NSString *)password
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:password forKey:@"password"];
//    [requestDict setObject:@"15218817202" forKey:@"phone"];
//    [requestDict setObject:@"111111" forKey:@"password"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/login?",SEVER_API];
    
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost; 
}

#pragma    mark 心跳  持续定位
-(NSInteger)postHeartbeat:(NSString *)lat pointlon:(NSString *)lon
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    
    NSString *poatURL=[NSString stringWithFormat:@"%@/account/track?",SEVER_API];
    
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma    mark 忘记密码
-(NSInteger)postForgetPassord:(NSString *)phone password:(NSString *)password vcode:(NSString *)code
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:password forKey:@"password"];
    [requestDict setObject:code forKey:@"vcode"];
    
//    [requestDict setObject:@"15218817202" forKey:@"phone"];
//    [requestDict setObject:@"111111" forKey:@"password"];
//    [requestDict setObject:@"1234" forKey:@"vcode"];
    
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/forgot?",SEVER_API];
    

    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost;

}

#pragma    mark 发送验证码

-(NSInteger)postGetCodeWithphone:(NSString *)phone
{
    
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];

    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:@"1" forKey:@"time"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/send_code?",SEVER_API];

    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];

    return IntegerPost;
    
}

#pragma mark   私有方法

-(NSInteger)handleDataIsDictionaryPost:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{

    __weak QiHttpRequest* request = [self httpRequestPost:Post
                                                 paraDict:ParaDic
                                                 userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            NSDictionary* responseDict =[[NSDictionary alloc] init];
            id value = [response objectForKey:@"data"];
            if([value isKindOfClass:[NSDictionary class]])
            {
                responseDict = value;
            }
            
            [self callHttpObserver:responseDict tag:request.tag success:YES];
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    return request.tag;
}


-(NSInteger)handleDataIsStringPost:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestPost:Post
                                                 paraDict:ParaDic
                                                 userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            if ([response isKindOfClass:[NSDictionary class]])
            {
                [self callHttpObserver:response tag:request.tag success:YES];
                
            }
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    
    return request.tag;
}


@end
