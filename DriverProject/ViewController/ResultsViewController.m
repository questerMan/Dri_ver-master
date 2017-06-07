//
//  ResultsViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=Textwhite_COLOR;
    
    UIView *BackColor=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    BackColor.backgroundColor=Main_COLOR;
    [self.view addSubview:BackColor];
    
    
    
    
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
