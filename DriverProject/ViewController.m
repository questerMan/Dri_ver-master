//
//  ViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "MyMessage.h"
#import "ViewOrdersController.h"
#import "ASIFormDataRequest.h"

#import "DriverCell.h"
#import "CCBWindow.h"
#import "signbackVC.h"

#import "MJRefresh.h"

#import <AudioToolbox/AudioToolbox.h>

#define TOP_LABLE  15


@interface ViewController ()
<
MainWindowDelegate,
LeftRemoveViewDelegate
,DetailsViewControllerDelegate,
UIAlertViewDelegate
>
{
    NSDictionary *_userDic;
    NSInteger  _flag;
    NSMutableArray *_ordersList;
    
    NSInteger  _flagOnline;
    NSInteger  _flagOffline;
    
    NSInteger _flagreply;//应单
    
    NSInteger _flagInfo;//获取司机资料
    
    NSInteger _page;
    BOOL isMore;
    NSString *_paidOrder_id;
    UILabel *_NotDatalable;
    BOOL    _isRefresh;
    
    
    
}
@property(nonatomic,strong)UIButton *backButton;
@end

@implementation ViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)ADDtableView
{
    _page=1;isMore=NO;
    _setButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _setButton.frame=CGRectMake(20,self.view.height-50, 24, 24);
    _setButton.layer.masksToBounds = YES;
    [_setButton addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_setButton setBackgroundImage:[UIImage imageNamed:@"ic_menu_white_24dp.png"] forState:UIControlStateNormal];
    [self.view addSubview:_setButton];
    
    _setButton.center=CGPointMake(15, CUSTOM_NAV_HEIGHT/2);
    if(IOS7_OR_LATER)
    {
        _setButton.center=CGPointMake(15, 20+(CUSTOM_NAV_HEIGHT-20)/2);
        
    }
    
    _setButton.left=18;
    _driverTable=[[UITableView alloc]initWithFrame:FRAME(0, 200, KScreenWidth, KScreenHeight-200) style:UITableViewStylePlain];    _driverTable.delegate = self;
    _driverTable.separatorColor=[UIColor clearColor];
    _driverTable.backgroundColor=[UIColor whiteColor];
    _driverTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _driverTable.dataSource = self;
    [self.view addSubview:_driverTable];
    
    _NotDatalable=[[UILabel alloc]initWithFrame:CGRectZero];
    _NotDatalable.text=@"下拉刷新订单！";
    _NotDatalable.textColor=TextDisable_COLOR;
    _NotDatalable.textAlignment=NSTextAlignmentCenter;
    _NotDatalable.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_NotDatalable];
    //    [_NotDatalable sizeToFit];
    _NotDatalable.width = self.view.width;
    _NotDatalable.height = 30;
    _NotDatalable.backgroundColor = [UIColor whiteColor];
    _NotDatalable.center=_driverTable.center;
    _NotDatalable.top = _driverTable.top;
    
    _DriverunButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _DriverunButton.frame=CGRectMake(20, 25, 56, 56);
    _DriverunButton.backgroundColor=Assist_COLOR;
    [_DriverunButton setTitle:@"出车" forState:UIControlStateNormal];
    [_DriverunButton setImage:[UIImage imageNamed:@"ic_directions_car_white_36dp.png"] forState:UIControlStateNormal];
    _DriverunButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [_DriverunButton setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 10, 10)];
    _DriverunButton.layer.cornerRadius=_DriverunButton.width/2;
    _DriverunButton.layer.masksToBounds = YES;
    [_DriverunButton addTarget:self action:@selector(RunDriver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_DriverunButton];
    _DriverunButton.center=CGPointMake(KScreenWidth-40, KScreenHeight-40);
    _DriverunButton.titleLabel.textColor=UIColorFromRGB(0xffffff);
    
    [self addButton];
}

