//
//  QiFacade+getmodel.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+getmodel.h"

@implementation QiFacade (getmodel)

-(NSInteger)getTest
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:@"32" forKey:@"id"];

    __weak QiHttpRequest* request = [self httpRequest:SEVER_API
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
#pragma mark 获取司机三个月业绩
-(NSInteger)getDriverAccount
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/achievement?",SEVER_API];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma mark  获取城市列表
-(NSInteger)getCitysLIst
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:@"common"];
    [requestArray addObject:@"cities"];
    NSString *StringURL=[NSString stringWithFormat:@"%@",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsArrayGet2:StringURL paraArrar:requestArray];
    
    return IntegerPost;
}




#pragma mark 获取司机业绩月订单
-(NSInteger)getDriverAccountMonth:(NSString *)Month withpage:(NSString *)page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:page forKey:@"page"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/achievement/%@?",SEVER_API,Month];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;

}

#pragma mark 获取司机资料
-(NSInteger)getDriverInfo
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/account?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma mark 获取司机订单列表
-(NSInteger)getDriverOrderListPage:(NSString *)Page perPage:(NSString *)per_page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:Page forKey:@"page"];
     [requestDict setObject:per_page forKey:@"per_page"];

    NSString *StringURL=[NSString stringWithFormat:@"%@/order?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;

}

#pragma mark 获取司机订单详情
-(NSInteger)getDriverOrderDetailsID:(NSString *)OrderId;
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderId];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet2:StringURL paraArrar:requestArray];
    
    return IntegerPost;
 
}
#pragma mark 获取司机订单费用明细
-(NSInteger)getOrderCostDetailsID:(NSString *)OrderId
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderId];
    [requestArray addObject:@"fee"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsArrayGet2:StringURL paraArrar:requestArray];
    
    return IntegerPost;
}
#pragma mark   私有方法
-(NSInteger)handleDataIsDictionaryGet:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    __weak QiHttpRequest* request = [self httpRequest:Post
                                             paraDict:ParaDic
                                             userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
//            NSDictionary* responseDict =[[NSDictionary alloc] init];
//            id value = [response objectForKey:@"data"];
//            if([value isKindOfClass:[NSDictionary class]])
//            {
//                responseDict = value;
//            }
            
            [self callHttpObserver:response tag:request.tag success:YES];
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



-(NSInteger)handleDataIsDictionaryGet2:(NSString *)Post paraArrar:(NSArray*)ParaArray
{
    __weak QiHttpRequest* request = [self httpRequestGet:Post paraDict:ParaArray userInfo:nil];
    
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


-(NSInteger)handleDataIsArrayGet2:(NSString *)Post paraArrar:(NSArray*)ParaArray
{
    __weak QiHttpRequest* request = [self httpRequestGet:Post paraDict:ParaArray userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
//            NSArray* responseArray =[[NSArray alloc] init];
//            id value = [response objectForKey:@"data"];
//            NSString* Num=@"";
//            if([value isKindOfClass:[NSArray class]])
//            {
//                responseArray = value;
//            }
//            Num=[NSString stringWithFormat:@"%lu",(unsigned long)[responseArray count]];
//            NSMutableDictionary *responseDict=[[NSMutableDictionary alloc]init];
//            [responseDict setObject:responseArray forKey:@"data"];
//            [responseDict setObject:Num forKey:@"number"];

            [self callHttpObserver:response tag:request.tag success:YES];
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    return (NSInteger)request.tag;
}






@end
