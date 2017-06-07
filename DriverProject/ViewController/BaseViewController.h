//
//  BaseViewController.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackView.h"


#import "BaseAlertView.h"
#define UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface BaseViewController : UIViewController
@property(nonatomic,strong)BackView *backview;
-(void)ShowView:(OrdersStates)states;

-(void)DismossView;

//-(void)showWarningMessage:(NSString *)message;





- (BOOL)bOKforNetwork;

//- (void)showHUD;
- (void)hideHUD;

//- (void)showHUDwithTitile:(NSString *)title content:(NSString *)content;

//- (void)showHudwithMessage:(NSString *)message;

- (void)showLoadingView;

- (void)hideLoadingView;

//- (void)showBigButtonHudwithMessge:(NSString *)message andButtonTitle:(NSString *)buttonTitle;

//-(void)showBigButtonHudwithErrorCode:(NSString *)code ErrorMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;

-(void)showWarningMessage:(NSString *)message;

-(void)showErrorMessage:(NSString *)message errorCode:(NSString *)errCode;

-(void)showOKMessage:(NSString *)message;



#pragma mark  扩展
/**
 *  仅显示文字提示的HUDView
 *
 *  @param text 3秒自动消失
 */
-(void)showTextOnlyWith:(NSString *)text;
/**
 *  show菊花
 *
 *  @param text 显示的提示语
 */
- (void)showLoadingWithText:(NSString *)text;

/**
 *  菊花消失
 */
- (void)dismissLoading;






@end
