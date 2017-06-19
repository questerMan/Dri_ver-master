//
//  QiFacade+http.h
//  77net
//  HTTP请求基本接口
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "QiFacade.h"
#import "QiHttpRequestQueue.h"
#import "ToolObject.h"
@interface QiFacade (http)

#pragma mark - 基本功能接口
/**
 *  默认method:GET
 *
 *  @param strUrl   请求服务器地址
 *  @param paraDict 参数
 *  @param userInfo nil
 *
 *  @return nil
 */
-(QiHttpRequest*)httpRequest:(NSString*)strUrl
                    paraDict:(NSDictionary*)paraDict
                    userInfo:(NSDictionary*)userInfo;

/**
 *  HTTP POST 请求
 *
 *  @param strUrl 请求服务器地址
 *  @param paraDict 参数
 *  @param userInfo
 *
 *  @return
 */
-(QiHttpRequest*)httpRequestPost:(NSString*)strUrl
                        paraDict:(NSDictionary*)paraDict
                        userInfo:(NSDictionary*)userInfo;

/**
 *  默认method:GET
 *
 *  @param strUrl   请求服务器地址
 *  @param paraArray 参数
 *  @param userInfo nil
 *
 *  @return nil
 */
-(QiHttpRequest*)httpRequestGet:(NSString*)strUrl
                       paraDict:(NSArray*)paraArray
                       userInfo:(NSDictionary*)userInfo;


/**
 *  HTTP Put 请求
 *
 *  @param strUrl 请求服务器地址
 *  @param paraArray 参数
 *  @param userInfo
 *
 *  @return
 */
-(QiHttpRequest*)httpRequestPut:(NSString*)strUrl
                       paraArray:(NSArray*)paraArray
                       userInfo:(NSDictionary*)userInfo;



/**
 *  HTTP Put 请求
 *
 *  @param strUrl 请求服务器地址
 *  @param paraDict 参数
 *  @param userInfo
 *
 *  @return
 */
-(QiHttpRequest*)httpRequestPut:(NSString*)strUrl
                        paraDict:(NSDictionary*)paraDict
                        userInfo:(NSDictionary*)userInfo;

/**
 *  HTTP Delete 请求
 *
 *  @param strUrl 请求服务器地址
 *  @param paraDict 参数
 *  @param userInfo
 *
 *  @return
 */
-(QiHttpRequest*)httpRequestDelete:(NSString*)strUrl
                       paraDict:(NSDictionary*)paraDict
                       userInfo:(NSDictionary*)userInfo;


/**
 *  通过请求标识取消http请求
 *
 *  @param iRequestTag 请求tag
 */
-(void)cancelHttpRequestWithTag:(NSInteger)iRequestTag;

/**
 *  //取消此观察者下所有http请求
 *
 *  @param observer 观察者
 */
-(void)cancelHttpRequestWithObserver:(NSObject*)observer;

/**
 *  //取消所有请求
 */
-(void)cancelAllRequest;

/**
 *  //判断请求是否成功
 *
 *  @param response 请求成功返回的数据
 *
 *  @return
 */
-(BOOL)requestSuccess:(NSDictionary*)response;

/**
 *  解析服务器返回的数据， 获取D数据区数据
 *
 *  @param data   服务器返回的json对象
 *  @param strKey 协议KEY
 *
 *  @return 接口返回的内容
 */
-(id)parseServerData:(id)data key:(NSString*)strKey;

/**
 *  //请求失败处理
 *
 *  @param response 请求失败返回的数据
 *  @param request  http请求对象
 */
-(void)dealRequestFail:(id)response request:(QiHttpRequest*)request;

/**
 *  //调用观察者处理请求结果
 *
 *  @param response    请求失败返回的数据
 *  @param iRequestTag 请求tag
 *  @param bSuccess    请求是否成功
 */
-(void)callHttpObserver:(NSDictionary*)response
                    tag:(NSInteger)iRequestTag
                success:(BOOL)bSuccess;

/**
 *  //添加设备自身参数及加密数据签名
 *
 *  @param httpDic   需添加参数的字典
 */
-(NSDictionary *)convertTokenFromDic:(NSDictionary *)httpDic;

@end
