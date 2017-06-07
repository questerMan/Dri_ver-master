//
//  QiHttpRequestQueue.m
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "QiHttpRequestQueue.h"

#define MAX_COUNT 5


@implementation QiHttpRequestQueue
{
    ASINetworkQueue         *_networkQueue;
}

DEF_SINGLETON(QiHttpRequestQueue)


-(id)init
{
    self = [super init];
    if (self)
    {
        _networkQueue = [[ASINetworkQueue alloc]init];
        [_networkQueue setMaxConcurrentOperationCount:MAX_COUNT];
        [_networkQueue go];
    }
    
    return self;
}

-(void)dealloc
{
    [self cancelAllRequest];
}


-(void)addOperation:(NSOperation *)op
{
    [_networkQueue addOperation:op];
}

- (NSArray *)operations
{
    return [_networkQueue operations];
}

-(void)cancelHttpRquestWithTag:(NSInteger)iRequestTag
{
    for (ASIHTTPRequest *request in [_networkQueue operations])
    {
        if (request.tag == iRequestTag)
        {
            [request clearDelegatesAndCancel];
            break;
        }
    }
}

-(void)cancelAllRequest
{
    for (ASIHTTPRequest *request in [_networkQueue operations])
    {
        [request clearDelegatesAndCancel];
    }
    
    [_networkQueue cancelAllOperations];
}

@end
