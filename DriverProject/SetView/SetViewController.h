//
//  SetViewController.h
//  DriverProject
//
//  Created by zyx on 15/9/24.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"

@interface SetViewController : BaseSetViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UITableView *SetTable;
@property(nonatomic,strong)NSString *titlestring;
@end
