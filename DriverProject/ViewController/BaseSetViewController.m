//
//  BaseSetViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"





@interface BaseSetViewController ()

@end

@implementation BaseSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth , CUSTOM_NAV_HEIGHT)];
    _backView.backgroundColor=Main_COLOR;
    [self.view addSubview:_backView];
    
    _backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor=[UIColor clearColor];
    //_backButton.center=CGPointMake(CUSTOM_NAV_HEIGHT/2, CUSTOM_NAV_HEIGHT/2);
    
    _backLabel=[[UILabel alloc]init];
    _backLabel.textColor=[UIColor whiteColor];
    _backLabel.text=@"司机业绩";
    [_backLabel sizeToFit];
    _backButton.left=15;
    _backLabel.font=[UIFont boldSystemFontOfSize:16];
    _backLabel.center=CGPointMake(_backView.center.x, CUSTOM_NAV_HEIGHT/2);
    [_backView addSubview:_backLabel];
    
    _backButtonimage=[[UIImageView alloc]initWithFrame:_backButton.frame];
    _backButtonimage.image=[UIImage imageNamed:@"common_navbar_returnw.png"];
    
    
    
    
    if(IOS7_OR_LATER)
    {
        _backButtonimage.center=CGPointMake(_backView.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
        _backLabel.center=CGPointMake(_backView.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
        _backButtonimage.left=15;
    }
    
    _backButtonimage.size=CGSizeMake(11.5, 19);
    _backButtonimage.left=13;
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, _backView.bottom-LINE_HEIGHT, _backView.width, LINE_HEIGHT)];
    _line.backgroundColor=Dividingline_COLOR;
    [_backView addSubview:_line];
    [self setlayoutSubviews];
    
    
    
    
    [_backView addSubview:_backButtonimage];
    
    _backButton.size=CGSizeMake(70, _backView.height);
    _backButton.center=_backButtonimage.center;
    
    [_backView addSubview:_backButton];
    
}
- (void)setlayoutSubviews
{
    [_backLabel sizeToFit];
    _backButtonimage.left=13;
    // _backLabel.center=CGPointMake(_backButton.right+15, CUSTOM_NAV_HEIGHT/2);
    _backLabel.center=CGPointMake(_backView.center.x, CUSTOM_NAV_HEIGHT/2);
    [_backView addSubview:_backLabel];
    
    if(IOS7_OR_LATER)
    {
        _backButtonimage.center=CGPointMake(_backView.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
        _backLabel.center=CGPointMake(_backView.center.x, 20+(CUSTOM_NAV_HEIGHT-20)/2);
        _backButtonimage.left=15;
    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)titlelableMiddle
{
    [_backLabel sizeToFit];
    _backLabel.center=CGPointMake(_backView.center.x,  _backLabel.center.y);

}


//-(void)showWarningMessage:(NSString *)message{
//    NSArray *BtnTitleArr = @[@"确定"];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message]  delegate:nil cancelButtonTitle:[BtnTitleArr objectAtIndex:0] otherButtonTitles:nil, nil];
//    [alert show];
//    
//    
//}







@end
