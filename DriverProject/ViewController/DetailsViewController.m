//
//  DetailsViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "MANaviViewC.h"

#import "leftsetCell.h"
#import "CCBLocationUtil.h"
#import "MyMessage.h"
#import "NavigationMapVC.h"

#import "DetailsVCCell.h"

@interface DetailsViewController ()<CCBLocationDelegate,UIAlertViewDelegate,MANaviViewDelegate>
{
    
    NSInteger _flag;
    NSDictionary *_orderDetailDic;
    NSInteger _flagorder;
    CCBLocationUtil *locationUtil;
    BOOL  receiveLoationBack;
    
}
@property(nonatomic,copy)void (^returnLocationblock)(void);
@property(nonatomic,strong)NSString *extraPay;

@end

@implementation DetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _flag=0;
    _flagorder=0;
    _extraPay=@"0";
    _driverstates=StateNullOrders;
    
    _orderDetailDic=[[NSDictionary alloc]init];
    
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
    _BackButton.frame=CGRectMake(TransfomXY(18), TransfomXY(41),25, 25);
    _BackButton.backgroundColor=[UIColor clearColor];
    [_BackButton addTarget:self action:@selector(BackViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_BackButton];
    _BackButton.center=_BackButtonimage.center;
    
    if(IOS7_OR_LATER)
    {
        _BackButton.center=CGPointMake(10, 20+(CUSTOM_NAV_HEIGHT-20)/2);
    }
    _BackButton.size=CGSizeMake(35, 35);
    _BackButton.left=15;
    
    
    _Timelable=[[UILabel alloc]initWithFrame:CGRectMake(TransfomXY(68), TransfomXY(95), 150,50)];
    //_Timelable.text=@"明天 17:30";
    _Timelable.textColor=Textwhite_COLOR;
    _Timelable.textAlignment=NSTextAlignmentLeft;
    _Timelable.font=[UIFont boldSystemFontOfSize:TransfomFont(56)];
    [self.view addSubview:_Timelable];
    [_Timelable sizeToFit];
    _Timelable.origin=CGPointMake(TransfomXY(68), TransfomXY(95));
    
    _Distancelable=[[UILabel alloc]initWithFrame:CGRectMake(TransfomXY(68), _Timelable.bottom+TransfomXY(14), 250, 40)];
    //_Distancelable.text=@"距离您: 35公里/70分钟";
    _Distancelable.textColor=Textwhite_COLOR;
    _Distancelable.numberOfLines=0;
    _Distancelable.textAlignment=NSTextAlignmentLeft;
    _Distancelable.font=[UIFont systemFontOfSize:TransfomFont(30)];
    [self.view addSubview:_Distancelable];
    
    
    _DetailsTableView=[[UITableView alloc]initWithFrame:FRAME(0, 200, KScreenWidth, KScreenHeight-200) style:UITableViewStylePlain];
    _DetailsTableView.delegate = self;
    _DetailsTableView.backgroundColor=[UIColor clearColor];
    _DetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _DetailsTableView.dataSource = self;
    
    [self.view addSubview:_DetailsTableView];
    
    
    _ConfirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton.frame=CGRectMake(20, 25, 50, 50);
    _ConfirmButton.backgroundColor=Assist_COLOR;
    _ConfirmButton.layer.cornerRadius=_ConfirmButton.width/2;
    _ConfirmButton.layer.masksToBounds = YES;
    [_ConfirmButton addTarget:self action:@selector(Confirm) forControlEvents:UIControlEventTouchUpInside];
    _ConfirmButton.center=CGPointMake(KScreenWidth-40, 200);
    [_ConfirmButton setImage:[UIImage imageNamed:@"ic_chevron_right_white.png"] forState:UIControlStateNormal];
    [self.view addSubview:_ConfirmButton];
    
    
    [self.backview.ConfirmButton addTarget:self action:@selector(goTo) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderProcessNewsSender:) name:@"OrderProcessNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderCancelSender:) name:@"CancelOrderNotifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"requestOrderData" object:nil];
    //订单已经支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookOrderDetails:) name:@"PaidOrderNotifi" object:nil];
}
- (void)CancelRefreshMainTable:(NSNotification *)info{
    
    //
    //    [DBModel DeleteCooMessageWithType:@"2"];
    //
    //
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"乘客已取消用车，请停止本次服务!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    //    alert.tag = 1003;
    //    [alert show];
}


