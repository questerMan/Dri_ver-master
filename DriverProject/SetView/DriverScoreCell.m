//
//  DriverScoreCell.m
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DriverScoreCell.h"

@implementation DriverScoreCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        _isAlreadyFlag = NO;
        _modelCount = 0;
        [self initView];
    }
    return self;
}



- (void)initView
{
    _timelable=[[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200, 25)];
    _timelable.text=@"08月02日 17:52";
    _timelable.backgroundColor=[UIColor clearColor];
    _timelable.textColor = Textblack_COLOR;
    _timelable.font = [UIFont systemFontOfSize:TransfomFont(32)];
    _timelable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timelable];
    
    
    _startpoint=[[UILabel alloc] initWithFrame:CGRectMake(25, _timelable.bottom+5, 200, 20)];
    _startpoint.text=@"白云国际机场";
    _startpoint.backgroundColor=[UIColor clearColor];
    _startpoint.textColor = Textgray_COLOR;
    _startpoint.font = [UIFont systemFontOfSize:TransfomFont(28)];
    _startpoint.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_startpoint];
    
    
    _finishpoint=[[UILabel alloc] initWithFrame:CGRectMake(25, _startpoint.bottom+3, 200, 20)];
    _finishpoint.text=@"广州琶洲会展中心一号馆 ";
    _finishpoint.backgroundColor=[UIColor clearColor];
    _finishpoint.textColor = Textgray_COLOR;
    _finishpoint.font = [UIFont systemFontOfSize:TransfomFont(28)];
    _finishpoint.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_finishpoint];
    
    _startimage=[[UIImageView alloc]initWithFrame:CGRectMake(_timelable.left, _startpoint.top, 18, 18)];
    _startimage.backgroundColor=[UIColor clearColor];
    _startimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
    [self.contentView addSubview:_startimage];
    
    _finishimage=[[UIImageView alloc]initWithFrame:CGRectMake(_timelable.left, _finishpoint.top, 18, 18)];
    _finishimage.backgroundColor=[UIColor clearColor];
    _finishimage.image=[UIImage imageNamed:@"ic_pin_drop_orange_24dp.png"];
    [self.contentView addSubview:_finishimage];
    

    
    _statelable=[[UILabel alloc] initWithFrame:CGRectMake(180, 5, 40, 15)];
    _statelable.text=@"¥55";
    _statelable.backgroundColor=[UIColor clearColor];
    _statelable.textColor =Main_COLOR;
    _statelable.font = [UIFont systemFontOfSize:FONT_SIZE_BIG_2];
    _statelable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_statelable];
    
    
    
}
-(void)setContentDic:(NSDictionary *)contentDic
{

    _contentDic=contentDic;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if([_contentDic count]>0)
    {
        _timelable.text=[_contentDic objectForKey:@"time"];
        _startpoint.text=[_contentDic objectForKey:@"origin"];
        _finishpoint.text=[_contentDic objectForKey:@"dest"];
        //_statelable.text=[NSString stringWithFormat:@"¥%@",[_contentDic objectForKey:@"fee"]];
        NSString *string=[NSString stringWithFormat:@"¥ %@",[_contentDic objectForKey:@"fee"]];
        [self changeString:string changeLable:_statelable];
    }
    
    
    _statelable.frame=CGRectMake(200, 4, 40, 15);
    [_statelable sizeToFit];
    _statelable.center=self.contentView.center;
    _statelable.left=self.contentView.width-15-_statelable.width;
    
  
    
    [_timelable sizeToFit];
    _timelable.origin=CGPointMake(TransfomXY(30), TransfomXY(20));
    [_startpoint sizeToFit];
    _startpoint.origin=CGPointMake(16+_timelable.left, _timelable.bottom+TransfomXY(15));
    [_finishpoint sizeToFit];
    _finishpoint.origin=CGPointMake(16+_timelable.left, _startpoint.bottom+TransfomXY(20));
    _finishpoint.bottom=88-10;
    _startimage.frame=CGRectMake(_timelable.left, _startpoint.top, 15, 15);
    _finishimage.frame=CGRectMake(_timelable.left, _finishpoint.top, 15, 15);
    
    CGFloat maxwidth =_statelable.left-_startpoint.left-5;
    if(_startpoint.width>maxwidth)
    {
        _startpoint.size=CGSizeMake(maxwidth, _startpoint.height);
    }
    if(_finishpoint.width>maxwidth)
    {
        _finishpoint.size=CGSizeMake(maxwidth, _finishpoint.height);
    }
    
    
}

#pragma mark  改变第一个字符串

-(NSRange)getRangeWithStr:(NSString *)_str searchStr:(NSString *)_searchStr
{
    return [_str rangeOfString:_searchStr];
}


-(void)changeString:(NSString *)LastString changeLable:(UILabel *)Lable
{
    NSRange range01=[self getRangeWithStr:LastString searchStr:@"¥"];
    if(range01.location!=NSNotFound)
    {

        NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",LastString]];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:TransfomFont(28)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(0, 1)];
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:TransfomFont(18)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(2, 1)];

        [dateString addAttributes:@{
                                    NSFontAttributeName: [UIFont systemFontOfSize:TransfomFont(40)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(2, [LastString length]-2)];
        
        Lable.attributedText = dateString;
    }
}

@end

