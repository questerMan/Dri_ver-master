//
//  OrderDetails.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-5.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetails : UIView<UITableViewDelegate,UITableViewDataSource>

//收到订单界面


@property (nonatomic,assign)NSInteger               modelCount;

@property(nonatomic,strong)UIImageView *OrderDetailsImage;

@property(nonatomic,strong)UILabel *timelable;

@property(nonatomic,strong)UILabel *startpoint;

@property(nonatomic,strong)UILabel *finishpoint;

@property(nonatomic,strong)UIImageView *startimage;

@property(nonatomic,strong)UIImageView *finishimage;


@property(nonatomic,strong)UITableView *DetailstableView;

@property(nonatomic,strong)UIButton *confirmButton;


@property(nonatomic,strong)NSDictionary *orderDic;


@end
