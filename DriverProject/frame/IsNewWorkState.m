//
//  IsNewWorkState.m
//  DriverProject
//
//  Created by lixin on 2017/6/28.
//  Copyright © 2017年 广州市优玩科技有限公司. All rights reserved.
//

#import "IsNewWorkState.h"

static IsNewWorkState *isNetwork = nil;

@implementation IsNewWorkState

#pragma mark - - 单例类
+ (IsNewWorkState *)IsNewWorkStateShareInstance{
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            isNetwork = [[IsNewWorkState alloc]init];
        });
        return isNetwork;
        
    }
    
    //========================  全局网络监测  ===================
    
#pragma mark  - - 全局网络状态监测
+ (AFNetworkReachabilityStatus)ln_networkShareInstance
{
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager managerForDomain:@"http://www.baidu.com"];
    [networkManager startMonitoring];
    
    __block AFNetworkReachabilityStatus networkStatus;
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        networkStatus = status;
        NSLog(@"当前网络状态 = %ld",(long)status);
        
    }];
    return networkStatus;
    
}

@end
