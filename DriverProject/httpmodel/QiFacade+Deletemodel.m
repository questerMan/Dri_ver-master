//
//  QiFacade+Deletemodel.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+Deletemodel.h"

@implementation QiFacade (Deletemodel)





-(NSInteger)DeleteTest
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:@"32" forKey:@"id"];
    
    
    
    
    __weak QiHttpRequest* request = [self httpRequestDelete:SEVER_API
                                                 paraDict:requestDict
                                                 userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        NSLog(@"REQUEST respone:------   %@", request);
        id response = [request jsonValue];
        
        NSLog(@"REQUEST respone:%@", response);
      
        if ([self requestSuccess:response])
        {
            NSString* strMsg = @"";
            id value = [response objectForKey:@"data"];
            if ([value isKindOfClass:[NSString class]])
            {
                strMsg = value;
            }
            
            NSDictionary* responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          response, @""
                                          ,strMsg, @""
                                          ,request.userInfo, @""
                                          ,nil];
            
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
#pragma mark 退出
-(NSInteger)deleteDriverSignOut
{

    NSString *StringURL=[NSString stringWithFormat:@"%@/account?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringDelete:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma mark   私有方法

-(NSInteger)handleDataIsStringDelete:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestDelete:Post paraDict:ParaDic userInfo:nil];
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
