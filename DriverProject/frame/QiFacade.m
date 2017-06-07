//
//  QiFacade.m
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"
//#import "QiFacade+account.h"
//#import "QiFacade+command.h"
//#import "ConstDefine.h"

@implementation QiFacade
{
}

DEF_SINGLETON(QiFacade)

-(id)init
{
    self = [super init];
    if (self)
    {
        _httpRequestQueue = [[QiHttpRequestQueue alloc]init];
        _notificationCenter = [[NSNotificationCenter alloc]init];
        _httpObserverDict = [[NSMutableDictionary alloc]init];
        _activityCommandArray = [[NSMutableArray alloc]init];
        
        self.debugModel = YES;
        
    }
    
    return self;
}

-(void)dealloc
{
}


-(void)setDebugModel:(BOOL)debugModel
{
    _debugModel = debugModel;
    
    //兼容旧数据
   // self.systemInfoProxy.baseServerUrl = SEVER_API;
    
//    if (_debugModel)
//    {
//        self.systemInfoProxy.baseServerUrl = BASE_URL_DEBUG;
//    }
//    else
//    {
//        self.systemInfoProxy.baseServerUrl = BASE_URL;
//    }
}
/*
#pragma mark proxy
-(SystemInfoProxy*)systemInfoProxy
{
    if (_systemInfoProxy == nil)
    {
        _systemInfoProxy = [[SystemInfoProxy alloc]init];
    }
    
    return _systemInfoProxy;
}

-(UserProxy*)currentUserProxy
{
    if (_currentUserProxy == nil)
    {
        _currentUserProxy = [[UserProxy alloc]init];
    }
    
    return _currentUserProxy;
}

-(PaymentProxy*)paymentProxy
{
    if (_paymentProxy == nil)
    {
        _paymentProxy = [[PaymentProxy alloc]init];
    }
    
    return _paymentProxy;
}

-(DatabaseProxy*)databaseProxy
{
    if (_databaseProxy == nil)
    {
        _databaseProxy = [[DatabaseProxy alloc]init];
    }
    
    return _databaseProxy;
}
*/

#pragma mark  消息相关接口
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName
{
    [_notificationCenter addObserver:observer selector:aSelector name:aName object:nil];
}

- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo;
{
    [_notificationCenter postNotificationName:aName object:nil userInfo:aUserInfo];
}

- (void)removeObserver:(id)observer
{
    [_notificationCenter removeObserver:observer];
}

- (void)removeObserver:(id)observer name:(NSString *)aName
{
    [_notificationCenter removeObserver:observer name:aName object:nil];
}

#pragma mark HTTP请求观察者相关接口
//添加HTTP请求观察者
-(void)addHttpObserver:(id)observer tag:(NSInteger)iRequestTag
{
    if (observer)
    {
        [_httpObserverDict setObject:observer
                              forKey:[NSNumber numberWithInt:(int)iRequestTag]];
    }
}

//移除HTTP请求观察者
-(void)removeHttpObserver:(id)observer
{
    NSArray* keyArray = [_httpObserverDict allKeys];
    NSObject* key = nil;
    NSMutableArray* delKeyArray = [NSMutableArray array];
    for (int i = 0; i < [keyArray count]; ++i)
    {
        key = [keyArray objectAtIndex:i];
        if ([_httpObserverDict objectForKey:key] == observer)
        {
            [delKeyArray addObject:key];
        }
    }
    
    [_httpObserverDict removeObjectsForKeys:delKeyArray];
}

-(void)removeHttpObserver:(id)observer tag:(NSInteger)iRequestTag
{
    NSObject* key = [NSNumber numberWithInt:(int)iRequestTag];
    NSObject* value = [_httpObserverDict objectForKey:key];
    if (value == observer)
    {
        [_httpObserverDict removeObjectForKey:key];
    }
}

-(void)removerHttpObserverWithTag:(NSInteger)iRequestTag
{
    [_httpObserverDict removeObjectForKey:[NSNumber numberWithInt:(int)iRequestTag]];
}

#pragma mark 注销
-(void)userLogout;
{
    //退出登陆
    [PLIST setBool:YES forKey:LOGOUT_NOW];
    [PLIST setBool:NO forKey:LOGIN_SUCCESS];
    [PLIST setObject:@"" forKey:TOKENKEY];
    [PLIST setObject:@"" forKey:THEPASSWORD];
    //[PLIST setObject:@"" forKey:THEUSERNAME];
    [PLIST synchronize];
    
    //取消所有HTTP请求
    [self cancelAllRequest];
    
    //取消所有命令
    [self cleanAllCommandTask];
    
    //通知服务器注销
    [self logout:nil];
    
    //清空无用的数据
    [self cleanProxy];
}



#pragma mark - 应用进入到前后台时处理
// 程序进入后台
- (void)applicationDidEnterBackground
{
    //取消所有HTTP请求
    [self cancelAllRequest];
    
    //取消所有命令
    [self cleanAllCommandTask];
    
}

// 应用返回前台时调用
- (void)applicationWillEnterForeground
{
    
}




@end
