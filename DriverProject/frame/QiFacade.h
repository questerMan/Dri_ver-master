//
//  QiFacade.h
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QiHttpRequestQueue.h"





@protocol QiFacadeHttpRequestDelegate <NSObject>

@optional
//http 请求成功和失败数据代理
- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag;
- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag;

@end


@interface QiFacade : NSObject
{
    QiHttpRequestQueue      *_httpRequestQueue;//http请求队列
    NSInteger               _iRequestTagCount;//http请求标识， 区分不同的http请求
    
    NSMutableDictionary     *_httpObserverDict;//http请求观察者字典
    
    NSMutableArray          *_activityCommandArray;
    
    NSNotificationCenter    *_notificationCenter;//facade消息处理
}

AS_SINGLETON(QiFacade)


@property(nonatomic, assign) BOOL debugModel;//是否为调试模式 默认YES；

#pragma mark 代理



#pragma mark  通知消息相关接口
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo;
- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(NSString *)aName;


#pragma mark HTTP请求观察者相关接口
//添加HTTP请求观察者
-(void)addHttpObserver:(id)observer tag:(NSInteger)iRequestTag;
//移除HTTP请求观察者
-(void)removeHttpObserver:(id)observer;
-(void)removeHttpObserver:(id)observer tag:(NSInteger)iRequestTag;
-(void)removerHttpObserverWithTag:(NSInteger)iRequestTag;




#pragma mark 用户主动注销登录
-(void)userLogout;


#pragma mark 应用进入到前台和退到后台
// 程序进入后台
- (void)applicationDidEnterBackground;

// 应用返回前台时调用
- (void)applicationWillEnterForeground;

@end