-(void)lookOrderDetails:(NSNotification *)info{
    
    NSLog(@"－－－－－支付订单------");
    NSLog(@"%@",info.userInfo);
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:info.userInfo];
    
    NSString *action=[dic objectForKey:@"action"];
    if([action isEqualToString:@"order_paid"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您有一个订单已支付，请继续下次服务" delegate:self cancelButtonTitle:@"查看订单详情" otherButtonTitles:@"知道了", nil];
        alert.tag = 2001;
        [alert show];
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
    flages = 2;
}
-(void)viewDidDisappear:(BOOL)animated{
    flages = 0;
}

-(void)requestData
{
    if(_orderID!=nil){
        QiFacade*       facade;
        facade=[QiFacade sharedInstance];
        _flag=[facade getDriverOrderDetailsID:_orderID];
        [facade addHttpObserver:self tag:_flag];
        [self showLoadingWithText:@"加载中..."];
    }
}


#pragma mark   私有方法

- (void)OrderProcessNewsSender:(NSNotification *)text{
    
    NSLog(@"－－－－－接收到新订单------");
    NSLog(@"%@",text.userInfo);
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:text.userInfo];
    NSString *title=[[dic objectForKey:@"fee"] stringValue];
    NSLog(@"title=%@",title);
    if(_Timelable)
    {
        _Timelable.text=title;
        NSLog(@"_Timelable=%@",_Timelable);
    }
    
    NSString *lableStr =@"";
    lableStr =[NSString stringWithFormat:@"¥%@/%@km/%@min",[[dic objectForKey:@"fee"] stringValue],[[dic objectForKey:@"km"] stringValue],[[dic objectForKey:@"min"] stringValue]];
    [self setFrameDistancelable:lableStr];
    
}
//取消订单
- (void)OrderCancelSender:(NSNotification *)info{
    
    if(!info) return;
    
    
    NSLog(@"－－－－－取消订单------");
    NSLog(@"%@",info.userInfo);
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:info.userInfo];
    NSString *orderId=[dic objectForKey:@"order_id"];
    if([orderId isEqualToString:_orderID])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)BackViewController
{
    if ([_delegate respondsToSelector:@selector(refreshMainView:)]) {
        [_delegate refreshMainView:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Confirm
{
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showTextOnlyWith:@"请检查网络"];
        return;
    }
    
    if(_driverstates==StateEndAndPay)  return;
    [self showAlertView:_driverstates];
}

-(void)showAlertView:(OrdersStates)states
{
    
    NSString *title,*content;
    if(states==StateNullOrders)
    {
        
    }
    if(states==StateReceiveOrders)
    {
        title=@"前往接客点";
        content=@"为保障您的权益，出发前请先致电乘客确定合适的上车地点和上车时间";
        
    }
    if(states==Statesetoff)
    {
        title=@"到达接客点";
        content=@"为保障您的权益，请致电乘客告知您的确切位置";
        
    }
    if(states==StateGoToArrived)
    {
        title=@"开始计费";
        content=@"为保障您的权益，请确保乘客已上车";
        
    }
    
    if(states==StateGoToPickUp)
    {
        title=@"结束计费";
        content=@"本次行程已结束，停止计费";
    }
    if(states==StateBilling)
    {
        title=@"现金收款";
        content=@"为保障您的权益，请确认您已收到车款";
    }
    if(states==StateEndAndPay)
    {
        
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    if(states!=StateGoToPickUp)
    {
        alert.alertViewStyle=UIAlertViewStyleDefault;
    }else
    {
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *textField=[alert textFieldAtIndex:0];
        textField.placeholder=@"请您输入附加费用";
    }
    
    [alert show];
    [self setOrderIDLocationStrat];
}

-(void)setOrderIDLocationStrat
{
    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    if(array==nil)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        double newestlongitude=delegate.Newestlongitude;
        double newestlatutide=delegate.Newestlatutide;
        NSString *longitude=[NSString stringWithFormat:@"%f",newestlongitude];
        NSString *latutide=[NSString stringWithFormat:@"%f",newestlatutide];
        BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:[self getLocationTimeDate] totaldistance:@"0" distance:@"0" Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",Ordersetoff]];
        if(isSucces)
        {
            NSLog(@"保存成功");
            delegate.isInsertS = YES;
        }
    }
    
    
}



- (void)putStateGoToPickUpDis
{
    QiFacade* facade;
    facade=[QiFacade sharedInstance];
    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    NSArray *resultArray=[array objectAtIndex:0];
    if([array count]>0)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        double newestlongitude=delegate.Newestlongitude;
        double newestlatutide=delegate.Newestlatutide;
        
        double DBLastLon=[[resultArray objectAtIndex:3] doubleValue];
        double DBLastLat=[[resultArray objectAtIndex:4] doubleValue];
        double distance=[locationUtil getDistanceFromLatutide:DBLastLat fromLongitude:DBLastLon toLatutide:newestlatutide toLongitude:newestlongitude];
        
        NSString *distanceStr=[resultArray objectAtIndex:2];
        NSString *totalDistance=[NSString stringWithFormat:@"%f",([distanceStr doubleValue]+distance)];
        
        NSString *longitude=[NSString stringWithFormat:@"%f",newestlongitude];
        NSString *latutide=[NSString stringWithFormat:@"%f",newestlatutide];
        
        NSString *orderString=[NSString stringWithFormat:@"/order/%@/getoff",_orderID];
        _flagorder=[facade putDriverOrderState:orderString pointlat:latutide pointlon:longitude distance:totalDistance  ext:_extraPay];
    }
}

