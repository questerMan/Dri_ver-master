//
//  SetViewController.m
//  DriverProject
//
//  Created by zyx on 15/9/24.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "OfflineDetailViewController.h"
#import "MyMessage.h"
#define  LEFT_SPACING   20
#define  RINGT_SPACING   20


@interface SetViewController ()<UIAlertViewDelegate>
{
    NSInteger _flag;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor=Textlightwhite_COLOR;
    self.backView.backgroundColor=Textwhite_COLOR;
    self.backLabel.text=@"设置";
    self.backLabel.textColor=Textblack_COLOR;
    self.backLabel.left+=20;
    [self.backButton addTarget:self action:@selector(backViewVC) forControlEvents:UIControlEventTouchUpInside];
    self.backButtonimage.image=[UIImage imageNamed:@"common_navbar_return.png"];
    //[self.backButton setBackgroundImage:[UIImage imageNamed:@"common_navbar_return.png"] forState:UIControlStateNormal];
    self.backLabel.text=_titlestring;
    
    
    
    _flag=0;
    
    UIImageView *setTitleImgae=[[UIImageView alloc]init];
    setTitleImgae.image=[UIImage imageNamed:@"ic_settitleImage.png"];
    setTitleImgae.size=CGSizeMake(113, 31);
    setTitleImgae.center=CGPointMake(self.view.width/2, CUSTOM_NAV_HEIGHT+50);
    [self.view addSubview:setTitleImgae];
    
    [self initTableView];
    
//    UISwipeGestureRecognizer *rightSwipGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backViewVC)];
//    rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
//    [rightSwipGestureRecognizer setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:rightSwipGestureRecognizer];
    
    
}
-(void)backViewVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTableView
{
    _SetTable = ({
        UITableView *  atableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        atableView.delegate = self;
        atableView.dataSource = self;
        atableView.backgroundColor = [UIColor clearColor];
        atableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        atableView.showsVerticalScrollIndicator = NO;
        atableView.showsHorizontalScrollIndicator = NO;
        atableView;
    });
    [self.view addSubview:_SetTable];
    _SetTable.scrollEnabled = NO;
    _SetTable.frame=CGRectMake(0,CUSTOM_NAV_HEIGHT+100 , self.view.width, self.view.height-(CUSTOM_NAV_HEIGHT+50));
    
    

    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(LEFT_SPACING, SCREEN_HEIGHT-60, self.view.width-2*LEFT_SPACING, 44.0f)];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:Textblack_COLOR forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(BtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    loginBtn.backgroundColor=[UIColor whiteColor];
    loginBtn.layer.cornerRadius=5;
    loginBtn.layer.borderWidth = 0.5;
    loginBtn.layer.borderColor = [Dividingline_COLOR CGColor];
    
//    UIImage *loginBg=[UIImage imageNamed:@"button_ok_yellow.png"];
//    loginBg=[loginBg stretchableImageWithLeftCapWidth:(loginBg.size.width*0.5f) topCapHeight:(loginBg.size.height*0.5f)];
//    [loginBtn setBackgroundImage:loginBg forState:UIControlStateNormal];


}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)BtnPressed
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"退出当前账户？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];

    NSLog(@"按下退出按钮");
    
//    NSArray *BtnTitleArr = @[@"确定",@"取消"];
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:@"退出当前账户？" btnTitleArray:BtnTitleArr alertType:BaseAlertViewWarn];
//    [alert setCallbackBlock:^(NSInteger buttonIndex)
//     {
//         switch (buttonIndex) {
//             case 1:
//             {
//
//                 QiFacade*       facade;
//                 facade=[QiFacade sharedInstance];
//                 _flag=[facade deleteDriverSignOut];
//                 [facade addHttpObserver:self tag:_flag];
//                 
//                 NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
//                 [userDefaults removeObjectForKey:@"APP_UUID"];
//                 [userDefaults removeObjectForKey:@"APP_TOKEN"];
//                 [userDefaults synchronize];
//             }
//                 break;
//             case 2:
//             {
//                 
//                 
//             }break;
//     
//             default:
//                 break;
//         }
//     }];
//    
//    [alert show];



}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            QiFacade*       facade;
            facade=[QiFacade sharedInstance];
            _flag=[facade deleteDriverSignOut];
            [facade addHttpObserver:self tag:_flag];
            
            NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"APP_UUID"];
            [userDefaults removeObjectForKey:@"APP_TOKEN"];
            [userDefaults synchronize];
            
            
            break;
        }
        case 1:
        {
            break;
        }
            
        default:
            break;
    }




}


#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum = 2;
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"SetViewCell";
    SetCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[SetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    sectionCell.isIndentationWidth=YES;
    if(indexPath.row==0)
    {
        sectionCell.showTopSeperateLine=YES;
        sectionCell.setimage.image=[UIImage imageNamed:@"ic_offlinemap_darkgray.png"];
        sectionCell.setlable.text=@"离线地图";
    }
    if(indexPath.row==1)
    {
        sectionCell.setimage.image=[UIImage imageNamed:@"ic_loop_darkgray.png"];
        sectionCell.setlable.text= [NSString stringWithFormat:@"当前版本:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    
    //最后一行不缩进
    if(indexPath.row==1)
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
    if(indexPath.row==0)
    {
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        OfflineDetailViewController *ViewVc=[[OfflineDetailViewController alloc] init];
        [delegate.mainViewNav pushViewController:ViewVc animated:YES];
    }
}


#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
        _flag=0;

        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate StopSocket];
        [delegate stopAllPositingTimer];
        [self.navigationController popViewControllerAnimated:NO];
        [delegate showLoginView];
        
        MyMessage *mymessage=[MyMessage instance];
        mymessage.isOnline = @"NO";
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


