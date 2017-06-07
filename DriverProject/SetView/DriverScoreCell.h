//
//  DriverScoreCell.h
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverScoreCell : FETableViewCell
{
    
    
}

@property (nonatomic,assign)NSInteger               modelCount;
@property(nonatomic,strong)UILabel *timelable;

@property(nonatomic,strong)UILabel *startpoint;

@property(nonatomic,strong)UILabel *finishpoint;

@property(nonatomic,strong)UIImageView *startimage;

@property(nonatomic,strong)UIImageView *finishimage;


@property(nonatomic,strong)UILabel *statelable;

@property(nonatomic,strong)NSDictionary *contentDic;


@end