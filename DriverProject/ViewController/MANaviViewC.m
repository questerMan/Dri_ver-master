//
//  MANaviViewC.m
//  DriverProject
//
//  Created by zyx on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MANaviViewC.h"
#import <AudioToolbox/AudioToolbox.h>

#import "APIKey.h"
#import "MANaviAnnotationView.h"
#import "SharedMapView.h"

@interface MANaviViewC ()<AMapNaviViewControllerDelegate>
{
    AMapNaviPoint *_endPoint;
    
    MAUserLocation *_userLocation;
    
    NSMutableArray *_poiAnnotations;
}

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviViewController *naviViewController;

@end

@implementation MANaviViewC

#pragma mark - Life Cycle

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *labe = [[UILabel alloc] init];
    labe.font = [UIFont systemFontOfSize:20];
    labe.text = @"正在拼命为您服务，请稍等...";
    labe.textAlignment = NSTextAlignmentCenter;
    labe.tag = 1000;
    labe.frame = CGRectMake(0, 280, SCREEN_W, 50);
    [self.view addSubview:labe];
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initProperties];
    
    //[self initSearch];
    
    [self initNaviManager];
    
    [self initMapView];
    
    [self initIFlySpeech];
    
    //[self start];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"QuickStart";
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.barStyle          = UIBarStyleBlack;
    self.navigationController.toolbar.translucent       = NO;
    self.navigationController.toolbarHidden             = NO;
    
    //[self initToolBar];
    
    //[self setupMapView];
    
    
    _mapView.showsUserLocation=YES;
    
    [self start];
}

#pragma mark - Initalization

-(void)initButton
{
    UIButton *startNav=[UIButton buttonWithType:UIButtonTypeCustom];
    [startNav addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startNav.frame=CGRectMake(50, 50, 80, 50);
    [self.view addSubview:startNav];
    
    
}
-(void)start
{
    
    
    AMapGeoPoint* annotation=[AMapGeoPoint locationWithLatitude:_FinishPoint.latitude longitude:_FinishPoint.longitude];
    if ([annotation isKindOfClass:[AMapGeoPoint class]])
    {
        
        
        _endPoint = [AMapNaviPoint locationWithLatitude:annotation.latitude
                                              longitude:annotation.longitude];
        
        [self startEmulatorNavi];
    }
    
    
    
}

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"餐饮",
                                             @"酒店",
                                             @"电影",
                                             nil]];
    
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, nil];
}

- (void)initProperties
{
    _poiAnnotations = [[NSMutableArray alloc] init];
}

- (void)initSearch
{
    if (self.search == nil)
    {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey:(NSString *)APIKey Delegate:self];
    }
}

- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        self.naviManager = [[AMapNaviManager alloc] init];
    }
    
    [self.naviManager setDelegate:self];
}

- (void)initNaviViewController
{
    if (self.naviViewController == nil)
    {
        self.naviViewController = [[AMapNaviViewController alloc] initWithMapView:_mapView delegate:self];
    }
    
    [self.naviViewController setDelegate:self];
}

- (void)initMapView
{
    if (_mapView == nil)
    {
        _mapView = [[SharedMapView sharedInstance] mapView];
    }
    _mapView.backgroundColor=[UIColor clearColor];
    //[_mapView setFrame:self.view.bounds];
    [_mapView setDelegate:self];
    //[self.view addSubview:_mapView];
}

- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
}

#pragma mark - Handle Views

- (void)setupMapView
{
//        [self.mapView setDelegate:self];
//    
//        [self.mapView setFrame:self.view.bounds];
//        [self.view addSubview:self.mapView];
    
    [self.mapView setShowsUserLocation:YES];
    
    if ([_poiAnnotations count])
    {
        [self showPOIAnnotations];
    }
}

- (void)cleanMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView setShowsUserLocation:NO];
    
    [self.mapView setDelegate:nil];
    
}

#pragma mark - Search

