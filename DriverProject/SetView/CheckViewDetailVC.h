//
//  CheckViewDetailVC.h
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"
//查看明细
@interface CheckViewDetailVC : BaseSetViewController<UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,strong)UILabel *detaillabel;


@property(nonatomic,strong) UITableView *detailTable;
@property(nonatomic,strong)NSString *orderID;
@end
