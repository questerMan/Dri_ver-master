//
//  DetailsVCCell.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-10-12.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DetailsVCCell.h"

@implementation DetailsVCCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        _isAlreadyFlag = NO;
        self.lineView.backgroundColor=Dividingline_COLOR;
        [self initView];
    }
    return self;
}


- (void)initView
{
    
    _setimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, TransfomXY(21), 24, 24)];
    _setimage.backgroundColor=[UIColor clearColor];
    _setimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
    [self.contentView addSubview:_setimage];
    
    _setlable=[[UILabel alloc] initWithFrame:CGRectMake(TransfomXY(17)+25+TransfomXY(12), TransfomXY(21), 250, 40)];
    _setlable.text=@"";
    _setlable.backgroundColor=[UIColor clearColor];
    _setlable.textColor = Textblack_COLOR2;
    _setlable.font = [UIFont systemFontOfSize:15.0f];
    _setlable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_setlable];
    

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _setimage.size=CGSizeMake(24, 24);
    _setimage.center=CGPointMake(22, 22);
    _setimage.left=15;
    
    [_setlable sizeToFit];
    _setlable.center=CGPointMake(22, 22);
    _setlable.left=_setimage.right+10;
    
    
}

- (CGFloat)seperateLineIndentationWidth
{
    if(_isIndentationWidth)
        return 49;
    
    return 0;
}




@end
