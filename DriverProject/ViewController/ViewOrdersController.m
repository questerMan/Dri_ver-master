//
//  ViewOrdersController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ViewOrdersController.h"

#import "ViewOrdersCell.h"
#import "CheckViewDetailVC.h"


@interface ViewOrdersController ()
{
    NSInteger _flag;
    NSDictionary *_OrdersDic;

}
@end

@implementation ViewOrdersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flag=0;
    _OrdersDic=[[NSDictionary alloc]init];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initNavigation];
    
    [self SummaryView];
    
    [self initTableView];

    if (IOS7_OR_LATER) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    [self OrdersRequest];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated
{

}

-(void)OrdersRequest
{
    if(_orderID!=nil){
        QiFacade*       facade;
        facade=[QiFacade sharedInstance];
        _flag=[facade getDriverOrderDetailsID:_orderID];
        [facade addHttpObserver:self tag:_flag];
        
        [self showLoadingWithText:@""];
    }
    
}


#pragma mark   init
-(void)initNavigation
{
    
    _NavigationBackView=[[UIView alloc]initWithFrame:CGRectZero];
    _NavigationBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_NavigationBackView];
    
    _BackButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    _BackButton2.frame=CGRectZero;
    _BackButton2.backgroundColor=[UIColor clearColor];
    [_BackButton2 addTarget:self action:@selector(BackMainView) forControlEvents:UIControlEventTouchUpInside];
    [_BackButton2 setBackgroundImage:[UIImage imageNamed:@"common_navbar_return.png"] forState:UIControlStateNormal];
    [self.view addSubview:_BackButton2];
    
    
    _BackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _BackButton.frame=CGRectZero;
    _BackButton.backgroundColor=[UIColor clearColor];
    [_BackButton addTarget:self action:@selector(BackMainView) forControlEvents:UIControlEventTouchUpInside];
    //[_BackButton setBackgroundImage:[UIImage imageNamed:@"common_navbar_return.png"] forState:UIControlStateNormal];
    [self.view addSubview:_BackButton];

    
    _ViewOrdersLable=[[UILabel alloc]initWithFrame:CGRectZero];
    _ViewOrdersLable.text=@"查看订单";
    _ViewOrdersLable.textColor=Textblack_COLOR;
    _ViewOrdersLable.font=[UIFont boldSystemFontOfSize:16];
    _ViewOrdersLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_ViewOrdersLable];
    
    _ViewDetailedLable=[[UILabel alloc]initWithFrame:CGRectZero];
    _ViewDetailedLable.text=@"查看明细";
    _ViewDetailedLable.textColor=Textblack_COLOR;
    _ViewDetailedLable.font=[UIFont systemFontOfSize:14];
    _ViewDetailedLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_ViewDetailedLable];
    

    _ViewDetailed=[UIButton buttonWithType:UIButtonTypeCustom];
    _ViewDetailed.frame=CGRectZero;
    _ViewDetailed.backgroundColor=[UIColor clearColor];
    [_ViewDetailed setTitleColor:Textwhite_COLOR forState:UIControlStateNormal];
    [_ViewDetailed addTarget:self action:@selector(GoToDetailView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ViewDetailed];
    


    
    [self NavigationLayout];
}
-(void)NavigationLayout
{
    
    CGFloat spcing=20;
    if(IOS7_OR_LATER)
    {
        spcing=25;
    }
    
    [_NavigationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
       // make.height.equalTo(self.view.mas_height).multipliedBy(0.1f);
        make.height.equalTo(@60);
    }];
    
    [_BackButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(13);
        make.top.equalTo(_NavigationBackView.mas_top).with.offset(spcing+5);
        make.height.equalTo(@19);
        make.width.equalTo(@11.5);
        
        
    }];
    
    
    
    
    [_BackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(13);
        make.top.equalTo(_NavigationBackView.mas_top).with.offset(spcing);
        make.height.equalTo(_NavigationBackView.mas_height).multipliedBy(0.5);
        make.width.equalTo(_NavigationBackView.mas_height).multipliedBy(0.5);
        
        
    }];
    
    [_ViewOrdersLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_NavigationBackView.mas_centerX);
        make.centerY.equalTo(_BackButton.mas_centerY);
        make.height.equalTo(_BackButton.mas_height);
        make.width.equalTo(_BackButton.mas_height).multipliedBy(3);
        
    }];
    
    [_ViewDetailedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_NavigationBackView.mas_right).with.offset(-10);
        make.centerY.equalTo(_ViewOrdersLable.mas_centerY).with.offset(-2);;
        make.height.equalTo(_BackButton.mas_height);
        make.width.equalTo(_BackButton.mas_height).multipliedBy(2);
        
    }];
    
    [_ViewDetailed mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(_ViewDetailedLable.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(_NavigationBackView.mas_bottom);
        
    
    }];
    
    
