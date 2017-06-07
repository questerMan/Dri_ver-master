//
//  DriverOrderDetailsCell.m
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DriverOrderDetailsCell.h"

@implementation DriverOrderDetailsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        _isAlreadyFlag = NO;
        [self initView];
    }
    return self;
}

-(void)initView
{
    
    _titleTextlable = ({
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectZero];
        lable.font = [UIFont systemFontOfSize:15];
        lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor = Textblack_COLOR;
        lable.backgroundColor=[UIColor clearColor];
        lable;
    });
    

    [self.contentView addSubview:_titleTextlable];

    _contentTextlable = ({
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectZero];
        lable.font = [UIFont systemFontOfSize:15];
        lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor = Textblack_COLOR;
        lable.backgroundColor=[UIColor clearColor];
        lable;
    });

    [self.contentView addSubview:_contentTextlable];
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentTextlable.text=_contentText;
    _titleTextlable.text=_titleText;
    [_titleTextlable sizeToFit];
    [_contentTextlable sizeToFit];
    
    
   _titleTextlable.center=self.contentView.center;
    _titleTextlable.left=15;
    

     _contentTextlable.center=self.contentView.center;
    _contentTextlable.left=self.width-15-_contentTextlable.width;
    
}

- (CGFloat)seperateLineIndentationWidth
{
    if(_isIndentationWidth)
        return 15;
    
    return 0;
}




@end