-(void)addButton
{
    UIButton *mysetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    mysetButton.frame=CGRectMake(20,self.view.height-50, 55, 55);
    mysetButton.backgroundColor=[UIColor clearColor];
    [mysetButton addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mysetButton];
    
    mysetButton.center=_setButton.center;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _flag=0;
    _flagOnline=0;
    _flagOffline=0;
    _flagInfo=0;
    _isRefresh = NO;
    MyMessage *mymessage=[MyMessage instance];
    
    mymessage.isOnline = @"NO";
    
    
    [self initLable];
    [self initUI];
    [self ADDtableView];
    [self crateNotification];
    NSLog(@"viewDidLoad");
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderselector:) name:@"NewOrderNotifi" object:nil];
    CCBWindow *Mywindow=[CCBWindow instance];
    Mywindow.MainDelegate=self;
    
    
    _rightSwipGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setBtnClicked)];
    _rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
    [_rightSwipGestureRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:_rightSwipGestureRecognizer];
    
    [self addMJRefresh];
    [self ReLoadingTableViewDate];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshMainTable:) name:@"RefreshNotifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CancelRefreshMainTable:) name:@"CancelOrderNotifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookOrderDetails:) name:@"PaidOrderNotifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookOrderDetails:) name:@"InvoiceOrderNotifi" object:nil];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    MyMessage *mymessage=[MyMessage instance];
//    NSLog(@"%@",mymessage.isOnline);
//}

- (void)crateNotification
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(refreshData) name:@"NEWS_REFRESH" object:nil];
}

- (void)refreshData{
    
    _page = 1;
    isMore = NO;
    
    NSString *pageS=[NSString stringWithFormat:@"%d",(int)_page];
    [self getData:pageS];
    // 结束刷新
    [_driverTable.header endRefreshing];
    [_driverTable reloadData];
}


-(void)addMJRefresh
{
    __weak UITableView *tableView = _driverTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        isMore = NO;
        
        NSString *pageS=[NSString stringWithFormat:@"%d",(int)_page];
        [self getData:pageS];
        // 结束刷新
        [tableView.header endRefreshing];
        [tableView reloadData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
}

#pragma mark   MainWindowDelegate
-(void)ReLoadingTableViewDate
{
    NSLog(@"刷新");
    [self getData:@"1"];
    [_driverTable reloadData];
    
}

-(void)showAlertView
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"订单已被取消或有其他司机已应单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



-(void)initLable
{
    _drivername=[[UILabel alloc]initWithFrame:CGRectZero];
    _drivername.text=@"";
    _drivername.textColor=[UIColor blackColor];
    _drivername.textAlignment=NSTextAlignmentLeft;
    _drivername.font=[UIFont systemFontOfSize:TransfomFont(72)];
    [self.view addSubview:_drivername];
    
    _driverinformation=[[UILabel alloc]initWithFrame:CGRectZero];
    //_driverinformation.text=@"舒适性";
    _driverinformation.textColor=[UIColor blackColor];
    _driverinformation.textAlignment=NSTextAlignmentLeft;
    _driverinformation.font=[UIFont systemFontOfSize:TransfomFont(36)];
    [self.view addSubview:_driverinformation];
    
    _drivername.textColor=Textwhite_COLOR;
    
    _driverinformation.textColor=Textwhite_COLOR;
    //_driverinformation.text=@"粤A84930 舒适性";
    
    [_drivername sizeToFit];
    _drivername.left=TransfomXY(136);
    _drivername.top=TransfomXY(172);
    
    _driverinformation.center=_drivername.center;
    _driverinformation.top=_drivername.bottom+TransfomXY(10);
    
    [self getInfo];  //获取司机资料
    
}

-(void)viewWillAppear:(BOOL)animated
{
    flages = 1;
    _isRefresh = NO;
    MyMessage *mymessage=[MyMessage instance];
    
    NSString *isOnline=mymessage.isOnline;
    
    
    if([isOnline isEqualToString:@"NO"]){
        [_DriverunButton setTitle:@"出车" forState:UIControlStateNormal];
        _DriverunButton.backgroundColor=Assist_COLOR;
    }else
    {
        [_DriverunButton setTitle:@"收车" forState:UIControlStateNormal];
        _DriverunButton.backgroundColor=Main_COLOR;
    }
    
    if([mymessage.userinfoDic count]>0)
    {
        NSLog(@"mymessage.userinfoDic==%@",mymessage.userinfoDic);
        
        _userDic=[NSDictionary dictionaryWithDictionary:mymessage.userinfoDic];
        if(_userDic)
        {
            [self ReLable];
        }
    }
    else
    {
        _ratingBar.hidden=YES;
        
        QiFacade*       facade;
        facade=[QiFacade sharedInstance];
        _flagInfo=[facade getDriverInfo];
        [facade addHttpObserver:self tag:_flagInfo];
        
    }
    
    
    if([_ordersList count]>0)
    {
        _NotDatalable.hidden = YES;
    }
    else
    {
        _NotDatalable.hidden = NO;
    }
    
}

//RefreshMainTable
- (void)RefreshMainTable:(NSNotification *)info{
    
    //[self getInfo];  //获取司机资料
    [self performSelector:@selector(ReLoadingTableViewDate) withObject:nil afterDelay:0.5];
}

- (void)CancelRefreshMainTable:(NSNotification *)info{
    
    
    [DBModel DeleteCooMessageWithType:@"2"];
    
    
    [self ReLoadingTableViewDate];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"乘客已取消用车，请停止本次服务!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    alert.tag = 1003;
    [alert show];
}

-(void)viewDidDisappear:(BOOL)animated{
    flages = 0;
}

-(void)lookOrderDetails:(NSNotification *)info{

    NSLog(@"－－－－－支付订单------");
    NSLog(@"%@",info.userInfo);
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:info.userInfo];
    
    NSString *action=[dic objectForKey:@"action"];
    NSString *orderId=[dic objectForKey:@"order_id"];
    if([action isEqualToString:@"order_paid"])
    {
        _paidOrder_id = orderId;
        if (flages == 1) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您有一个订单已支付，请继续下次服务" delegate:self cancelButtonTitle:@"查看订单详情" otherButtonTitles:@"知道了", nil];
            alert.tag = 1001;
            [alert show];
            
        }
    }
    if([action isEqualToString:@"order_invoice"])
    {
        _paidOrder_id = orderId;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"乘客申请索要手撕发票，请知释" delegate:self cancelButtonTitle:@"查看订单详情" otherButtonTitles:@"知道了", nil];
        alert.tag = 1002;
        [alert show];
    }
    
    
}