//    [_BackButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.view.mas_left).with.offset(13);
//        make.top.equalTo(_NavigationBackView.mas_top).with.offset(spcing);
//        make.height.equalTo(@11.5);
//        make.width.equalTo(@15);
//        
//        
//    }];
    
    
    
    
    if(IOS7_OR_LATER)
    {
//        _BackButton.center=CGPointMake(CUSTOM_NAV_HEIGHT/2, 20+(CUSTOM_NAV_HEIGHT-20)/2);
//        _ViewOrdersLable.center=CGPointMake(_BackButton.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
//        _ViewDetailedLable.center=CGPointMake(_ViewDetailedLable.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
    }

}


-(void)SummaryView
{
    _SummaryLable01=[[UILabel alloc]initWithFrame:CGRectZero];
    _SummaryLable01.text=@"";
    _SummaryLable01.textColor=Assist_COLOR;
    _SummaryLable01.font=[UIFont boldSystemFontOfSize:27];
    _SummaryLable01.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_SummaryLable01];
    
    _SummaryLable02=[[UILabel alloc]initWithFrame:CGRectZero];
    _SummaryLable02.text=@"";
    _SummaryLable02.textColor=Textgray_COLOR;
    _SummaryLable02.font=[UIFont systemFontOfSize:15];
    _SummaryLable02.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_SummaryLable02];
    
    _SummaryLable03=[[UILabel alloc]initWithFrame:CGRectZero];
    _SummaryLable03.text=@"支付方式:现金";
    _SummaryLable03.textColor=Textgray_COLOR;
    _SummaryLable03.font=[UIFont systemFontOfSize:15];
    _SummaryLable03.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_SummaryLable03];
    
    _SummaryLable04=[[UILabel alloc]initWithFrame:CGRectZero];
    _SummaryLable04.text=@" (已索取手撕发票)";
    _SummaryLable04.textColor=Assist_COLOR;
    _SummaryLable04.font=[UIFont systemFontOfSize:15];
    _SummaryLable04.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_SummaryLable04];

    [self SummaryLayout];
    
    
    [self changeString:_SummaryLable01.text changeLable:_SummaryLable01];

}

-(void)SummaryLayout
{
    [_SummaryLable01 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(_NavigationBackView.mas_bottom).with.offset(15);
        make.height.equalTo(_NavigationBackView.mas_height).multipliedBy(0.5);
        make.width.equalTo(_ViewOrdersLable.mas_width).multipliedBy(2);
        
    }];
    [_SummaryLable02 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_SummaryLable01.mas_left).with.offset(10);
        make.top.equalTo(_SummaryLable01.mas_bottom).with.offset(5);
        make.height.equalTo(_SummaryLable01.mas_height).multipliedBy(0.5);
        make.width.equalTo(_SummaryLable01.mas_width).multipliedBy(1.5);
        
    }];
    [_SummaryLable03 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_SummaryLable02.mas_left);
        make.top.equalTo(_SummaryLable02.mas_bottom).with.offset(5);
        make.height.equalTo(_SummaryLable02.mas_height);
        make.width.equalTo(_SummaryLable02.mas_width);
        
    }];
    
    [_SummaryLable04 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_SummaryLable03.mas_left);
        make.top.equalTo(_SummaryLable03.mas_bottom).with.offset(5);
        make.height.equalTo(_SummaryLable03.mas_height);
        make.width.equalTo(_SummaryLable03.mas_width);
        
    }];


}


