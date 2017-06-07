//
//  OrderDetails.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-5.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "OrderDetails.h"
#import "leftsetCell.h"


#define  LEFT_SPACING   40
#define  RINGT_SPACING   40
#define  TOP_SPACING   5

@implementation OrderDetails


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:0.5];
        [self setUI];
        
        
    }
    return self;
}


-(void)setUI
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self addSubview:backView];

    
    _OrderDetailsImage=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 25, 25)];
    _OrderDetailsImage.backgroundColor=[UIColor clearColor];
    _OrderDetailsImage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
    _OrderDetailsImage.left=self.width/2-75;
    [backView addSubview:_OrderDetailsImage];
    
    
   _timelable=[[UILabel alloc] initWithFrame:CGRectMake(55, 5, 250, 40)];
    //_timelable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    _timelable.left=_OrderDetailsImage.right+5;
    _timelable.text=@"明天 17:52";
    _timelable.backgroundColor=[UIColor clearColor];
    _timelable.textColor = Assist_COLOR;
    _timelable.font = [UIFont systemFontOfSize:16.0f];
    _timelable.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_timelable];
    
    UIView *backViewg=[[UIView alloc] initWithFrame:CGRectMake(0, _timelable.bottom, self.width, 15)];
    backViewg.backgroundColor=TextwhiteDisable_COLOR;
    [backView addSubview:backViewg];
    
    
    _DetailstableView = [[UITableView alloc] initWithFrame:FRAME(0, _timelable.bottom+15,self.width,backView.height-_timelable.height-59-3*TOP_SPACING) style:UITableViewStylePlain];
    _DetailstableView.delegate = self;
    _DetailstableView.dataSource = self;
     _DetailstableView.backgroundColor=TextwhiteDisable_COLOR;
    _DetailstableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backView addSubview:_DetailstableView];//原
    _DetailstableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    
    _confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(10, _DetailstableView.bottom+TOP_SPACING, backView.width-20, 44.0f)];
    _confirmButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_confirmButton setTitle:@"应单" forState:UIControlStateNormal];
    [backView addSubview:_confirmButton];
    UIImage *loginBg=[UIImage imageNamed:@"button_ok_yellow.png"];
    loginBg=[loginBg stretchableImageWithLeftCapWidth:(loginBg.size.width*0.5f) topCapHeight:(loginBg.size.height*0.5f)];
    [_confirmButton setBackgroundImage:loginBg forState:UIControlStateNormal];
}
-(void)setOrderDic:(NSDictionary *)orderDic
{
    NSString *action=[orderDic objectForKey:@"action"];
    if([action isEqualToString:@"order_accept"])
    {
        [_confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
    }else {
        [_confirmButton setTitle:@"应单" forState:UIControlStateNormal];
    }
    _orderDic=[[NSDictionary alloc] initWithDictionary:orderDic];
    _timelable.text=[_orderDic objectForKey:@"pre_time"];
    if(!([_timelable.text length]>0))_timelable.text=@"即时单";
    [_timelable sizeToFit];
    _timelable.left  = (self.width - _timelable.width)/2;

    
    
     NSString *type=[NSString stringWithFormat:@"%@",[_orderDic objectForKey:@"order_type"]];
   //type  1即使单  2预约用车  3 预约接机  4预约送机
    if([type isEqualToString:@"1"])
    {

        _OrderDetailsImage.image=[UIImage imageNamed:@"ic_directions_car_yellow_24dp.png"];

    }
    if([type isEqualToString:@"2"])
    {

        _OrderDetailsImage.image=[UIImage imageNamed:@"ic_time_car_yellow_48dp.png"];
        
    }
    if([type isEqualToString:@"3"])
    {

        _OrderDetailsImage.image=[UIImage imageNamed:@"ic_flight_takeoff_yellow.png"];
        
    }
    if([type isEqualToString:@"4"])
    {

        _OrderDetailsImage.image=[UIImage imageNamed:@"ic_flight_land_yellow.png"];
        
    }
    
    _OrderDetailsImage.right = _timelable.left;
    _timelable.center = CGPointMake(_timelable.center.x, _OrderDetailsImage.center.y+2);
    
    
    [_DetailstableView reloadData];

}


#pragma ++++++tableView+++++++

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=2;
    NSString *type=[NSString stringWithFormat:@"%@",[_orderDic objectForKey:@"order_type"]];;
    if([type isEqualToString:@"3"])
    {
        intergerNum=3;
    }
    
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"OrderSetCell";
    leftsetCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[leftsetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.showSeperateLine=YES;
    sectionCell.showTopSeperateLine=NO;
    sectionCell.isIndentationWidth=YES;
    NSInteger Row=(NSInteger)indexPath.row;
    switch (Row) {
        case 0:
            sectionCell.showTopSeperateLine=YES;
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
            //sectionCell.setlable.text=@"琶洲一号";
           sectionCell.setlable.text=[_orderDic objectForKey:@"origin"];
            break;
            
        case 1:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_pin_drop_orange_24dp.png"];
            //sectionCell.setlable.text=@"广州南站";
            sectionCell.setlable.text=[_orderDic objectForKey:@"destination"];
            
            break;
        }
        case 2:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_flight_darkgray_24dp.png"];
            NSString *flightS =@"";

            NSString *type=[NSString stringWithFormat:@"%@",[_orderDic objectForKey:@"order_type"]];
            if([type isEqualToString:@"3"])
            {
                flightS = [NSString stringWithFormat:@"接机(%@，航班号：%@)",[_orderDic objectForKey:@"flight_date"],[_orderDic objectForKey:@"flight_no"]];
            }
            if([type isEqualToString:@"4"])
            {
                flightS = @"送机";
            }
            sectionCell.setlable.text = flightS;
            
            break;
        }
            
        default:
            break;
    }
    //最后一行不缩进
    NSString *type=[NSString stringWithFormat:@"%@",[_orderDic objectForKey:@"order_type"]];
    if([type isEqualToString:@"3"])
    {
        if(indexPath.row==0)
        {
            sectionCell.isIndentationWidth=NO;
        }
    }else
    {
        if(indexPath.row==1)
        {
            sectionCell.isIndentationWidth=NO;
        }
    
    }
    
    
    return sectionCell;

    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
