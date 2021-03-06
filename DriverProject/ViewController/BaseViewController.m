//
//  BaseViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface BaseViewController ()
{
    UIAlertView *hudAlert;
    BaseAlertView *loadingAlert;
}
@property (nonatomic, strong) MBProgressHUD *HUDView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_backview addTarget:self action:@selector(DismossView) forControlEvents:UIControlEventTouchUpInside];
    [_backview.CancelButton addTarget:self action:@selector(DismossView) forControlEvents:UIControlEventTouchUpInside];
    
    

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark   私有方法
-(void)ShowView:(OrdersStates)states
{
    [_backview showview:states];
    [self.view addSubview:_backview];


}

-(void)DismossView
{

    [_backview removeFromSuperview];
}

#pragma mark   提示

//- (void)dealloc
//{
//    [hudAlert release];
//    [loadingAlert release];
//    [super dealloc];
//}

//- (void)showHUD
//{
//    if (hudAlert == nil) {
//        hudAlert = [[UIAlertView alloc] initWithTitle:nil
//                                             message: @"正在加载中"
//                                            delegate: self
//                                   cancelButtonTitle: nil
//                                   otherButtonTitles: nil];
//
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityView.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
//        [hudAlert addSubview:activityView];
//        [activityView startAnimating];
//        [hudAlert show];
//    }
//}

- (void)hideHUD
{
    if (hudAlert) {
        [hudAlert dismissWithClickedButtonIndex:0 animated:YES];
        //[hudAlert release];
        hudAlert = nil;
    }
}

//- (void)showHUDwithTitile:(NSString *)title content:(NSString *)content
//{
//    if (hudAlert == nil) {
//        hudAlert = [[UIAlertView alloc] initWithTitle:title
//                                              message: content
//                                             delegate: self
//                                    cancelButtonTitle: nil
//                                    otherButtonTitles: nil];
//
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        activityView.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
//        [hudAlert addSubview:activityView];
//        [activityView startAnimating];
//        [hudAlert show];
//    }
//}

-(void)showWarningMessage:(NSString *)message{
    /*
    NSArray *BtnTitleArr = @[@"确定"];
    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewWarn];
    [alert show];
    //[alert release];
     */
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

-(void)showErrorMessage:(NSString *)message errorCode:(NSString *)errCode{
    NSArray *BtnTitleArr = @[@"确定"];
    NSString* errStr;
    if (errCode) {
        errStr=[NSString stringWithFormat:@"错误代码：%@",errCode];
    }else{
        errStr=nil;
    }
    BaseAlertView *alert = [[BaseAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewError errorCode:errStr];
    [alert show];
    //[alert release];
}

-(void)showOKMessage:(NSString *)message{
    NSArray *BtnTitleArr = @[@"确定"];
    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewOK];
    [alert show];
   // [alert release];
}

//-(void)showHudwithMessage:(NSString *)message{
//    NSArray *BtnTitleArr = @[@"取消",@"确定"];
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert show];
//    [alert release];
//
//}
//
//-(void)showBigButtonHudwithMessge:(NSString *)message andButtonTitle:(NSString *)buttonTitle{
//    NSArray *BtnTitleArr = @[buttonTitle];
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message] btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert show];
//    [alert release];
//}
//
//-(void)showBigButtonHudwithErrorCode:(NSString *)code ErrorMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle{
//    NSArray *BtnTitleArr = @[buttonTitle];
//    NSString *alertStr;
//    if ([message length]>0) {
//        alertStr= [NSString stringWithFormat:@"%@\n%@",code,message];
//    }else{
//        alertStr=[NSString stringWithFormat:@"%@!",code];
//    }
//    BaseAlertView *alert = [[BaseAlertView alloc]initWithTitle:nil message:alertStr btnTitleArray:BtnTitleArr alertType:BaseAlertViewDefault];
//    [alert setMessageLabelTextAlignment:NSTextAlignmentCenter];
//    [alert show];
//    [alert release];
//}

-(void)showLoadingView{
    if (loadingAlert==nil) {
        loadingAlert=[[BaseAlertView alloc] initWithTitle:nil message:@"" btnTitleArray:nil alertType:BaseAlertViewLoading];
    }
    [loadingAlert show];
}

-(void)hideLoadingView{
    if (loadingAlert) {
        [loadingAlert hideLoading];
        //[loadingAlert release];
        loadingAlert=nil;
    }
}
- (BOOL)bOKforNetwork
{
    return YES;
}


#pragma mark  扩展

- (MBProgressHUD *)HUDView{
    if (!_HUDView) {
        _HUDView = [[MBProgressHUD alloc]initWithView:self.view];
    }
    return _HUDView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window addSubview:self.HUDView];
}


-(void)showTextOnlyWith:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

- (void)showLoadingWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUDView.labelText = text;
        [self.HUDView show:YES];
    });
}

- (void)dismissLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUDView hide:YES];
    });
}







@end
