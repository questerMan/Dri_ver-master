//
//  DriverScoreVC.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//
#import "MJRefresh.h"
#import "DriverScoreVC.h"
#import "DriverScoreCell.h"
#import "ViewOrdersController.h"

#define BUTTON_WIDTH  96
@interface DriverScoreVC ()

{
    NSInteger _flag;
    NSArray *_driverScoreList;
    NSInteger _monthflag;
    NSInteger _whichMonth;
    NSMutableArray *_monthlist;
    NSInteger _page;
    BOOL _isMore;
    NSString *_monthString;
}
@property(nonatomic,strong)NSString *whichpage;

@end

@implementation DriverScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.backLabel.text=@"司机业绩";
    self.backLabel.textColor=Textwhite_COLOR;
    self.line.backgroundColor=[UIColor clearColor];
    //[self titlelableMiddle];
    _monthString =@"";
    _page =1;
    _isMore=NO;
    _flag=0;
    _monthflag=0;
    _whichMonth=-1;
    
    
    _driverScoreList=[[NSArray alloc]init];
    _monthlist=[[NSMutableArray alloc]init];
    
    [self.backButton addTarget:self action:@selector(BackMainView1) forControlEvents:UIControlEventTouchUpInside];
    
    [self initScoreView];
    _lineView=[[UIView alloc]initWithFrame:CGRectZero];
    [_ScoreView addSubview:_lineView];
    [self initCaseView];
    
    [self initTableView];
    [self addMJRefresh];
    
}
-(void)addMJRefresh
{
    __weak UITableView *tableView = _driverTable;
    
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isMore = NO;
        NSString *pageS=[NSString stringWithFormat:@"%ld",(long)_page];
        [self getDriverScore:pageS];
        // 结束刷新
        [tableView.header endRefreshing];
        [tableView reloadData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
    
    //上拉加载
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(_isMore)
        {
            _page = _page + 1;
            NSString *pageS=[NSString stringWithFormat:@"%ld",(long)_page];
            [self getDriverScore:pageS];
            // 结束刷新
            [tableView.footer endRefreshing];
            [tableView reloadData];
        }
        else
        {
            [tableView.footer endRefreshingWithNoMoreData];
        }
    }];
    
    
    
}
-(void)initScoreView
{
    _ScoreView=[[UIView alloc]initWithFrame:CGRectMake(0,CUSTOM_NAV_HEIGHT,KScreenWidth , CUSTOM_NAV_HEIGHT-20)];
    _ScoreView.backgroundColor=Main_COLOR;
    [self.view addSubview:_ScoreView];
    
}