- (void)newOrderselector:(NSNotification *)text{
    
    NSLog(@"－－－－－View接收到新订单------");
    NSLog(@"%@",text.userInfo);
    
}
#pragma mark  DetailsViewControllerDelegate

- (void)refreshMainView:(BOOL)isRefrsh
{
    _isRefresh = isRefrsh;
    [self ReLoadingTableViewDate];
}

#pragma mark   LeftRemoveViewDelegate
- (void)RemoveLeftView
{
    if(_mysetView!=nil&&_backButton!=nil)
    {
        [self removesetView];
    }
}
#pragma mark  网络请求

-(void)getInfo
{
    
    MyMessage *mymessage=[MyMessage instance];
    if([mymessage.userinfoDic count]>0)
    {
        NSLog(@"mymessage.userinfoDic==%@",mymessage.userinfoDic);
        
        _userDic=[NSDictionary dictionaryWithDictionary:mymessage.userinfoDic];
        if(_userDic)
        {
            [self ReLable];
        }
    }
    //    else
    //    {
    _ratingBar.hidden=YES;
    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flagInfo=[facade getDriverInfo];
    [facade addHttpObserver:self tag:_flagInfo];
    
    //  }
}

-(void)getData:(NSString *)page
{
    if([page isEqualToString:@"1"])
    {
        [_ordersList removeAllObjects];
    }
    
    //请求
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade getDriverOrderListPage:page perPage:@"10"];
    NSLog(@"takeOutMoneyFlag=%ld",(long)_flag);
    [facade addHttpObserver:self tag:_flag];
    if(_isRefresh){
        [self showLoadingWithText:@"加载中..."];
    }else{
        _isRefresh = YES;
    }
}


