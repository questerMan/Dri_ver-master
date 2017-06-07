//
//  ViewController.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

//测试＋＋＋＋＋＋＋＋

#import "ViewOrdersController.h"

//测试＋＋＋＋＋＋＋＋





#import <UIKit/UIKit.h>

#import "RatingBar.h"
#import "leftsetview.h"
#import "DriverunView.h"
#import "OrderDetails.h"


#import "BaseViewController.h"
#import "AppDelegate.h"
#import "DetailsViewController.h"
//#import "CCBBaseViewController.h"


@interface ViewController : BaseViewController<QiFacadeHttpRequestDelegate,UITableViewDataSource,UITableViewDelegate,RatingBarDelegate>



@property(nonatomic,strong) UILabel *drivername;
@property(nonatomic,strong) UILabel *driverinformation;

@property(nonatomic,strong) UITableView *driverTable;
@property(nonatomic,strong) RatingBar *ratingBar;

@property(nonatomic,strong) leftsetview *mysetView;

@property(nonatomic,strong) UIButton *setButton;

//@property(nonatomic,strong) DriverunView *DriverunButton;
@property(nonatomic,strong) UIButton *DriverunButton;

@property(nonatomic,strong) OrderDetails *MyOrderDetailView;

//- (IBAction)setBtnClicked:(UIButton *)sender;



@property(strong)UISwipeGestureRecognizer *rightSwipGestureRecognizer;
@property(strong)UISwipeGestureRecognizer *leftSwipGestureRecognizer;

@end

