//
//  BesaViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BesaViewController : UIViewController

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

/**
 *  在navigation中弹出提示，并于n秒后消失
 *
 *  @param navigationItem self.navigationItem
 *  @param strPrompt      提示语
 *  @param delay          显示时间
 */
- (void)setNavigationItemPrompt:(UINavigationItem *)navigationItem withString:(NSString *)strPrompt andDelay:(NSInteger )delay;

@end