-(void)ReLable
{
    if(_userDic)
    {
        //car_type   1 经济型 2 舒适型 3 商务型
        //        NSString *driverinformationString=@"";
        //        NSString *car_type=[NSString stringWithFormat:@"%@",[_userDic objectForKey:@"car_type"]];
        //        if([car_type isEqualToString:@"1"])
        //        {
        //            driverinformationString=[NSString stringWithFormat:@"%@ 经济型",[_userDic objectForKey:@"license"]];
        //        }
        //        if([car_type isEqualToString:@"2"])
        //        {
        //            driverinformationString=[NSString stringWithFormat:@"%@ 舒适型",[_userDic objectForKey:@"license"]];
        //        }
        //        if([car_type isEqualToString:@"3"])
        //        {
        //            driverinformationString=[NSString stringWithFormat:@"%@ 商务型",[_userDic objectForKey:@"license"]];
        //        }
        _driverinformation.text= [NSString stringWithFormat:@"%@ %@", [_userDic objectForKey:@"brand"], [_userDic objectForKey:@"car_name"]];
        
        
        _drivername.text=[_userDic objectForKey:@"nickname"];
        [_ratingBar displayRating:[[_userDic objectForKey:@"star"] floatValue]];
        
        _drivername.size=CGSizeMake([MyMessage widthFromWord:_drivername.text fontSize:_drivername.font], [MyMessage HeightFromfontSize:_drivername.font]);
        _drivername.backgroundColor=[UIColor clearColor];
        [_drivername sizeToFit];
        _drivername.origin=CGPointMake(60,60);
        
        [_driverinformation sizeToFit];
        _driverinformation.origin=CGPointMake(60, TransfomXY(10)+_drivername.bottom);
        
        _ratingBar.left=_drivername.left;
        _ratingBar.top=_driverinformation.bottom+TransfomXY(23);
        _ratingBar.hidden = NO;
        //        MyMessage *mymessage=[MyMessage instance];
        //        NSString *status=[_userDic objectForKey:@"status"];
        
        
        //        if([status isEqualToString:@"2"]){
        //            [_DriverunButton setTitle:@"收车" forState:UIControlStateNormal];
        //            _DriverunButton.backgroundColor=Main_COLOR;
        //            mymessage.isOnline=@"YES";
        //        }else
        //        {
        //            [_DriverunButton setTitle:@"出车" forState:UIControlStateNormal];
        //            _DriverunButton.backgroundColor=Assist_COLOR;
        //            mymessage.isOnline=@"NO";
        //        }
        
    }
}

-(void)initUI
{
    _ordersList=[[NSMutableArray alloc]initWithCapacity:0];
    _userDic=[[NSDictionary alloc]init];
    
    
    //评分
    _ratingBar = [[RatingBar alloc] init];
    _ratingBar.frame = CGRectMake(60, 100, 100, 30);
    _ratingBar.center=_drivername.center;
    _ratingBar.top=_driverinformation.bottom+TransfomXY(22);
    //_ratingBar.left-=10;
    [self.view addSubview:_ratingBar];
    _ratingBar.showheight=25;
    _ratingBar.backgroundColor=[UIColor clearColor];
    _ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [_ratingBar setImageDeselected:@"ic_star_border_white_24dp.png" halfSelected:@"ic_star_half_white_24dp.png" fullSelected:@"ic_star_white_24dp.png" andDelegate:self];
    [_ratingBar displayRating:2.5];
    _ratingBar.hidden = YES;
    // [_DriverunButton AddButton:self];
    // _DriverunButton.backgroundColor=[UIColor grayColor];
}



#pragma 私有方法

-(void)RunDriver
{
    NSLog(@"出车");
    
    MyMessage *message=[MyMessage instance] ;
    NSString *isOnline=message.isOnline;
    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    
    if([isOnline isEqualToString:@"NO"]){
        _flagOnline=[facade putDriverAttendance];
        [facade addHttpObserver:self tag:_flagOnline];
    }
    else
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        signbackVC *mysignbackVC=[[signbackVC alloc] init];
        [delegate.mainViewNav pushViewController:mysignbackVC animated:YES];
    }
}



-(void)setBtnClicked

{
    if(_mysetView!=nil)
    {
        [self leftBtnClicked];
        _rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
        return;
    }
    _rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
    _backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor=[UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:0.5];
    _backButton.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [_backButton addTarget:self action:@selector(removesetView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    
    _mysetView=[[leftsetview alloc] initWithFrame:CGRectMake(-250, 0, 250, SCREEN_HEIGHT)];
    _mysetView.backgroundColor=[UIColor whiteColor];
    _mysetView.m_delegate=self;
    [_backButton addSubview:_mysetView];
    
    
    _leftSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnClicked)];
    _leftSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
    [_leftSwipGestureRecognizer setNumberOfTouchesRequired:1];
    [_mysetView addGestureRecognizer:_leftSwipGestureRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _mysetView.frame=CGRectMake(0, 0, 250, (SCREEN_HEIGHT));
    } completion:^(BOOL finished){
        if(finished)
            _mysetView.frame=CGRectMake(0, 0, 250, (SCREEN_HEIGHT));
    }];
    
    
    
    
    
}
-(void)removesetView:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _mysetView.frame=CGRectMake(-250, 0, 250, (SCREEN_HEIGHT));
    } completion:^(BOOL finished){
        if(finished)
        {
            _mysetView.frame=CGRectMake(0, 0, 250, (SCREEN_HEIGHT));
            
            UIButton *button=(UIButton *)sender;
            for (UIView *object in button.subviews) {
                if([object isKindOfClass:[leftsetview class]])
                {
                    [object removeFromSuperview];
                }
            }
            [_mysetView removeFromSuperview];
            _mysetView=nil;
            [_backButton removeGestureRecognizer:_leftSwipGestureRecognizer];
            _leftSwipGestureRecognizer=nil;
            [button removeFromSuperview];
            
        }
    }];
}

