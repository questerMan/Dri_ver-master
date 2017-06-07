//
//  MessageReminderVC.h
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"
#import "AlertViewNotdataView.h"

//消息通知
@interface MessageReminderVC : BaseSetViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UITableView *MessagedetailTable;

@property(nonatomic,strong)AlertViewNotdataView *alertViewNotdataView;



@end