-(void)addButton
{
    for(int i=0;i<[_driverScoreList count];i++)
    {
        
        NSDictionary *dic=[_driverScoreList objectAtIndex:i];
        NSString *monthSting=[dic objectForKey:@"month"];
        monthSting= [monthSting stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
        monthSting = [monthSting stringByAppendingString:@"月"];
        UIButton* _ScoreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _ScoreButton.frame=CGRectMake(BUTTON_WIDTH*i, 0, BUTTON_WIDTH, CUSTOM_NAV_HEIGHT-20);
        [_ScoreButton setTitle:monthSting forState:UIControlStateNormal];
        [_ScoreButton setTitleColor:Textwhite_COLOR forState:UIControlStateNormal];
        _ScoreButton.titleLabel.font=[UIFont systemFontOfSize:14];
        _ScoreButton.backgroundColor=[UIColor clearColor];
        _ScoreButton.tag=1100+i;
        [_ScoreButton addTarget:self action:@selector(switchmonth:) forControlEvents:UIControlEventTouchUpInside];
        [_ScoreView addSubview:_ScoreButton];
    }
    if([_driverScoreList count]>0){
        [_ScoreView bringSubviewToFront:_lineView];
        _lineView.frame=CGRectMake(BUTTON_WIDTH*([_driverScoreList count]-1), CUSTOM_NAV_HEIGHT-20-2,BUTTON_WIDTH, 2);
        _lineView.backgroundColor=Assist_COLOR;
        
        _whichMonth=([_driverScoreList count]-1);
        
        NSDictionary *dicdata=[_driverScoreList objectAtIndex:_whichMonth];
        NSString *monthString=[dicdata objectForKey:@"month"];
        monthString= [monthString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _monthString = monthString;
        [self getDriverScore:@"1"];
        
        
        
        
    }
}
-(void)getDriverScore:(NSString *)page
{
    
    if([_monthString length]>0)
    {
        if([page isEqualToString:@"1"])
        {
            if(_monthlist==nil)
            {
                _monthlist = [NSMutableArray new];
            }
        }
        
        //请求
        QiFacade*       facade;
        facade=[QiFacade sharedInstance];
        _monthflag=[facade getDriverAccountMonth:_monthString withpage:page];
        [facade addHttpObserver:self tag:_monthflag];
        [self showLoadingWithText:@"加载中..."];
    }
    
}
-(void)initCaseView
{
    
    _alertViewNotdataView=[[AlertViewNotdataView alloc]initWithFrame:CGRectZero];
    _alertViewNotdataView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_alertViewNotdataView];
    
    
    _lable01=[[UILabel alloc]initWithFrame:CGRectMake(10, _ScoreView.bottom+15, self.view.width-20, CUSTOM_NAV_HEIGHT)];
    _lable01.text=@"¥ 0.00";
    _lable01.font=[UIFont boldSystemFontOfSize:TransfomFont(72)];
    _lable01.textAlignment=NSTextAlignmentLeft;
    _lable01.textColor=Assist_COLOR;
    [self.view addSubview:_lable01];
    [_lable01 sizeToFit];
    _lable01.left =20;
    _lable01.size=CGSizeMake(self.view.width-2*20, _lable01.height);
    
    _lable02=[[UILabel alloc]initWithFrame:CGRectMake(32, _lable01.bottom+10, self.view.width-25, CUSTOM_NAV_HEIGHT)];
    _lable02.text=@"完成订单：0单";
    _lable02.font=[UIFont systemFontOfSize:TransfomFont(30)];
    _lable02.textAlignment=NSTextAlignmentLeft;
    _lable02.textColor=Textgray_COLOR;
    [self.view addSubview:_lable02];
    [_lable02 sizeToFit];
    
    _lable03=[[UILabel alloc]initWithFrame:CGRectMake(32, _lable02.bottom+5, self.view.width-25, CUSTOM_NAV_HEIGHT)];
    _lable03.text=@"完成订单：0单";
    _lable03.font=[UIFont systemFontOfSize:TransfomFont(30)];
    _lable03.textAlignment=NSTextAlignmentLeft;
    _lable03.textColor=Textgray_COLOR;
    [self.view addSubview:_lable03];
    [_lable03 sizeToFit];
    
    _lable04=[[UILabel alloc]initWithFrame:CGRectMake(32, _lable03.bottom+5, self.view.width-25, CUSTOM_NAV_HEIGHT)];
    _lable04.text=@"完成订单：0单";
    _lable04.font=[UIFont systemFontOfSize:TransfomFont(30)];
    _lable04.textAlignment=NSTextAlignmentLeft;
    _lable04.textColor=Textgray_COLOR;
    [self.view addSubview:_lable04];
    [_lable04 sizeToFit];
    
    [self changeString:_lable01.text changeLable:_lable01];
}


-(void)initTableView
{
    _driverTable=[[UITableView alloc]initWithFrame:CGRectMake(0, _lable04.bottom+10, self.view.width,  KScreenHeight-_lable04.bottom-15)];
    _driverTable.delegate = self;
    _driverTable.dataSource = self;
    //    _driverTable.layer.borderWidth = LINE_HEIGHT;
    //    _driverTable.layer.borderColor = [Dividingline_COLOR CGColor];
    _driverTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_driverTable];//原
    
    
   UIView *topLineview = [[UIView alloc] initWithFrame:CGRectZero];
    topLineview.backgroundColor = Dividingline_COLOR;
    topLineview.bottom = _driverTable.top;
    topLineview.width = self.view.width;
    topLineview.height = 0.5;
    [self.view addSubview:topLineview];
    
    [self driverScoreRequest];
}

#pragma mark   +++++

-(void)setlableFromDic:(NSDictionary *)driverScore
{
    _lable01.text=[NSString stringWithFormat:@"¥ %@",[driverScore objectForKey:@"fee"]];
    _lable02.text=[NSString stringWithFormat:@" 完成订单：%@单",[driverScore objectForKey:@"num"]];
    _lable03.text=[NSString stringWithFormat:@" 有效里程：%@公里",[driverScore objectForKey:@"km"]];
    _lable04.text=[NSString stringWithFormat:@" 服务里程：%@公里",[driverScore objectForKey:@"km2"]];
    [_lable02 sizeToFit];
    [_lable03 sizeToFit];
    [_lable04 sizeToFit];
    //[_lable01 sizeToFit];
    [self changeString:_lable01.text changeLable:_lable01];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self addMJRefresh];
}

-(void)driverScoreRequest
{
    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade getDriverAccount];
    [facade addHttpObserver:self tag:_flag];
    [self showLoadingWithText:@"加载中..."];
    
}