-(void)initTableView
{

    _DetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _DetailsTableView.delegate = self;
    _DetailsTableView.dataSource = self;
    _DetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_DetailsTableView];//原
    _DetailsTableView.scrollEnabled =NO; //设置tableview 不能滚动
    
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, _NavigationBackView.bottom, _NavigationBackView.width, 5)];
    _line.backgroundColor=Dividingline_COLOR;
    [self.view addSubview:_line];
    
    

    [self tableLayout:20];
    [self lineLayout];
}
-(void)tableLayout:(NSInteger)offset
{
    [_DetailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_SummaryLable04.mas_bottom).with.offset(offset);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
}
-(void)lineLayout
{
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_NavigationBackView.mas_bottom).with.offset(0);
        make.height.equalTo(@0.5);
        
    }];

}


#pragma mark  私有方法

-(void)BackMainView
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GoToDetailView
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    CheckViewDetailVC *checkViewDetailVC=[[CheckViewDetailVC alloc] init];
    checkViewDetailVC.orderID=_orderID;
    [delegate.mainViewNav pushViewController:checkViewDetailVC animated:YES];
}




#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=5;
    NSString *type=[NSString stringWithFormat:@"%@",[_OrdersDic objectForKey:@"type"]];
    if([type isEqualToString:@"3"])
    {
        intergerNum=6;
    }
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"ViewOrdersCell";
    ViewOrdersCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[ViewOrdersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    NSLog(@"===%ld",(long)indexPath.row);
    NSInteger Row=(NSInteger)indexPath.row;
      sectionCell.ratingBar.hidden=NO;
    
    sectionCell.showSeperateLine=YES;
    sectionCell.showTopSeperateLine=NO;
    sectionCell.isIndentationWidth=YES;
    sectionCell.isfristCell=NO;
    switch (Row) {
        case 0:
        {
            sectionCell.showTopSeperateLine=YES;
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_chat_darkgray_24dp.png"];
//            sectionCell.setlable.numberOfLines=2;
//            sectionCell.setlable.text=@"评论内容评论内容评论内容评论内容评论内容评论内容评论内容";
            NSString* comment = [NSString stringWithFormat:@"%@", [_OrdersDic objectForKey:@"comment"]];
            if([comment isEqualToString:@"1"])
            {
                
                NSDictionary *comment_body = [_OrdersDic objectForKey:@"comment_body"];
                sectionCell.setlable.text= [comment_body objectForKey:@"content"];
                
                sectionCell.ratingBar.hidden=NO;
#warning 下面这行我注释了，是因为评价的星星没有正常显示。（另外：评论的代码段改过，是因为之前没有显示评论，别你写死了）
                [sectionCell.ratingBar displayRating:(int)[comment_body objectForKey:@"star"]];
            }
            else
            {
                //sectionCell.isfristCell=YES;
                sectionCell.setlable.text=@"未评论";
                sectionCell.ratingBar.hidden=YES;
            }
            
            break;
        }
        case 1:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_access_time_darkgray_24dp.png"];
            sectionCell.setlable.numberOfLines=1;
           // sectionCell.setlable.text=@"9月14日 06-09";
             NSString *fulltime=[_OrdersDic objectForKey:@"fulltime"];
             sectionCell.setlable.text=fulltime;
            break;
        }
        case 2:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_place_green_24dp.png"];
            sectionCell.setlable.numberOfLines=1;
            //sectionCell.setlable.text=@"芳村地铁";
            NSDictionary *origindic=[_OrdersDic objectForKey:@"origin"];
            NSString *startpoint=[origindic objectForKey:@"name"];
            sectionCell.setlable.text=startpoint;
            break;
        }
        case 3:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_pin_drop_orange_24dp.png"];
            sectionCell.setlable.numberOfLines=1;
            //sectionCell.setlable.text=@"白云机场";
            NSDictionary *origindic=[_OrdersDic objectForKey:@"dest"];
            NSString *finishpoint=[origindic objectForKey:@"name"];
            sectionCell.setlable.text=finishpoint;
            
            break;
        }
        case 4:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_call_darkgray_24dp.png"];
            sectionCell.setlable.numberOfLines=1;
            //sectionCell.setlable.text=@"陈先生:12377756472";
            NSDictionary *passengerdic=[_OrdersDic objectForKey:@"passenger"];
            NSString *name=[passengerdic objectForKey:@"name"];
             NSString *phone=[passengerdic objectForKey:@"phone"];
            sectionCell.setlable.text=[NSString stringWithFormat:@"%@  %@",name,phone];
            
            
            break;
        }
        case 5:
        {
            sectionCell.setimage.image=[UIImage imageNamed:@"ic_flight_darkgray_24dp.png"];
            sectionCell.setlable.numberOfLines=1;
            //sectionCell.setlable.text=@""; //@"航班号: CZ3801";
            NSDictionary *flightDic=[_OrdersDic objectForKey:@"flight"];
            NSString *type=[NSString stringWithFormat:@"%@",[_OrdersDic objectForKey:@"type"]];
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
    
    NSString *type=[NSString stringWithFormat:@"%@",[_OrdersDic objectForKey:@"type"]];
    if([type isEqualToString:@"3"])
    {
        if(indexPath.row==0||(indexPath.row==5))
        {
            sectionCell.isIndentationWidth=NO;
        }
    }
    else
    {
       if(indexPath.row==0||(indexPath.row==4))
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
    return CellHeight;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
        _flag=0;
        _OrdersDic=response;
        
        _SummaryLable01.text=[NSString stringWithFormat:@"¥ %@",[[_OrdersDic objectForKey:@"fee"]stringValue]];
        _SummaryLable02.text=[NSString stringWithFormat:@" 里程/用时：%@公里/%@分钟",[[_OrdersDic objectForKey:@"km"]stringValue ],[[_OrdersDic objectForKey:@"minutes"]stringValue]];
        
        _SummaryLable03.text=[NSString stringWithFormat:@" 支付方式：%@",[_OrdersDic objectForKey:@"payment"]];
        

        NSString* invoice = [NSString stringWithFormat:@"%@", [_OrdersDic objectForKey:@"invoice"]];
        _SummaryLable04.hidden = [invoice isEqualToString:@"0"];
        if([invoice isEqualToString:@"0"])
        {
                [self tableLayout:0];
        }else{
                [self tableLayout:20];
        }

        [self changeString:_SummaryLable01.text changeLable:_SummaryLable01];
        [_DetailsTableView reloadData];
        
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
    
    //[self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
}
//type  1即使单  2预约用车  3 预约接机  4预约送机
/*
{
    canceld = 0;
    comment = 0;
    dest =     {
        address = "\U73af\U5e02\U897f\U8def159\U53f7";
        lat = "23.148708";
        lon = "113.257491";
        name = "\U5e7f\U5dde\U7ad9";
    };
    fee = 12;
    fulltime = "2015-10-03 08:50:00";
    invoice = 0;
    km = 0;
    minutes = 9;
    "order_id" = 255;
    origin =     {
        address = "\U4e2d\U5c71\U5927\U9053\U4e2d\U8def995\U53f7";
        lat = "23.119884";
        lon = "113.412463";
        name = "\U6c47\U6fb3\U9152\U5e97";
    };
    passenger =     {
        name = 15920353771;
        phone = 15920353771;
    };
    payment = "\U73b0\U91d1\U652f\U4ed8";
    status = 6;
    time = "\U4eca\U5929 08:50";
    type = 2;
}

*/


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
                                    NSFontAttributeName:[UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(0, 1)];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName: [UIFont systemFontOfSize:27],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(1, [LastString length]-1)];
        
        Lable.attributedText = dateString;
    }
}







@end
