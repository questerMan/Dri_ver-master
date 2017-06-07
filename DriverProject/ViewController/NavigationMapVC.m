//
//  NavigationMapVC.m
//  DriverProject
//
//  Created by lixin on 17/3/29.
//  Copyright © 2017年 广州市优玩科技有限公司. All rights reserved.
//

#import "NavigationMapVC.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "APIKey.h"
@interface NavigationMapVC ()<AMapNaviViewControllerDelegate,AMapNaviManagerDelegate>

@property (nonatomic, strong) AMapNaviViewController *naviViewController;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@end

@implementation NavigationMapVC


- (void)initNaviViewController
{
    if (_naviViewController == nil)
    {
        _naviViewController = [[AMapNaviViewController alloc] initWithMapView:nil delegate:self];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNaviManager];
    [self initNaviViewController];
    
}

// 初始化导航管理对象
- (void)initNaviManager
{
    if (_naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
}

// 开始路径规划(这是从Main.storyboard中拖出来的一个按钮方法)
- (IBAction)routeCal:(id)sender
{
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    // 驾车路径规划（未设置途经点、导航策略为速度优先）
    [_naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
    //步行路径规划
    [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
}

// 路径规划成功的回调函数
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    // 导航视图展示
    [_naviManager presentNaviViewController:_naviViewController animated:YES];
}

//导航视图被展示出来的回调函数
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    //调用startGPSNavi方法进行实时导航，调用startEmulato rNavi方法进行模拟导航
    //    [_naviManager startGPSNavi];
    [_naviManager startEmulatorNavi];
}

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    [self.naviManager stopNavi];
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