-(void)goTo
{
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *longitude=[NSString stringWithFormat:@"%f",delegate.Newestlongitude];
    NSString *latutide=[NSString stringWithFormat:@"%f",delegate.Newestlatutide];
    //0 默认 1 司机接单 2 司机发车 3 司机到达上车点 4 乘客上车行驶 5  等待付款 6已付款
    //+++++++++
    if(_driverstates==StateNullOrders)
    {
        
        
        
    }
    else if(_driverstates==StateReceiveOrders)
    {
        NSString *orderString=[NSString stringWithFormat:@"/order/%@/setoff",_orderID];
        _flagorder = [facade putDriverOrderState:orderString pointlat:latutide pointlon:longitude distance:@"100"];
        
    }
    
    else if(_driverstates == Statesetoff)
    {
        NSString *orderString=[NSString stringWithFormat:@"/order/%@/arrived",_orderID];
        _flagorder=[facade putDriverOrderState:orderString pointlat:latutide pointlon:longitude];
    }
    else if(_driverstates==StateGoToArrived)
    {
        NSString *orderString=[NSString stringWithFormat:@"/order/%@/geton",_orderID];
        _flagorder=[facade putDriverOrderState:orderString pointlat:latutide pointlon:longitude];
    }
    else if(_driverstates==StateGoToPickUp)
    {
        
        [self putStateGoToPickUpDis];
    }
    
    else if(_driverstates==StateBilling)
    {
        _flagorder=[facade putrDriverPaid:_orderID];
    }
    else if(_driverstates==StateEndAndPay)
    {
        
    }
    
    [facade addHttpObserver:self tag:_flagorder];
    [self DismossView];
    
}


#pragma mark ++++++tableView+++++++

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=4;
    //type  1即使单  2预约用车  3 预约接机  4预约送机
    NSString *type=[NSString stringWithFormat:@"%@",[_orderDetailDic objectForKey:@"type"]];
    if([type isEqualToString:@"3"] || [type isEqualToString:@"4"])
    {
        intergerNum=5;
    }
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"DetailsSetCell";
    DetailsVCCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[DetailsVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.isIndentationWidth = YES;
    sectionCell.setlable.text=@"";
    sectionCell.showTopSeperateLine=NO;
    NSInteger Row=(NSInteger)indexPath.row;
    switch (Row) {
        case 0:
            
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_access_time_darkgray_24dp.png"];
            sectionCell.setlable.text=[_orderDetailDic objectForKey:@"time"];
            break;
            
        case 1:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
            NSDictionary *startPoint=[_orderDetailDic objectForKey:@"origin"];
            sectionCell.setlable.text=[startPoint objectForKey:@"name"];
            
            break;
        }
        case 2:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_pin_drop_orange_24dp.png"];
            //sectionCell.setlable.text=@"广州南站";
            NSDictionary *finishPoint=[_orderDetailDic objectForKey:@"dest"];
            sectionCell.setlable.text=[finishPoint objectForKey:@"name"];
            break;
        }
        case 3:
        {
            sectionCell.setlable.text=@"";
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_call_darkgray_24dp.png"];
            //sectionCell.setlable.text=@"胡先生 18929875467";
            NSDictionary *passengerDic=[_orderDetailDic objectForKey:@"passenger"];
            if(passengerDic!=nil)
            {
                sectionCell.setlable.text=[NSString stringWithFormat:@"%@   %@",[passengerDic objectForKey:@"name"],[passengerDic objectForKey:@"phone"]];
            }
            
            break;
        }
        case 4:
        {
            //type  1即使单  2预约用车  3 预约接机  4预约送机
            
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_flight_darkgray_24dp.png"];
            NSDictionary *flightDic=[_orderDetailDic objectForKey:@"flight"];
            NSString *type=[NSString stringWithFormat:@"%@",[_orderDetailDic objectForKey:@"type"]];
            NSString *flightS = @""; //[NSString stringWithFormat:@"送机/接机(航班号:%@)",[flightDic objectForKey:@"no"]];
            if([type isEqualToString:@"3"])
            {
                flightS = [NSString stringWithFormat:@"接机(%@，航班号：%@)",[flightDic objectForKey:@"date"],[flightDic objectForKey:@"no"]];
            }
            if([type isEqualToString:@"4"])
            {
                flightS = @"送机";
            }
            sectionCell.setlable.text=flightS;
            break;
        }
            
        default:
            break;
    }
    
    
    if(!([sectionCell.setlable.text length]>0))
    {
        sectionCell.setlable.text=@"";
    }
    //最后一行不缩进
    
    
    
    
    NSString *type=[NSString stringWithFormat:@"%@",[_orderDetailDic objectForKey:@"type"]];
    if([type isEqualToString:@"3"]||[type isEqualToString:@"4"])
    {
        if(indexPath.row==4)
        {
            sectionCell.isIndentationWidth=NO;
        }
    }
    else
    {
        if(indexPath.row==3)
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
    return 44;
}

