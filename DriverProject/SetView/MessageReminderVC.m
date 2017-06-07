//
//  MessageReminderVC.m
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MessageReminderVC.h"
#import "MReminderCell.h"
#import "DBModel.h"
@interface MessageReminderVC ()
{
    NSInteger _flag;
    NSArray   *_messageArray;
}
@end

@implementation MessageReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _flag=0;
    _messageArray = [NSArray new];
    
    
    self.view.backgroundColor=Textlightwhite_COLOR;
    self.backView.backgroundColor=Textwhite_COLOR;
    self.backLabel.text=@"消息通知";
    self.backLabel.textColor=Textblack_COLOR;
    [self.backButton addTarget:self action:@selector(backViewVC) forControlEvents:UIControlEventTouchUpInside];
    self.backButtonimage.image=[UIImage imageNamed:@"common_navbar_return.png"];
    //[self.backButton setBackgroundImage:[UIImage imageNamed:@"common_navbar_return.png"] forState:UIControlStateNormal];
    //[self titlelableMiddle];
    
    
    [self initTableView];
    [self addButton];

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)backViewVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTableView
{
    _MessagedetailTable = ({
        UITableView *  atableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        atableView.delegate = self;
        atableView.dataSource = self;
        atableView.backgroundColor = [UIColor clearColor];
        atableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        atableView.showsVerticalScrollIndicator = NO;
        atableView.showsHorizontalScrollIndicator = NO;
        atableView;
    });
    [self.view addSubview:_MessagedetailTable];
    _MessagedetailTable.frame=CGRectMake(0, CUSTOM_NAV_HEIGHT, self.view.width, self.view.height-CUSTOM_NAV_HEIGHT);
    
}
-(void)addButton
{
    UIButton *removeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    removeButton.frame=CGRectMake(15,self.view.height-50, 45, 30);
    removeButton.backgroundColor=[UIColor clearColor];
    [removeButton setTitle:@"清空" forState:UIControlStateNormal];
    //removeButton.titleLabel.textColor=Textblack_COLOR;
    [removeButton setTitleColor:Textblack_COLOR forState:UIControlStateNormal];
    removeButton.titleLabel.font=[UIFont systemFontOfSize:14];
    removeButton.center=self.backLabel.center;
    removeButton.left=self.view.width-60;
    [removeButton addTarget:self action:@selector(removecontent) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:removeButton];


    _alertViewNotdataView=[[AlertViewNotdataView alloc]initWithFrame:CGRectZero];
    _alertViewNotdataView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_alertViewNotdataView];
    


}
-(void)removecontent
{
    BOOL isSuccess = [DBModel DeleteFromUserListWithUserId:@"3"];
    if(isSuccess)
    {
        NSLog(@"删除成功!");
        _messageArray = nil;
        [_MessagedetailTable reloadData];
    }

}


-(void)viewWillAppear:(BOOL)animated
{
    [self readPushString];
}

-(void)readPushString
{
    NSArray *array = [DBModel GetMessagefromMsgType:@"3" withRecentNum:0];
    if(array)
    {
        _messageArray = array;
        _alertViewNotdataView.frame = CGRectZero;
    }
    else
    {
        _alertViewNotdataView.frame =_MessagedetailTable.frame;
        [_alertViewNotdataView showNotdatdaView:AlertViewNew];
    }
}


#pragma mark  网络请求

-(void)getData
{
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade getDriverOrderListPage:@"1" perPage:@"20"];
    NSLog(@"takeOutMoneyFlag=%ld",(long)_flag);
    [facade addHttpObserver:self tag:_flag];
}


#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum = [_messageArray count];

    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"MRDetailsCell";
    MReminderCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[MReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        sectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSArray *array = [_messageArray objectAtIndex:indexPath.row];
    sectionCell.titleTextlable.text = [array objectAtIndex:3];;
    sectionCell.contentTextlable.text = [array objectAtIndex:1];
    sectionCell.timeTextlable.text=[array objectAtIndex:2];
    
    sectionCell.showSeperateLine=YES;
    
    
    return sectionCell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_messageArray objectAtIndex:indexPath.row];
    NSString *value = [array objectAtIndex:1];
    return [MReminderCell heightFromCell:value];
 
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
        _flag=0;

        
    }
    
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
    }
    
    [self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
}








@end


