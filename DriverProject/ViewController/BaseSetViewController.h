//
//  BaseSetViewController.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSetViewController : CCBBaseViewController


@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UIButton *backButton;

@property(nonatomic,strong)UILabel *backLabel;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UIImageView *backButtonimage;

//-(void)showWarningMessage:(NSString *)message;
-(void)titlelableMiddle;

@end