#pragma mark -AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    _extraPay=@"0";
    NSInteger tags = alertView.tag;
    if(tags == 2001){
        
        if(buttonIndex == 0)
        {
            ViewOrdersController *detailsView=[[ViewOrdersController alloc] init];
            detailsView.orderID = self.orderID;
            [self.navigationController pushViewController:detailsView animated:YES];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            if ([_delegate respondsToSelector:@selector(refreshMainView:)]) {
                [_delegate refreshMainView:NO];
            }
        }
        
        
    }else{
        
        if(buttonIndex==0)
        {
            
            if(alertView.alertViewStyle==UIAlertViewStylePlainTextInput)
            {
                NSString *pay=[alertView textFieldAtIndex:0].text;
                if(![pay isEqualToString:@""])
                {
                    _extraPay=pay;
                    NSLog(@"_extraPay==%@",_extraPay);
                    [[alertView textFieldAtIndex:0] resignFirstResponder];
                }
                [self stopCalculatePay];
            }
            else
            {
                if(_driverstates == StateGoToArrived)
                {
                    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if(delegate.isInsertS)
                    {
                        [self goTo];
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"获取定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else
                {
                    [self goTo];
                    if ([_delegate respondsToSelector:@selector(refreshMainView:)]) {
                        [_delegate refreshMainView:NO];
                    }
                }
            }
            
        }
    }
}


-(void)stopCalculatePay
{
    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    NSArray *resultArray=[array objectAtIndex:0];
    if([array count]>0)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        double newestlongitude=delegate.Newestlongitude;
        double newestlatutide=delegate.Newestlatutide;
        
        double DBLastLon=[[resultArray objectAtIndex:3] doubleValue];
        double DBLastLat=[[resultArray objectAtIndex:4] doubleValue];
        double distance=[locationUtil getDistanceFromLatutide:DBLastLat fromLongitude:DBLastLon toLatutide:newestlatutide toLongitude:newestlongitude];
        
        NSString *distanceStr=[resultArray objectAtIndex:2];
        NSString *totalDistance=[NSString stringWithFormat:@"%f",([distanceStr doubleValue]+distance)];
        
        NSString *longitude=[NSString stringWithFormat:@"%f",newestlongitude];
        NSString *latutide=[NSString stringWithFormat:@"%f",newestlatutide];
        NSString *timeNow=[self getLocationTimeDate];
        
        BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:timeNow totaldistance:totalDistance distance:_extraPay Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",5]];
        if(isSucces)
        {
            [self goTo];
        }
    }
}
-(NSString *)getLocationTimeDate
{
    NSString *timeDate=@"";
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeDate=locationString;
    
    return timeDate;
}

