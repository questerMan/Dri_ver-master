//
//  leftsetview.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//
#import "DriverScoreVC.h"
#import "leftsetview.h"
#import "AppDelegate.h"
#import "MessageReminderVC.h"
#import "TourismVC.h"
#import "SetViewController.h"




@implementation leftsetview

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self setUI];
        
        
    }
    return self;
}

-(void)setUI
{
    _settableView = [[UITableView alloc] initWithFrame:FRAME(0, 100,self.frame.size.width, 264) style:UITableViewStylePlain];
    _settableView.delegate = self;
    _settableView.dataSource = self;
    _settableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_settableView];//原
    _settableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    UIImageView *setTitleImgae=[[UIImageView alloc]init];
    setTitleImgae.image=[UIImage imageNamed:@"ic_settitleImage.png"];
    setTitleImgae.size=CGSizeMake(113, 31);
    setTitleImgae.center=CGPointMake(self.width/2, 50);
    [self addSubview:setTitleImgae];
    
    
}

-(void)telephone:(NSString *)phoneNum
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
  
}


#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=6;
    
    
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"SetCell";
    leftsetCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[leftsetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.showTopSeperateLine=NO;
     sectionCell.setlable.textColor = Textblack_COLOR2;
    NSLog(@"===%ld",(long)indexPath.row);
    NSInteger Row=(NSInteger)indexPath.row;
    switch (Row) {
        case 0:
        {
            sectionCell.showTopSeperateLine=YES;
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_directions_car_lightgray_24dp.png"];
            sectionCell.setlable.text=@"司机业绩";
            break;
        }
        case 1:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_notifications_lightgray_24dp.png"];
            sectionCell.setlable.text=@"消息通知";
            break;
        case 2:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_whatshot_lightgray_24dp.png"];
            sectionCell.setlable.text=@"出行热点";
            break;
        case 3:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_explore_lightgray_24dp.png"];
            sectionCell.setlable.text=@"司机指南";
            break;
        case 4:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_settings_lightgray_24dp.png"];
            sectionCell.setlable.text=@"设置";
            break;
        case 5:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_call_green_24dp.png"];
            sectionCell.setlable.text=@"服务总台热线";
            sectionCell.setlable.textColor =Main_COLOR;
            break;
            
        default:
            break;
    }
    
    
    
    
    return sectionCell;
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row!=5)
    {
        if (_m_delegate != nil && [_m_delegate respondsToSelector:@selector(RemoveLeftView)]) {
            [_m_delegate RemoveLeftView];
        }
    }
    if(indexPath.row==0)
    {
    
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        DriverScoreVC  *driverScoreVC=[[DriverScoreVC alloc] init];
        [delegate.mainViewNav pushViewController:driverScoreVC animated:YES];
    
    }
    if(indexPath.row==1)
    {
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        MessageReminderVC  *messageReminderVC=[[MessageReminderVC alloc] init];
        [delegate.mainViewNav pushViewController:messageReminderVC animated:YES];
        
    }
    
    if(indexPath.row==2)
    {
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        TourismVC  *tourismVC=[[TourismVC alloc] init];
        tourismVC.titlelable=@"出行热点";
        tourismVC.urlString=@"www.gaclixin.com/help/madian.html";
        [delegate.mainViewNav pushViewController:tourismVC animated:YES];
        
    }
    if(indexPath.row==3)
    {
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        TourismVC  *tourismVC=[[TourismVC alloc] init];
        tourismVC.titlelable=@"司机指南";
        tourismVC.urlString=@"www.gaclixin.com/help/driver_manual.html";
        [delegate.mainViewNav pushViewController:tourismVC animated:YES];
        
    }
    if(indexPath.row==4)
    {
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        SetViewController  *setViewController=[[SetViewController alloc] init];
        setViewController.titlestring=@"设置";
        [delegate.mainViewNav pushViewController:setViewController animated:YES];
        
    }
    if(indexPath.row==5)
    {
        
        [self telephone:@"4008228846"];
        
    }

}







@end
