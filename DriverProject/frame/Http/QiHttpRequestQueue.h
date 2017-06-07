//
//  QiHttpRequestQueue.h
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "QiHttpRequest.h"
#import "QiMacro.h"

@interface QiHttpRequestQueue : NSObject

AS_SINGLETON(QiHttpRequestQueue)


- (NSArray *)operations;

//添加请求到队列
-(void)addOperation:(NSOperation *)op;

//从队列中取消请求
-(void)cancelHttpRquestWithTag:(NSInteger)iRequestTag;

//取消所有请求
-(void)cancelAllRequest;

@end