-(void)BackMainView1
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)switchmonth:(id)sender
{
    UIButton *button;
    if([sender isKindOfClass:[UIButton class]])
    {
        button =(UIButton *)sender;
    }
    
    NSInteger Number=(button.tag-1100);
    if(_whichMonth==Number) return;
    _whichMonth=Number;
    
    NSDictionary *dicdata=[_driverScoreList objectAtIndex:Number];
    NSString *monthString=[dicdata objectForKey:@"month"];
    monthString= [monthString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _monthString = monthString;
    [self setlableFromDic:dicdata];
    
    _lable01.left=20; _lable01.top =_ScoreView.bottom+15;
    
    _lable02.left=_lable01.left+22;_lable02.top=_lable01.bottom+5;
    _lable03.left=_lable02.left;_lable03.top=_lable02.bottom+5;
    _lable04.left=_lable02.left;_lable04.top=_lable03.bottom+5;
    
    

    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _monthflag=[facade getDriverAccountMonth:monthString withpage:@"1"];
    [facade addHttpObserver:self tag:_monthflag];
    [self showLoadingWithText:@"加载中..."];
    
    //改变button的底色
    [self changButtonColor:Number];
}

-(void)changButtonColor:(NSInteger )Number
{
    
    
    _lineView.frame=CGRectMake(BUTTON_WIDTH*Number, CUSTOM_NAV_HEIGHT-20-2,BUTTON_WIDTH, 2);
    /*
     for(int i=0;i<[_driverScoreList count];i++)
     {
     UIView *view=[_ScoreView viewWithTag:Number];
     if([view isKindOfClass:[UIButton class]])
     {
     UIButton *button=(UIButton *)view;
     UIView *view02=[button viewWithTag:(Number+100)];
     if(i==(Number-1000))
     {
     view02.backgroundColor=Assist_COLOR;
     }
     else
     {
     view02.backgroundColor=[UIColor clearColor];
     }
     
     }
     
     }
     
     */
}

#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=0;
    
    intergerNum=[_monthlist count];
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"DriverScoreCell";
    DriverScoreCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[DriverScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.showTopSeperateLine=NO;
    sectionCell.contentDic=[_monthlist objectAtIndex:indexPath.row];
    NSLog(@"===%ld",(long)indexPath.row);
//    if(indexPath.row==0)
//    {
//        sectionCell.showTopSeperateLine=YES;
//    }
    
    return sectionCell;
    
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
    NSDictionary *orderDetailDic=[_monthlist objectAtIndex:indexPath.row];
    NSString *ID=[orderDetailDic objectForKey:@"id"];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewOrdersController *viewOrdersController=[[ViewOrdersController alloc] init];
    viewOrdersController.orderID=ID;
    [delegate.mainViewNav pushViewController:viewOrdersController animated:YES];
    
}

#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&_flag==iRequestTag)
    {
        _flag=0;
        id Value=[response objectForKey:@"data"];
        if([Value isKindOfClass:[NSArray class]])
        {
            _driverScoreList=(NSArray *)Value;
            if([_driverScoreList count]>0)
            {
                _alertViewNotdataView.frame=CGRectZero;
                [_alertViewNotdataView hideNotdataView];
                
                NSDictionary *driverScore=[_driverScoreList lastObject];
                [self setlableFromDic:driverScore];

                [self addButton];
            }
            else
            {
                //没数据
                _alertViewNotdataView.frame=CGRectMake(0, CUSTOM_NAV_HEIGHT, self.view.width, self.view.height-_ScoreView.bottom);
                [_alertViewNotdataView showNotdatdaView:AlertViewScore];
                [self.view bringSubviewToFront:_alertViewNotdataView];
            }
            
        }
        else
        {
            //没数据
            _alertViewNotdataView.frame=CGRectMake(0, CUSTOM_NAV_HEIGHT, self.view.width, self.view.height-_ScoreView.bottom);
            [_alertViewNotdataView showNotdatdaView:AlertViewScore];
            [self.view bringSubviewToFront:_alertViewNotdataView];
            
        }
        
    }
    
    if(_monthflag!=0&&response!=nil&&_monthflag==iRequestTag)
    {
        _monthflag=0;
        NSDictionary *dataDic=[response objectForKey:@"data"];
        NSInteger page_count=[[dataDic objectForKey:@"page_count"] integerValue];//总页数
        NSInteger page =[[dataDic objectForKey:@"page"] integerValue];
        if(page_count>page)
        {
            _isMore =YES;
        }
        else
        {
            _isMore = NO;
        }
        _page =page;
        NSArray *contentArray=[dataDic objectForKey:@"content"];
        if(page==1)
        {
            _monthlist=[NSMutableArray arrayWithArray:contentArray];
        }
        else
        {
            [_monthlist addObjectsFromArray:_monthlist];
        }
        // NSLog(@"_monthlist==%@",_monthlist);
        if([_monthlist count]>0)
        {
            [_driverTable reloadData];
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
    
    [self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
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
        
        NSLog(@"NSStringFromRange01==%@",NSStringFromRange(range01));
        
        NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",LastString]];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:TransfomFont(32)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(0, 1)];
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:TransfomFont(25)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(1, 1)];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName: [UIFont systemFontOfSize:TransfomFont(56)],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(2, [LastString length]-2)];
        
        Lable.attributedText = dateString;
    }
}



@end
