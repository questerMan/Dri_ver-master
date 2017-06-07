//
//  ViewOrdersCell.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RatingBar.h"
#import <UIKit/UIKit.h>



#define CellHeight   44


@interface ViewOrdersCell : FETableViewCell



@property (nonatomic,assign)NSInteger               modelCount;

@property(nonatomic,strong)UILabel *setlable;

@property(nonatomic,strong)UIImageView *setimage;

@property(nonatomic,strong)RatingBar *ratingBar;

@property(nonatomic,assign)BOOL isIndentationWidth;

@property(nonatomic,assign)BOOL isfristCell;

@end
