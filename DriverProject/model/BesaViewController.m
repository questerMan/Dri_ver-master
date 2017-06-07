//
//  BesaViewController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface BesaViewController ()
@property (nonatomic, strong) MBProgressHUD *HUDView;

@end

@implementation BesaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setNavigationItemPrompt:(UINavigationItem *)navigationItem withString:(NSString *)strPrompt andDelay:(NSInteger )delay
{
    navigationItem.prompt = strPrompt;
    [self performSelector:@selector(removePromptfromNavigationItem:) withObject:navigationItem afterDelay:delay];
}

- (void)removePromptfromNavigationItem:(UINavigationItem *)navItem
{
    navItem.prompt = nil;
}

@end
