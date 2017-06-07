//
//  MReminderCell.m
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MReminderCell.h"

#define LEFT_LABLE 15
#define TOP_LABLE 10



@implementation MReminderCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self initView];
    }
    return self;
}

-(void)initView
{
    _titleTextlable = ({
        UILabel * aLal = [[UILabel alloc] init];
        aLal.font = [UIFont systemFontOfSize:FONT_SIZE_MID_1];
        aLal.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        aLal.textAlignment = NSTextAlignmentCenter;
        aLal.numberOfLines=1;
        aLal.font=[UIFont systemFontOfSize:14];
        aLal.textColor = Textblack_COLOR ;
        aLal.backgroundColor = [UIColor clearColor];
        aLal;
    });
    _timeTextlable = ({
        UILabel * aLal = [[UILabel alloc] init];
        aLal.font = [UIFont systemFontOfSize:FONT_SIZE_MID_1];
        aLal.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        aLal.textAlignment = NSTextAlignmentCenter;
        aLal.numberOfLines=1;
         aLal.font=[UIFont systemFontOfSize:14];
        aLal.textColor = Textblack_COLOR ;
        aLal.backgroundColor = [UIColor clearColor];
        aLal;
    });
    
    _contentTextlable= ({
        UILabel * aLal = [[UILabel alloc] init];
        aLal.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL_1];
        aLal.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        aLal.textAlignment = NSTextAlignmentLeft;
        aLal.numberOfLines=0;
         aLal.font=[UIFont systemFontOfSize:14];
        aLal.textColor = Textgray_COLOR ;
        aLal.backgroundColor = [UIColor clearColor];
        aLal;
    });
    [self.contentView addSubview:_titleTextlable];
    [self.contentView addSubview:_timeTextlable];
    [self.contentView addSubview:_contentTextlable];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleTextlable sizeToFit];
    _titleTextlable.left=LEFT_LABLE;
    _titleTextlable.top=TOP_LABLE;
    
    [_timeTextlable sizeToFit];
    _timeTextlable.left=self.width-_timeTextlable.width-LEFT_LABLE;
    _timeTextlable.top=TOP_LABLE;
    
    _contentTextlable.left=LEFT_LABLE;
    _contentTextlable.top=_titleTextlable.bottom+TOP_LABLE;
    _contentTextlable.width=self.width-2*LEFT_LABLE;
    CGSize size=[MReminderCell heightFosizeForString:_contentTextlable.text fontSize:_contentTextlable.font andWidth:(self.width-2*LEFT_LABLE)];
    _contentTextlable.height=size.height;
    
}


+ (CGSize)heightFosizeForString:(NSString *)value fontSize:(UIFont *)Font andWidth:(float)width
{
    CGSize sizeToFit=(CGSize){0,0};
    NSString *string=value;
    if([value length]>0){
        if(IOS7_OR_LATER)
        {
            
            sizeToFit=[string boundingRectWithSize:
                       CGSizeMake(width, 1000)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font,NSFontAttributeName, nil] context:nil].size;
            
            
        }
        else
        {
            sizeToFit=[string sizeWithFont:Font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
    }
    else
    {
        return sizeToFit;
    }
    
    return sizeToFit;
    
}

+(CGFloat)heightFromCell:(NSString *)value
{
    CGFloat height=0;

    height=3*TOP_LABLE+[MReminderCell heightFosizeForString:value fontSize:[UIFont systemFontOfSize:FONT_SIZE_SMALL_1] andWidth:(SCREEN_WIDTH-2*LEFT_LABLE)].height;
    return height;
}




@end
