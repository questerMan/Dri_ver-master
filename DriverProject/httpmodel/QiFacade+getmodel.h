//
//  QiFacade+getmodel.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"


@interface QiFacade (getmodel)

-(NSInteger)getTest;


#pragma mark 获取司机业绩
-(NSInteger)getDriverAccount;

#pragma mark 获取司机资料    // status 1 登录 2 出车 3服务 4 签退 5 退出
-(NSInteger)getDriverInfo;


#pragma mark 获取司机待订单列表
-(NSInteger)getDriverOrderListPage:(NSString *)Page perPage:(NSString *)per_page;


#pragma mark 获取司机订单详情
-(NSInteger)getDriverOrderDetailsID:(NSString *)OrderId;

#pragma mark 获取司机订单费用明细
-(NSInteger)getOrderCostDetailsID:(NSString *)OrderId;



#pragma mark 获取司机业绩月订单
-(NSInteger)getDriverAccountMonth:(NSString *)Month withpage:(NSString *)page;

#pragma mark  获取城市列表
-(NSInteger)getCitysLIst;

@end
