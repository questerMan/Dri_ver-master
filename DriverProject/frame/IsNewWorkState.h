//
//  IsNewWorkState.h
//  DriverProject
//
//  Created by lixin on 2017/6/28.
//  Copyright © 2017年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface IsNewWorkState : NSObject

+ (IsNewWorkState *)IsNewWorkStateShareInstance;

/**
 *  全局网络监测
 *
 *  @return 当前网络状态
 */
+ (AFNetworkReachabilityStatus)ln_networkShareInstance;

@end
