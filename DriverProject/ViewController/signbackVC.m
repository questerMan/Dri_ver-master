//
//  signbackVC.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-10-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "signbackVC.h"
#import "MyMessage.h"
@interface signbackVC ()<UIAlertViewDelegate>
{
    NSInteger _flag;
    NSArray *orderDetailArr;
    NSString *_reason;
    NSString * _signOut;
}
@end

@implementation signbackVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _flag=0;
    _driverstates=StateNullOrders;
    _reason=@"签退";
    _signOut=@"";
    orderDetailArr=[[NSArray alloc]initWithObjects:@"中途作息",@"就餐",@"车辆加油",@"道路拥挤",@"车辆故障或事故", nil];
    
    self.view.backgroundColor=Textwhite_COLOR;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    backView.backgroundColor=Main_COLOR;
    [self.view addSubview:backView];
    
    
    _BackButtonimage=[[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 11.5, 19)];
     _BackButtonimage.size=CGSizeMake(11.5, 19);
    _BackButtonimage.image=[UIImage imageNamed:@"common_navbar_returnw.png"];
    _BackButtonimage.center=CGPointMake(25, 40);
    [self.view addSubview:_BackButtonimage];
    
    _BackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _BackButton.frame=CGRectMake(20, 25, 45, 45);
    _BackButton.backgroundColor=[UIColor clearColor];
    [_BackButton addTarget:self action:@selector(BackViewController) forControlEvents:UIControlEventTouchUpInside];
    //[_BackButton setBackgroundImage:[UIImage imageNamed:@"ic_arrow_left_white.png"] forState:UIControlStateNormal];
    [self.view addSubview:_BackButton];
    _BackButton.center=_BackButtonimage.center;
    
    _Timelable=[[UILabel alloc]initWithFrame:CGRectMake(60, 60, 150,50)];
    _Timelable.text=@"收车签退";
    _Timelable.textColor=Textwhite_COLOR;
    _Timelable.textAlignment=NSTextAlignmentLeft;
    _Timelable.font=[UIFont boldSystemFontOfSize:25];
    [self.view addSubview:_Timelable];
    
    _Distancelable=[[UILabel alloc]initWithFrame:CGRectMake(60, _Timelable.bottom, 250, 40)];
    _Distancelable.text=@"收车签退将不会通知新订单";
    _Distancelable.textColor=Textlightwhite_COLOR;
    _Distancelable.numberOfLines=0;
    _Distancelable.textAlignment=NSTextAlignmentLeft;
    _Distancelable.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_Distancelable];
    
    
    _DetailsTableView=[[UITableView alloc]initWithFrame:FRAME(0, 200, KScreenWidth, KScreenHeight-200) style:UITableViewStylePlain];
    _DetailsTableView.delegate = self;
    //_DetailsTableView.separatorColor=[UIColor clearColor];
    _DetailsTableView.backgroundColor=[UIColor clearColor];
    _DetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _DetailsTableView.dataSource = self;
    
    [self.view addSubview:_DetailsTableView];
    
    
    _signoutButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _signoutButton.frame=CGRectMake(20, 25, 56, 56);
    _signoutButton.backgroundColor=Assist_COLOR;
    _signoutButton.layer.cornerRadius=_signoutButton.width/2;
    _signoutButton.layer.masksToBounds = YES;
    [_signoutButton addTarget:self action:@selector(signoutBu) forControlEvents:UIControlEventTouchUpInside];
    _signoutButton.center=CGPointMake(KScreenWidth-40, 200);
    [_signoutButton setImage:[UIImage imageNamed:@"ic_power_settings_new_white.png"] forState:UIControlStateNormal];
    [self.view addSubview:_signoutButton];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)requestData
{
    NSString *reason = [_reason copy];
    NSString *signOut =[_signOut copy];
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade putDriverSignoutState:signOut reasonFor:reason];
    [facade addHttpObserver:self tag:_flag];
    [self showLoadingWithText:@"加载"];
}


#pragma mark   私有方法
-(void)BackViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)signoutBu
{
    _reason=@"是否确定下班收车？";
    _signOut=@"1";
    [self signoutB];
}


-(void)signoutB
{

    NSString *title=@"收车";
    if([_signOut isEqualToString:@"2"])
    {
        title=@"收车";
    }
    else
    {
        title=@"签退下班";
    }
    NSString *reason = [_reason copy];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:[NSString stringWithFormat:@"%@",reason] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
    

    
}
#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
            [self requestData];
        }
            break;
        case 1:
        {
            
            
        }break;
            /*
             *冗余代码，不会触发
             */
        default:
            break;
    }


}

#pragma mark ++++++tableView+++++++

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=4;
    //type  1即使单  2预约用车  3 预约接机  4预约送机

    intergerNum=5;
    
    
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"DetailsSetCell";
    leftsetCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[leftsetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.isIndentationWidth=YES;
    NSLog(@"===%ld",(long)indexPath.row);
    NSInteger Row=(NSInteger)indexPath.row;
    switch (Row) {
        case 0:
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_local_cafe_darkgray.png"];
            //sectionCell.setlable.text=@"2015-08-16";
            sectionCell.setlable.text=[orderDetailArr objectAtIndex:indexPath.row];
            break;
            
        case 1:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_local_dining_darkgray.png"];
            //sectionCell.setlable.text=@"琶洲一号";
            sectionCell.setlable.text=[orderDetailArr objectAtIndex:indexPath.row];
            
            break;
        }
        case 2:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_local_gas_station_darkgray.png"];
            sectionCell.setlable.text=[orderDetailArr objectAtIndex:indexPath.row];
            break;
        }
        case 3:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_traffic_black_24dp.png"];
            sectionCell.setlable.text=[orderDetailArr objectAtIndex:indexPath.row];
            
            break;
        }
        case 4:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_build_darkgray.png"];
            sectionCell.setlable.text=[orderDetailArr objectAtIndex:indexPath.row];
            break;
        }
            
            
        default:
            break;
    }
    //最后一行不缩进
    
    
    
    

        if(indexPath.row==4)
        {
            sectionCell.isIndentationWidth=NO;
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
    _reason=[NSString stringWithFormat:@"%@，停止新订单提醒",[orderDetailArr objectAtIndex:indexPath.row]];
    _signOut=@"2";
    [self signoutB];
    
}




#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSString *lableStr=@"";
 
    if(_flag!=0&&iRequestTag==_flag)
    {
        MyMessage *message=[MyMessage instance] ;
        message.isOnline=@"NO";
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
       //调整
    [self setFrameDistancelable:lableStr];
    
}


-(void)setFrameDistancelable:(NSString *)lableStr
{
    
    if(_driverstates!=StateNOTKnown)
    {
        //++调整+++
        _Distancelable.text=lableStr;
        _Distancelable.lineBreakMode = NSLineBreakByWordWrapping;
        _Distancelable.numberOfLines=0;
        
        CGRect txtFrame = _Distancelable.frame;
        txtFrame = CGRectMake(60, _Timelable.bottom, 250, 100);
        txtFrame.size.height =[lableStr boundingRectWithSize:
                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:_Distancelable.font,NSFontAttributeName, nil] context:nil].size.height;
        _Distancelable.frame=txtFrame;
    }
    
    
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
    }
    
    
    
    NSLog(@"失败 /n%@",response);
    
}


@end
