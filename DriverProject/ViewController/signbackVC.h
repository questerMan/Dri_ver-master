//
//  signbackVC.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-10-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CCBBaseViewController.h"

@interface signbackVC : CCBBaseViewController<UITableViewDataSource,UITableViewDelegate>


//@property(nonatomic,strong)NSString *orderID;

@property(nonatomic,strong)UILabel *Timelable;


@property(nonatomic,strong)UILabel *Distancelable;


@property(nonatomic,strong)UIButton *BackButton;
@property(nonatomic,strong)UIImageView *BackButtonimage;

@property(nonatomic,strong)UIButton *signoutButton;

@property(nonatomic,strong)UITableView *DetailsTableView;


@property(assign)OrdersStates driverstates;


@end
