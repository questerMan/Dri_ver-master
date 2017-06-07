//
//  DetailsViewController.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//


@class DetailsViewController;
@protocol DetailsViewControllerDelegate <NSObject>
@optional
- (void)refreshMainView:(BOOL)isRefrsh;
@end


#import "BaseViewController.h"
//接单时的订单详情视图
@interface DetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)UILabel *Timelable;

@property(nonatomic,strong)UIImageView *BackButtonimage;
@property(nonatomic,strong)UILabel *Distancelable;


@property(nonatomic,strong)UIButton *BackButton;


@property(nonatomic,strong)UIButton *ConfirmButton;

@property(nonatomic,strong)UITableView *DetailsTableView;



@property(assign)OrdersStates driverstates;

@property (nonatomic, weak)     id<DetailsViewControllerDelegate> delegate;

-(void)requestData;

@end
