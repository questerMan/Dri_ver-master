//
//  QiFacade+putmodel.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"
@interface QiFacade (putmodel)


-(NSInteger)putTest;

#pragma mark 出勤
-(NSInteger)putDriverAttendance;

#pragma mark 签退
-(NSInteger)putDriverSignoutState:(NSString *)state reasonFor:(NSString *)reason;

/*
#pragma mark 司机前往接客
-(NSInteger)putDriverPickUp:(NSString *)OrderID;


#pragma mark 司机前往接客点
-(NSInteger)putDriverPickUpPoint:(NSString *)OrderID;

#pragma mark  乘客上车
-(NSInteger)putDriverOnthetrain:(NSString *)OrderID;

#pragma mark  乘客下车
-(NSInteger)putDriverdownthetrain:(NSString *)OrderID;

#pragma mark  现金支付
-(NSInteger)putDriverCashpayment:(NSString *)OrderID;
*/

//#pragma mark 司机应单
//-(NSInteger)putreplyOrder:(NSString *)OrderID;
#pragma mark 司机应单
-(NSInteger)putreplyOrder:(NSString *)OrderID lon:(NSString *)lon lat:(NSString *)lat;

#pragma mark 司机代付
-(NSInteger)putrpaidOrder:(NSString *)OrderID;
#pragma mark 出发
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon  distance:(NSString *)dis;
#pragma mark 上车&&途中&&到达
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon;

#pragma mark 行驶中
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon  segment:(NSString *)segment distance:(NSString *)dis;

#pragma mark 下车
-(NSInteger)putDriverOrderState:(NSString *)OrderID pointlat:(NSString *)lat pointlon:(NSString *)lon distance:(NSString *)dis  ext:(NSString *)ext;


#pragma mark 司机代付
-(NSInteger)putrDriverPaid:(NSString *)OrderID;
@end
