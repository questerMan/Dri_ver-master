//
//  DriverScoreVC.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"
#import "AlertViewNotdataView.h"


@interface DriverScoreVC : BaseSetViewController<UITableViewDelegate,UITableViewDataSource>
//司机业绩
@property(nonatomic,strong)UIView *ScoreView;

@property(nonatomic,strong)UIButton *ScoreButton1;

@property(nonatomic,strong)UIButton *ScoreButton2;

@property(nonatomic,strong)UIButton *ScoreButton3;

@property(nonatomic,strong)AlertViewNotdataView *alertViewNotdataView;

@property(nonatomic,strong)UILabel *lable01;
@property(nonatomic,strong)UILabel *lable02;
@property(nonatomic,strong)UILabel *lable03;
@property(nonatomic,strong)UILabel *lable04;

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong) UITableView *driverTable;


@end