#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==2 ||indexPath.row == 1)
    {
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            [self showTextOnlyWith:@"请检查网络"];
            return;
        }
        
        NSDictionary *dest = [_orderDetailDic objectForKey:@"dest"];
        if (indexPath.row == 1) {
            dest = [_orderDetailDic objectForKey:@"origin"];
        }
        CGFloat Lat=[[dest objectForKey:@"lat"]floatValue];
        CGFloat Lon=[[dest objectForKey:@"lon"]floatValue];
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        MANaviViewC *manaviViewC=[[MANaviViewC alloc] init];
        manaviViewC.delegate = self;
        if(delegate.Newestlatutide!=0 &&delegate.Newestlongitude!=0)
        {
            manaviViewC.StartPoint=[AMapGeoPoint locationWithLatitude:Lat longitude:Lon];
            manaviViewC.FinishPoint=[AMapGeoPoint locationWithLatitude:Lat longitude:Lon];
            
            [self presentViewController:manaviViewC animated:YES completion:^{
            }];
            //            NavigationMapVC *navigaMap = [[NavigationMapVC alloc] init];
            //            [self.navigationController pushViewController:manaviViewC animated:YES];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    if(indexPath.row==3)
    {
        NSDictionary *passengerDic=[_orderDetailDic objectForKey:@"passenger"];
        NSString*phone=[passengerDic objectForKey:@"phone"];
        [self telephone:phone];
    }
}

-(void)refreshView{
    
    //    [self requestData];
    
    [_DetailsTableView reloadData];
    
}
-(void)telephone:(NSString *)phoneNum
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
    
}



#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    
    NSString *lableStr=@"";
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"成功 /n%@",response);
    
    NSDictionary *OrderDic=[response objectForKey:@"data"];
    if(_flag != 0 && iRequestTag == _flag)
    {
        _flag=0;
        _orderDetailDic=[NSDictionary dictionaryWithDictionary:response];
        [_DetailsTableView reloadData];
        _Timelable.text=[_orderDetailDic objectForKey:@"time"];
        
        //0 默认 1 司机接单 2 司机发车 3 司机到达上车点 4 乘客上车行驶 5  等待付款 6已付款
        NSString *statusString=[NSString stringWithFormat:@"%@",[_orderDetailDic objectForKey:@"status"]];
        NSInteger status=[statusString integerValue];
        if(status == 0) status=1;
        
        
        switch (status) {
            case 0:
                _driverstates = StateNullOrders;
                break;
            case 1:
            {
                _driverstates = StateReceiveOrders;
                _Timelable.text=@"";
                lableStr =  [self backTringFromtype];
                delegate.ProcessStates=Ordersetoff;
                delegate.orderID = _orderID;
                break;
            }
            case 2:
            {
                _driverstates=Statesetoff;
                
                _Timelable.text=@"前往接客点";
                lableStr =@"带十分小心上路，携一份平安回家";
                delegate.ProcessStates=Orderonway;
                delegate.orderID=_orderID;
                
                break;
            }
            case 3:
            {
                _driverstates=StateGoToArrived;
                
                _Timelable.text=@"等待乘客";
                lableStr =@"耐心，是我们丽新人的品质！";
                delegate.ProcessStates=Orderarrived;
                delegate.orderID=_orderID;
                
                break;
            }
            case 4:{
                _driverstates=StateGoToPickUp;
                _Timelable.text=@"行程中";
                lableStr =@"¥0.00/0km/0min";
                delegate.ProcessStates=OrderProcess;
                delegate.orderID=_orderID;
                
                break;
            }
            case 5:{
                _driverstates=StateBilling;
                // lableStr =@"¥120.00/1.2km/70min";
                if(OrderDic)
                {
                    _Timelable.text=[NSString stringWithFormat:@"%@元",[[OrderDic objectForKey:@"fee"] stringValue]];
                    lableStr=[NSString stringWithFormat:@"¥%@/%@km/%@min",[[OrderDic objectForKey:@"fee"] stringValue],[[OrderDic objectForKey:@"km"] stringValue],[[OrderDic objectForKey:@"minutes"] stringValue]];
                }
                else
                {
                    _Timelable.text=[NSString stringWithFormat:@"%@元",[[response objectForKey:@"fee"] stringValue]];
                    lableStr=[NSString stringWithFormat:@"¥%@/%@km/%@min",[[response objectForKey:@"fee"] stringValue],[[response objectForKey:@"km"] stringValue],[[response objectForKey:@"minutes"] stringValue]];
                }
                [_ConfirmButton setImage:[UIImage imageNamed:@"ic_money_white@3x.png"] forState:UIControlStateNormal];
                delegate.ProcessStates = Ordergetoff;
                delegate.orderID=_orderID;
                break;
            }
            case 6:{
                _driverstates=StateEndAndPay;
                _Timelable.text=@"结束";
                lableStr =@"";
                break;
            }
            default:
                break;
        }
    }
    
    if(_flagorder!=0&&iRequestTag==_flagorder)
    {
        _flagorder=0;
        if(_driverstates==StateNullOrders)
        {
            
            _driverstates=StateReceiveOrders;
            _Timelable.text=@"前往接客点";
            lableStr =@"为避免等待时间过长,请到达接客点10分钟前联系顾客";
            
            delegate.ProcessStates=Ordersetoff;
            delegate.orderID=_orderID;
            
            
        }
        else if(_driverstates==StateReceiveOrders)
        {
            _driverstates=Statesetoff;
            
            _Timelable.text=@"前往接客点";
            lableStr =@"带十分小心上路，携一份平安回家";
            
            delegate.ProcessStates=Orderonway;
            delegate.orderID=_orderID;
            
        }
        else if(_driverstates==Statesetoff)
        {
            _driverstates=StateGoToArrived;
            _Timelable.text=@"等待乘客";
            lableStr =@"耐心，是我们丽新人的品质！";
            delegate.ProcessStates=Orderarrived;
            delegate.orderID=_orderID;
            
            
        }
        
        else if(_driverstates==StateGoToArrived)
        {
            _driverstates=StateGoToPickUp;
            _Timelable.text=@"行程中";
            lableStr =@"¥0.00/0.0km/0min";
            
            delegate.isInsertS = NO;
            delegate.ProcessStates=OrderProcess;
            delegate.orderID=_orderID;
        }
        else if(_driverstates==StateGoToPickUp)
        {
            _driverstates=StateBilling;
            _Timelable.text=[[OrderDic objectForKey:@"fee"] stringValue];
            lableStr=[NSString stringWithFormat:@"¥%@/%@km/%@min",[[OrderDic objectForKey:@"fee"] stringValue],[[OrderDic objectForKey:@"km"] stringValue],[[OrderDic objectForKey:@"min"] stringValue]];
            delegate.ProcessStates=Ordergetoff;
            delegate.orderID=_orderID;
            [_ConfirmButton setImage:[UIImage imageNamed:@"ic_money_white@3x.png"] forState:UIControlStateNormal];
            BOOL isdelete = [DBModel DeleteCooMessageWithType:@"2"];
            if(isdelete)
            {
                NSLog(@"删除成功");
            }
            
        }
        else if(_driverstates==StateBilling)
        {
            _driverstates=StateEndAndPay;
            delegate.ProcessStates=Ordergetoff;
            delegate.orderID=_orderID;
            [self BackViewController];
        }
        
    }
    //调整
    [self setFrameDistancelable:lableStr];
    
}


