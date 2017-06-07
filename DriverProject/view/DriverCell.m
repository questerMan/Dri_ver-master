//
//  DriverCell.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DriverCell.h"

@implementation DriverCell


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
    _timelable=[[UILabel alloc] initWithFrame:CGRectMake(TransfomXY(18), TransfomXY(20), 200, 25)];
    _timelable.text=@"08月02日 17:52";
    _timelable.backgroundColor=[UIColor clearColor];
    _timelable.textColor = Textblack_COLOR;
    _timelable.font = [UIFont systemFontOfSize:TransfomFont(32)];
    _timelable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timelable];
    
    
    _startpoint=[[UILabel alloc] initWithFrame:CGRectMake(25, _timelable.bottom+2, 200, 20)];
    _startpoint.text=@"白云国际机场";
    _startpoint.backgroundColor=[UIColor clearColor];
    _startpoint.textColor = Textgray_COLOR;
    _startpoint.font = [UIFont systemFontOfSize:TransfomFont(28)];
    _startpoint.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_startpoint];
    
    
    _finishpoint=[[UILabel alloc] initWithFrame:CGRectMake(25, _startpoint.bottom+2, 200, 20)];
    _finishpoint.text=@"广州琶洲会展中心一号馆 ";
    _finishpoint.backgroundColor=[UIColor clearColor];
    _finishpoint.textColor = Textgray_COLOR;
    _finishpoint.font = [UIFont systemFontOfSize:TransfomFont(28)];
    _finishpoint.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_finishpoint];
    
    
    
    _startimage=[[UIImageView alloc]initWithFrame:CGRectMake(_timelable.left, _startpoint.top, 24, 24)];
    _startimage.backgroundColor=[UIColor clearColor];
    _startimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
    [self.contentView addSubview:_startimage];
    
    _finishimage=[[UIImageView alloc]initWithFrame:CGRectMake(_timelable.left, _finishpoint.top, 24, 24)];
    _finishimage.backgroundColor=[UIColor clearColor];
    _finishimage.image=[UIImage imageNamed:@"ic_pin_drop_orange_24dp.png"];
    [self.contentView addSubview:_finishimage];
    
    
    
    _iconimage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W-60, 10, 40, 40)];
    _iconimage.backgroundColor=[UIColor clearColor];
    _iconimage.image=[UIImage imageNamed:@"ic_flight_takeoff_orange_36dp.png"];
    [self.contentView addSubview:_iconimage];
    
    
    
    _statelable=[[UILabel alloc] initWithFrame:CGRectMake(_iconimage.left, _iconimage.bottom, 40, 15)];
    _statelable.text=@"进行中";
    _statelable.backgroundColor=[UIColor clearColor];
    _statelable.textColor = Assist_COLOR;
    _statelable.font = [UIFont systemFontOfSize:13];
    _statelable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_statelable];
    
    

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if([_orderdata count]>0)
    {
         _timelable.text=[_orderdata objectForKey:@"time"];
        _startpoint.text=[_orderdata objectForKey:@"origin"];
        _finishpoint.text=[_orderdata objectForKey:@"dest"];
        NSString *onair=[NSString stringWithFormat:@"%@",[_orderdata objectForKey:@"onair"]];

        
        NSString *type=[NSString stringWithFormat:@"%@",[_orderdata objectForKey:@"type"]];

        //type  1即使单  2预约用车  3 预约接机  4预约送机
        if([type isEqualToString:@"1"])
        {
           
            if([onair isEqualToString:@"0"])  //false
            {
                _statelable.text=@"";
                _iconimage.image=[UIImage imageNamed:@"ic_directions_car_darkgray_24dp.png"];
                
            }else
            {
                _statelable.text=@"进行中";
                _iconimage.image=[UIImage imageNamed:@"ic_directions_car_yellow_24dp.png"];
            }
            
            
        }
        if([type isEqualToString:@"2"])
        {
            if([onair isEqualToString:@"0"])  //false
            {
                _statelable.text=@"";
                _iconimage.image=[UIImage imageNamed:@"ic_time_car_lightgray_48dp.png"];
                
            }else
            {
                _statelable.text=@"进行中";
                _iconimage.image=[UIImage imageNamed:@"ic_time_car_yellow_48dp.png"];
            }
        }
        if([type isEqualToString:@"4"])
        {
            if([onair isEqualToString:@"0"])  //false
            {
                _statelable.text=@"";
                _iconimage.image=[UIImage imageNamed:@"ic_flight_takeoff_darkgray.png"];
                
            }else
            {
                _statelable.text=@"进行中";
                _iconimage.image=[UIImage imageNamed:@"ic_flight_takeoff_yellow.png"];
            }
        }
        if([type isEqualToString:@"3"])
        {
            if([onair isEqualToString:@"0"])  //false
            {
                _statelable.text=@"";
                _iconimage.image=[UIImage imageNamed:@"ic_flight_land_darkgray.png"];
                
            }else
            {
                _statelable.text=@"进行中";
                _iconimage.image=[UIImage imageNamed:@"ic_flight_land_yellow.png"];
            }
        }

    }
    _iconimage.hidden=NO;
    [_timelable sizeToFit];
    _timelable.origin=CGPointMake(TransfomXY(30), TransfomXY(20));
    [_startpoint sizeToFit];
    _startpoint.origin=CGPointMake(16+_timelable.left, _timelable.bottom+TransfomXY(15));
    [_finishpoint sizeToFit];
    _finishpoint.origin=CGPointMake(16+_timelable.left, _startpoint.bottom+TransfomXY(20));
    _finishpoint.bottom=88-10;
    _startimage.frame=CGRectMake(_timelable.left, _startpoint.top, 15, 15);
    _finishimage.frame=CGRectMake(_timelable.left, _finishpoint.top, 15, 15);
    NSString *unpaid=[[_orderdata objectForKey:@"unpaid"] stringValue];
    if([_statelable.text length]>1)
    {
        _iconimage.size=CGSizeMake(TransfomXY(64), TransfomXY(64));
        _iconimage.right=self.width-TransfomXY(54);
        _iconimage.top=TransfomXY(50);

        [_statelable sizeToFit];
        _statelable.center=_iconimage.center;
        _statelable.top=_startimage.bottom+TransfomXY(10);
        _statelable.hidden=NO;

    }
    else
    {
        _iconimage.size=CGSizeMake(TransfomXY(64), TransfomXY(64));
        _iconimage.right=self.width-TransfomXY(54);
        //_iconimage.top=TransfomXY(31);
        _iconimage.center=CGPointMake(_iconimage.center.x, self.height/2);
        _statelable.hidden=YES;
    }
    if([unpaid isEqualToString:@"1"])
    {
        _iconimage.size=CGSizeMake(TransfomXY(64), TransfomXY(64));
        _iconimage.right=self.width-TransfomXY(54);
        _iconimage.top=TransfomXY(50);
        _iconimage.hidden=YES;
        _statelable.text=@"待付款";
        
        _statelable.textColor =Assist_COLOR;
        [_statelable sizeToFit];
        _statelable.center=_iconimage.center;
        _statelable.left=_iconimage.left;
        _statelable.hidden=NO;

    }
}







@end
