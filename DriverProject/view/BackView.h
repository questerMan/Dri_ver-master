//
//  BackView.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//


typedef enum {
    
    StateNOTKnown = 0,
    StateNullOrders,
    StateReceiveOrders,
    Statesetoff,
    
    
    StateGoToArrived,
    StateGoToPickUp,

    
    StateBilling,
    StateEndAndPay


    
}OrdersStates;

#import <UIKit/UIKit.h>

@interface BackView : UIButton


@property(nonatomic,strong)UIView *PopupView;

@property(nonatomic,strong)UILabel *TitleLable;


@property(nonatomic,strong)UILabel *ContentLable;




@property(nonatomic,strong)UIButton *ConfirmButton;
@property(nonatomic,strong)UIButton *CancelButton;

@property(nonatomic,strong) UITextField *TextField;



-(void)showview:(OrdersStates)states;


@end