-(void)setFrameDistancelable:(NSString *)lableStr
{
    
    if(_driverstates!=StateNOTKnown)
    {
        [_Timelable sizeToFit];
        _Timelable.frame=CGRectMake(60, 60, 250, 100);
        _Timelable.origin=CGPointMake(60, 30);
        //++调整+++
        _Distancelable.text=lableStr;
        _Distancelable.lineBreakMode = NSLineBreakByWordWrapping;
        _Distancelable.numberOfLines=0;
        
        CGRect txtFrame = _Distancelable.frame;
        txtFrame = CGRectMake(30, _Timelable.bottom, 250, 100);
        txtFrame.size.height =[lableStr boundingRectWithSize:
                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:_Distancelable.font,NSFontAttributeName, nil] context:nil].size.height;
        _Distancelable.frame=txtFrame;
        _Distancelable.left=_Timelable.left;
        _Distancelable.top=_Timelable.bottom+TransfomXY(0);
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
-(NSString*)backTringFromtype
{
    //type  1即使单  2预约用车  3 预约接机  4预约送机
    NSString *lableStr = @"";
    if([_type isEqualToString:@"1"])
    {
        _Timelable.text=@"即时单";
        lableStr =@"请立即出发\n温馨提醒：致电乘客确定具体信息";
    }
    if([_type isEqualToString:@"2"])
    {
        _Timelable.text=@"预约用车";
        lableStr =@"为了确保服务顺利，请酌情出发";
    }
    if([_type isEqualToString:@"4"])
    {
        _Timelable.text=@"送机服务";
        lableStr =@"为了确保服务顺利，请酌情出发";
    }
    if([_type isEqualToString:@"3"])
    {
        _Timelable.text=@"接机服务";
        lableStr =@"为了确保服务顺利，请酌情出发";
    }
    
    return  lableStr;
    
}



@end
