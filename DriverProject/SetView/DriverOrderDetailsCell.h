//
//  DriverOrderDetailsCell.h
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//查看明细  cell
@interface DriverOrderDetailsCell : FETableViewCell



@property(nonatomic,strong)UILabel *titleTextlable;

@property(nonatomic,strong)UILabel *contentTextlable;

@property(nonatomic,strong)NSString *titleText;
@property(nonatomic,strong)NSString *contentText;


@property(nonatomic,assign)BOOL isIndentationWidth;


@end