- (void)searchAction:(UISegmentedControl *)segmentedControl
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    if (_userLocation)
    {
        request.location = [AMapGeoPoint locationWithLatitude:_userLocation.location.coordinate.latitude
                                                    longitude:_userLocation.location.coordinate.longitude];
    }
    else
    {
        request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.471476];
    }
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.keywords            = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    request.sortrule            = 1;
    request.requireExtension    = NO;
    
    [self.search AMapPlaceSearch:request];
}

#pragma mark - Actions

- (void)startEmulatorNavi
{
    [self calculateRoute];
}

- (void)calculateRoute
{
    NSArray *endPoints = @[_endPoint];
    
//    AMapNaviPoint *startPoint =[AMapNaviPoint locationWithLatitude:_userLocation.location.coordinate.latitude
//                                                         longitude:_userLocation.location.coordinate.longitude];
    
    AMapNaviPoint *startPoint =[AMapNaviPoint locationWithLatitude:_StartPoint.latitude
                                                         longitude:_StartPoint.longitude];
    NSArray *startS = @[startPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startS endPoints:endPoints wayPoints:nil drivingStrategy:0];
    
}

#pragma mark - MapView Delegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        _userLocation = userLocation;
    }
    NSLog(@"_userLocation==%@",_userLocation);
    //[self start];
    
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
//    [self cleanMapView];
//    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //地图开始导航位置
//    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        MAPointAnnotation *annotation = (MAPointAnnotation *)view.annotation;
//        
//        _endPoint = [AMapNaviPoint locationWithLatitude:annotation.coordinate.latitude
//                                              longitude:annotation.coordinate.longitude];
//        
//        [self startEmulatorNavi];
//    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //地图搜索结果
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"poiIdentifier";
        MANaviAnnotationView *annotationView = (MANaviAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Search Delegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"SearchError:{%@}", error.localizedDescription);
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    if (respons.pois.count == 0)
    {
        return;
    }
    
    [self.mapView removeAnnotations:_poiAnnotations];
    [_poiAnnotations removeAllObjects];
    
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        
        [_poiAnnotations addObject:annotation];
    }];
    
    [self showPOIAnnotations];
}

- (void)showPOIAnnotations
{
    [self.mapView addAnnotations:_poiAnnotations];
    
    if (_poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [(MAPointAnnotation *)_poiAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:_poiAnnotations animated:NO];
    }
}

#pragma mark - AMapNaviManager Delegate

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    NSLog(@"error:{%@}",error.localizedDescription);
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didPresentNaviViewController");
    //调用startGPSNavi方法进行实时导航，调用startEmulatorNavi方法进行模拟导航
    //[self.naviManager startEmulatorNavi];   //模拟
    [self.naviManager startGPSNavi];
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didDismissNaviViewController");
    
    [self setupMapView];
    
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    NSLog(@"OnCalculateRouteSuccess");
    
    if (self.naviViewController == nil)
    {
        [self initNaviViewController];
        

    }
    
    [self cleanMapView];
    //导航视图展示
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure");
    
    
    
    //导航失败关闭
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_iFlySpeechSynthesizer stopSpeaking];
    });
    //在点击导航界面上的关闭按钮时，停止导航
    [self.naviManager stopNavi];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager
{
    NSLog(@"NeedReCalculateRouteForYaw");
}

- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager
{
    NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    //    NSLog(@"didUpdateNaviLocation");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
    //    NSLog(@"didUpdateNaviInfo");
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    return 0;
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager
{
    NSLog(@"DidUpdateTrafficStatuses");
}

#pragma mark - AManNaviViewController Delegate

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_iFlySpeechSynthesizer stopSpeaking];
    });
    //在点击导航界面上的关闭按钮时，停止导航
    [self.naviManager stopNavi];
    
    
    
    [self cleanMapView];
    
    
    [self.naviViewController dismissViewControllerAnimated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                if([_delegate respondsToSelector:@selector(refreshView)]){
                    [_delegate refreshView];
                }
            }];
            
        });
    }];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

@end