-(void)removesetView
{
    _rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
    [_mysetView removeFromSuperview];
    _mysetView=nil;
    [_backButton removeFromSuperview];
}
-(void)leftBtnClicked
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _mysetView.frame=CGRectMake(-250, 0, 250, (SCREEN_HEIGHT));
    } completion:^(BOOL finished){
        if(finished)
        {
            _mysetView.frame=CGRectMake(-250, 0, 250, (SCREEN_HEIGHT));
            [_mysetView removeFromSuperview];
            _mysetView=nil;
            [_backButton removeFromSuperview];
            
        }
    }];
}


#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&_flag==iRequestTag)
    {
        _flag=0;
        id value = [response objectForKey:@"data"];
        if([value isKindOfClass:[NSArray class]]){
            for(int i=0;i<[value count];i++)
            {
                NSDictionary *dic=[value objectAtIndex:i];
                [_ordersList addObject:dic];
                [_driverTable reloadData];
                
            }
        }else{
            [_ordersList removeAllObjects];
            [_driverTable reloadData];
            
        }
        
        if([_ordersList count]>0)
        {
            _NotDatalable.hidden = YES;
            
        }else{
            _NotDatalable.hidden = NO;
        }
        
    }
    if(_flagOffline!=0&&_flagOffline==iRequestTag)
    {
        _flagOffline=0;
        MyMessage *message=[MyMessage instance] ;
        message.isOnline=@"NO";
        [_DriverunButton setTitle:@"出车" forState:UIControlStateNormal];
        _DriverunButton.backgroundColor=Assist_COLOR;
    }
    
    if(_flagOnline!=0&&_flagOnline==iRequestTag)
    {
        _flagOnline=0;
        MyMessage *message=[MyMessage instance] ;
        message.isOnline=@"YES";
        [_DriverunButton setTitle:@"收车" forState:UIControlStateNormal];
        _DriverunButton.backgroundColor=Main_COLOR;
    }
    if(_flagreply!=0&&_flagreply==iRequestTag)
    {
        _flagreply=0;
        
    }
    if(_flagInfo!=0&&_flagInfo==iRequestTag)
    {
        
        _ratingBar.hidden=NO;
        _userDic=[response objectForKey:@"data"];
        if(_userDic)
        {
            [self ReLable];
            
            
            MyMessage *mymessage=[MyMessage instance];
            NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:_userDic];
            mymessage.userinfoDic=dic;
            
            
            
        }
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


#pragma ++++++tableView+++++++

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=3;
    intergerNum=[_ordersList count];
    
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"SectionCell";
    DriverCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[DriverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    if([_ordersList count]>0)
    {
        //有订单的情况添加声音
        [self playSound];
        sectionCell.orderdata=[_ordersList objectAtIndex:indexPath.row];
    }
    NSLog(@"===%ld",(long)indexPath.row);
    
    return sectionCell;
}

#pragma mark - 添加声音
static SystemSoundID shake_sound_male_id = 0;

-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"4082" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TransfomXY(176);
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[_ordersList objectAtIndex:indexPath.row];
    NSString *ID=[dic objectForKey:@"id"];
    NSString *type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    DetailsViewController *detailsView=[[DetailsViewController alloc] init];
    detailsView.delegate =self;
    detailsView.orderID=ID;
    detailsView.type = type;
    [delegate.mainViewNav pushViewController:detailsView animated:YES];
    
}



- (void)ratingChanged:(float)newRating
{
    NSLog(@"newRating=%f",newRating);
    
}

#pragma mark -AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1003) return;
    if(buttonIndex == 0)
    {
        ViewOrdersController *detailsView=[[ViewOrdersController alloc] init];
        detailsView.orderID = _paidOrder_id;
        [self.navigationController pushViewController:detailsView animated:YES];
        
    }
}








@end







