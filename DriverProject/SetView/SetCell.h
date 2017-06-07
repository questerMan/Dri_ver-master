//
//  SetCell.h
//  DriverProject
//
//  Created by zyx on 15/9/24.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "FETableViewCell.h"

@interface SetCell : FETableViewCell



@property (nonatomic,assign)NSInteger               modelCount;

@property(nonatomic,strong)UILabel *setlable;

@property(nonatomic,strong)UIImageView *setimage;
@property(nonatomic,assign)BOOL isIndentationWidth;

@end
