//
//  DetailsVCCell.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-10-12.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "FETableViewCell.h"

@interface DetailsVCCell : FETableViewCell
@property (nonatomic,assign)NSInteger               modelCount;

@property(nonatomic,strong)UILabel *setlable;

@property(nonatomic,strong)UIImageView *setimage;

@property(nonatomic,assign)BOOL isIndentationWidth;


@end