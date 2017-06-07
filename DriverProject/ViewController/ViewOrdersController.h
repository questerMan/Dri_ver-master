//
//  ViewOrdersController.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
//查看订单

@interface ViewOrdersController : BaseViewController<UITableViewDelegate,UITableViewDataSource>


//导航栏
@property(nonatomic,strong)UIView *NavigationBackView;

@property(nonatomic,strong)UIButton *BackButton2;
@property(nonatomic,strong)UIButton *BackButton;
@property(nonatomic,strong)UILabel *ViewOrdersLable;
@property(nonatomic,strong)UILabel *ViewDetailedLable;
@property(nonatomic,strong)UIButton *ViewDetailed;


//概述

@property(nonatomic,strong)UILabel *SummaryLable01;
@property(nonatomic,strong)UILabel *SummaryLable02;
@property(nonatomic,strong)UILabel *SummaryLable03;
@property(nonatomic,strong)UILabel *SummaryLable04;

//详情
@property(nonatomic,strong)UITableView *DetailsTableView;


@property(nonatomic,strong)NSString *orderID;

@property(nonatomic,strong)UIView *line;



@end
