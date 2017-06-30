//
//  QiFacade+putmodel.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+putmodel.h"

@implementation QiFacade (putmodel)




-(NSInteger)putTest
{
    
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:@"32" forKey:@"id"];
    
    
    
    
    __weak QiHttpRequest* request = [self httpRequestPut:SEVER_API
                                                 paraDict:requestDict
                                                 userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        NSLog(@"REQUEST respone:------   %@", request);
        id response = [request jsonValue];
        
        NSLog(@"REQUEST respone:%@", response);
        //return ;
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
#pragma mark 签退
-(NSInteger)putDriverSignoutState:(NSString *)state reasonFor:(NSString *)reason
{
    NSMutableDictionary* requestDict =nil;
    requestDict = [NSMutableDictionary new];
    [requestDict setObject:state forKey:@"state"];
    [requestDict setObject:reason forKey:@"reason"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/account/offline?",SEVER_API];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];

    return IntegerPost;
}


#pragma mark 出勤
-(NSInteger)putDriverAttendance
{
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/account/online",SEVER_API];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma mark 司机应单
-(NSInteger)putreplyOrder:(NSString *)OrderID
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;


}

-(NSInteger)putreplyOrder:(NSString *)OrderID lon:(NSString *)lon lat:(NSString *)lat
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/order/%@?",SEVER_API,OrderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;
}







#pragma mark 司机代付
-(NSInteger)putrDriverPaid:(NSString *)OrderID
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    [requestArray addObject:@"paid"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;
    

}


#pragma mark 司机代付
-(NSInteger)putrpaidOrder:(NSString *)OrderID
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    [requestArray addObject:@"paid"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;

}


#pragma mark 司机前往接客
-(NSInteger)putDriverPickUp:(NSString *)OrderID
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    [requestArray addObject:@"paid"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;
}

#pragma mark 司机前往接客点
-(NSInteger)putDriverPickUpPoint:(NSString *)OrderID
{
    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    [requestArray addObject:@"arrive"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;


}

//#pragma mark  乘客上车
//-(NSInteger)putDriverOnthetrain:(NSString *)OrderID
//{
//    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
//    [requestArray addObject:OrderID];
//    [requestArray addObject:@"get_on"];
//    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
//    
//    NSInteger IntegerPost=0;
//    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
//    
//    return IntegerPost;
//}
//#pragma mark  乘客下车
//-(NSInteger)putDriverdownthetrain:(NSString *)OrderID
//{
//    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
//    [requestArray addObject:OrderID];
//    [requestArray addObject:@"get_off"];
//    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
//    
//    NSInteger IntegerPost=0;
//    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
//    
//    return IntegerPost;
//}

#pragma mark  现金支付
-(NSInteger)putDriverCashpayment:(NSString *)OrderID
{

    NSMutableArray *requestArray=[[NSMutableArray alloc]init];
    [requestArray addObject:OrderID];
    [requestArray addObject:@"cash"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/order",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut2:StringURL paraArray:requestArray];
    
    return IntegerPost;



}
#pragma mark 出发
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon  distance:(NSString *)dis
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    [requestDict setObject:dis forKey:@"distance"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/%@?",SEVER_API,OrderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;

}
#pragma mark 上车&&途中&&到达
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon
{

    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/%@?",SEVER_API,OrderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma mark   行程中
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon  segment:(NSString *)segment distance:(NSString *)dis
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    [requestDict setObject:segment forKey:@"segment"];
    [requestDict setObject:dis forKey:@"distance"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/%@?",SEVER_API,OrderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;



}
#pragma mark 下车
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon distance:(NSString *)dis  ext:(NSString *)ext
{

    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:lat forKey:@"lat"];
    [requestDict setObject:lon forKey:@"lon"];
    [requestDict setObject:dis forKey:@"distance"];
    [requestDict setObject:ext forKey:@"ext"];
    NSString *StringURL=[NSString stringWithFormat:@"%@/%@?",SEVER_API,OrderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;

}




#pragma mark   +++++++++++++++++++++++++++++++
#pragma mark   私有方法

-(NSInteger)handleDataIsStringPut:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestPut:Post
                                                 paraDict:ParaDic
                                                 userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            if ([response isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:response];
                [self callHttpObserver:dic tag:request.tag success:YES];
                
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

-(NSInteger)handleDataIsStringPut2:(NSString *)Post paraArray:(NSArray *)ParaArray
{
    
    __weak QiHttpRequest* request = [self httpRequestPut:Post paraArray:ParaArray userInfo:nil];
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
