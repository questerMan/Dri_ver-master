//
//  ViewOrdersCell.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//


#import "ViewOrdersCell.h"



@implementation ViewOrdersCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        _isAlreadyFlag = NO;
        _isfristCell=NO;
        [self initView];
    }
    return self;
}


- (void)initView
{
    _setlable=[[UILabel alloc] initWithFrame:CGRectMake(77, 2, 250, 40)];
    _setlable.text=@"司机业绩";
    _setlable.backgroundColor=[UIColor clearColor];
    _setlable.textColor = Textblack_COLOR2;
    _setlable.font = [UIFont systemFontOfSize:15.0f];
    _setlable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_setlable];
    
    
    
    _setimage=[[UIImageView alloc]initWithFrame:CGRectMake(22, 8, 30, 30)];
    _setimage.backgroundColor=[UIColor clearColor];
    // _setimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
    [self.contentView addSubview:_setimage];
    
    //[self Celllayout];
    
    
    //    _setimage.center=CGPointMake(30, CellHeight/2);
    //    _setlable.center=CGPointMake(45+15+kMainScreenWidth*0.2, CellHeight/2);
    //
    
    
    
    //评分
    _ratingBar = [[RatingBar alloc] init];
    _ratingBar.frame = CGRectMake(60, 100, 150, 30);
    [self addSubview:_ratingBar];
    _ratingBar.showheight=20;
    _ratingBar.backgroundColor=[UIColor grayColor];
    _ratingBar.backgroundColor=[UIColor clearColor];
    _ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [_ratingBar setImageDeselected:@"ic_star_border_white_24dp.png" halfSelected:@"ic_star_half_white_24dp.png"
                      fullSelected:@"ic_star_white_24dp.png" andDelegate:self];
    [_ratingBar displayRating:2.5];
    
    
    
}
- (void)ratingChanged:(float)newRating
{
    NSLog(@"newRating=%f",newRating);
    
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _setimage.frame=CGRectMake(15,CellHeight/4, 22,22);
    _setimage.center=CGPointMake(_setimage.center.x, 22);
    
    if(_isfristCell)
    {
        _setlable.frame=CGRectMake(_setimage.right+10,5, kMainScreenWidth*0.5, CellHeight-10);
    }
    else
    {
         _setlable.frame=CGRectMake(_setimage.right+10,5, kMainScreenWidth-60, CellHeight-10);
    }
    _setlable.center=_setimage.center;
    _setlable.left=_setimage.right+10;
    _ratingBar.frame=CGRectMake(_setlable.right+3, 20,KScreenWidth-_setlable.right-20,10);
    
}



- (CGFloat)seperateLineIndentationWidth
{
    if(_isIndentationWidth)
        return 47;
    
    return 0;
}




@end