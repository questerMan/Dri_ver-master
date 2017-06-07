//
//  MReminderCell.h
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETableViewCell.h"
@interface MReminderCell : FETableViewCell





@property(nonatomic,strong)UILabel *titleTextlable;

@property(nonatomic,strong)UILabel *timeTextlable;


@property(nonatomic,strong)UILabel *contentTextlable;


+ (CGSize)heightFosizeForString:(NSString *)value fontSize:(UIFont *)Font andWidth:(float)width;

+ (CGFloat)heightFromCell:(NSString *)value;
@end
