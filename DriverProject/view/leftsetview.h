//
//  leftsetview.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "leftsetCell.h"

@protocol LeftRemoveViewDelegate <NSObject>
- (void)RemoveLeftView;
@end

@interface leftsetview : UIView<UITableViewDelegate,UITableViewDataSource>




@property(nonatomic,strong)UITableView *settableView;

@property(nonatomic,strong)UIButton *setButton;
@property(nonatomic,assign)NSObject<LeftRemoveViewDelegate> *m_delegate;


@property(nonatomic,strong)UIImageView *telepimage;


@end
