//
//  AppDelegate.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//
#import "MANaviViewC.h"

#import "APIKey.h"
#import "AppDelegate.h"
#import "CCBLocationUtil.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "SocketOne.h"
#import "CCBWindow.h"
#import "MyMessage.h"
#import <AVFoundation/AVAudioSession.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UMessage.h"
#import "APIKey.h"
#import <AMapNaviKit/AMapNaviKit.h>

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#define KGETLOACTIONTIMES   5

#define COORDTIME   60  //每次心跳时间
#define HEARTBEATTIME   (60/COORDTIME)  //每次心跳时间
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CCBLocationDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate,MAMapViewDelegate,UNUserNotificationCenterDelegate>
{
    CCBLocationUtil *locationUtil;
    BOOL  receiveLoationBack;
    NSInteger _flag;
    NSInteger _flagProcess;
    NSInteger _flagonway;
    NSInteger _getLocationTimesNew;
    NSInteger _flagGetOff;
}
@property(assign,nonatomic) NSInteger getLocationTimes;
@property(nonatomic,copy)void (^returnLocationblock)(void);
@property(nonatomic,strong) NSTimer *locationTimer;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property(nonatomic,strong) NSTimer *locationTimer2;
@property(nonatomic,strong)CLLocationManager *myLocationManager;

@end

@implementation AppDelegate

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapLocationServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapNaviServices sharedServices].apiKey = (NSString *)APIKey;
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

-(void)initAmapLocation
{
    if(self.locationManager==nil)
    {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    NSLog(@"定位函数");
    [self.locationManager startUpdatingLocation];
}


- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5565399b",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];   
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configureAPIKey];
    [self configIFlySpeech];
    
    [self addUMMessage:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //初始化根视图
    [self initRootView];
    
    _isInsertS = NO;
    _flag=0;_flagProcess=0;_flagonway=0;_flagGetOff=0;
    _ProcessStates=Orderinitialize;
    _Lastlongitude=_Lastlatutide=0;
    _setofflongitude=_Lastlongitude;
    _setofflatutide=_Newestlatutide;
    
    //+++++++++++++++++++++++++++++
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    
    
    
    //[self judeOrderType];
//    BOOL isdelete = [DBModel DeleteCooMessageWithType:@"2"];
//    if(isdelete)
//    {
//        NSLog(@"删除成功");
//    }
    //+++++++++++++++++++++++++++++

    //启动监测网络状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrderselector:) name:@"NewOrderNotifi" object:nil];
    return YES;
}

#pragma mark - - 网络变化
- (void)networkChange:(NSNotification *)networkChnageNoti
{
    NSLog(@"网络变化%@",networkChnageNoti.userInfo);
    
    NSInteger networkStatu = [[networkChnageNoti.userInfo objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    
    switch (networkStatu) {
            case AFNetworkReachabilityStatusUnknown:
            [self showTextOnlyWith:@"未识别的网络"];
            NSLog(@"未识别的网络");
            break;
            
            case AFNetworkReachabilityStatusNotReachable:
            [self showTextOnlyWith:@"无网络状态"];
            NSLog(@"不可达的网络(未连接)");
            break;
            
            case AFNetworkReachabilityStatusReachableViaWWAN:
            [self crateNotificationWithDic:nil Name:@"NEWS_REFRESH"];
            [self crateNotificationWithDic:nil Name:@"requestOrderData"];
            NSLog(@"2G,3G,4G...的网络");
            break;
            
            case AFNetworkReachabilityStatusReachableViaWiFi:
            [self crateNotificationWithDic:nil Name:@"NEWS_REFRESH"];
            [self crateNotificationWithDic:nil Name:@"requestOrderData"];
            NSLog(@"wifi的网络");
            break;
        default:
            break;
    }
}

-(void)showTextOnlyWith:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

-(void)RunSocket
{
    NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
    NSString *UUID=[userDefaults objectForKey:@"APP_UUID"];
    NSString *TOKEN=[userDefaults objectForKey:@"APP_TOKEN"];
    
    NSString *ip=@"120.25.80.4"; NSInteger port=8383;
    
    MyMessage *myMessage=[MyMessage instance];
    if([myMessage.userinfoDic count]>0)
    {
        NSDictionary *socketDic=[myMessage.userinfoDic objectForKey:@"socket"];
        if(socketDic!=nil)
        {
            ip=[socketDic objectForKey:@"ip"];
            port=[[socketDic objectForKey:@"port"] integerValue];
        }
    }

    [[SocketOne sharedInstance] connect:ip withPort:port];
    
    NSString *sendSocket=[NSString stringWithFormat:@"{\"action\":\"login\", \"type\":\"driver\", \"uuid\":\"%@\", \"access_token\":\"%@\"}",UUID,TOKEN];
    NSLog(@"sendSocket=%@   ip=%@",sendSocket,ip);
    [[SocketOne sharedInstance] send:sendSocket];
    
    //[[SocketOne sharedInstance] send:@"{\"action\":\"login\", \"type\":\"driver\", \"uuid\":\"cd69deefef466cfa335232879e7ba171\", \"access_token\":\"dd1f160a1d09ede66933f0aa4dfa8767\"}"];

}

-(void)StopSocket
{

    [[SocketOne sharedInstance] disconnect];

}



-(void)addUMMessage:(NSDictionary *)launchOptions
{
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:@"56559e28e0f55ab20a000332" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerForRemoteNotifications];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate= self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];

}

-(void)showLoginView
{
    if(_loginView==nil){
    _loginView=[[LoginViewController alloc]init];
    }
    
    self.window.rootViewController = _loginView;
}

-(void)initRootView{
    
    
    ViewController *viewcontrol=[[ViewController alloc] init];
    viewcontrol.view.backgroundColor=Main_COLOR;
    _mainViewNav=[[MLNavigationController alloc] initWithRootViewController:viewcontrol];
    [_mainViewNav.recognizer requireGestureRecognizerToFail:viewcontrol.rightSwipGestureRecognizer];
     self.mainViewNav.navigationBarHidden=YES;

    NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
    
    NSString *UUID=[userDefaults objectForKey:@"APP_UUID"];
    NSString *TOKEN=[userDefaults objectForKey:@"APP_TOKEN"];
    NSLog(@"UUID==   %@    %@",UUID,TOKEN);
    if (NO) {
        //  第一次运行，显示欢迎界面
//        WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
//        self.window.rootViewController = welcomeViewController;
    } else {
        //  非第一次运行，不显示欢迎界面
        if ((UUID==nil)||(TOKEN==nil)) {
            _loginView=[[LoginViewController alloc]init];
            self.window.rootViewController = _loginView;

        } else {
            self.window.rootViewController = _mainViewNav;
            
            //socket
            [self RunSocket];
            if([self judgepositon])
            {
                [self startLocationPositingWithOption:YES];
            }
        }
    }
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    NSString* newDeviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
//    [UIFactory SaveNSUserDefaultsWithData:deviceToken1 AndKey:@"deviceToken"];
    NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newDeviceToken forKey:@"deviceToken"];
    NSLog(@"%@",newDeviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    //    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo]; //如需关闭推送，请使用[UMessage unregisterForRemoteNotifications]
    /*
        self.userInfo = userInfo;
        //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
                                                                message:@"Test On ApplicationStateActive"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
    
            [alertView show];
            
        }
     */

        NSLog(@"remote notification: %@",[userInfo description]);
        NSString* alertStr = nil;
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        NSObject *alert = [apsInfo objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]])
        {
            alertStr = (NSString*)alert;
        }
        else if ([alert isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* alertDict = (NSDictionary*)alert;
            alertStr = [alertDict objectForKey:@"body"];
        }
        application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
        if ([application applicationState] == UIApplicationStateActive && alertStr != nil)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pushed Message" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];    
        }
    
    //提取信息
    
     NSString *time = [userInfo objectForKey:@"time"];
     NSString *content= [userInfo objectForKey:@"content"];
     NSString *title = [userInfo objectForKey:@"title"];
    
    NSTimeInterval timeIn=[time doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeIn];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    //保存数据库
    
   BOOL issucess = [DBModel InsertWithMsgType:@"3" Message:content Date:currentDateStr titleString:title];
    if(issucess)
    {
        NSLog(@"推送插入成功!");
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self crateNotificationWithDic:userInfo Name:@"NEWS_REFRESH"];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)crateNotificationWithDic:(NSDictionary *)userInfo Name:(NSString *)name
{
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:name object:nil userInfo:userInfo];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

-(void)startGetLocation{
    
    if (receiveLoationBack) {
        return;
    }
    locationUtil=[CCBLocationUtil getInstnce];
    [locationUtil setM_delegate:self];
    [locationUtil getLocation];
    //    [locationUtil start];
     //   [locationUtil setPeriod:60];//设置周期
    
    //解决断网产生的反向获取地址死循环
    [self performBlock:^{
        if (receiveLoationBack)
        {
            [self onReceiveLoation:nil];
        }
    } afterDelay:20];
    
    
    
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [[block copy] autorelease];
    self.returnLocationblock=block;
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}


//当有电话进来或者锁屏，这时你的应用程会挂起
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"\n ===> 程序暂行 !");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    //[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];

    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    _getLocationTimesNew=1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self stopLocationPositingTimer];
        //[self initAmapLocation];
       _locationTimer2 = [NSTimer scheduledTimerWithTimeInterval:(COORDTIME) target:self selector:@selector(PostlocationNew2) userInfo:nil repeats:YES];
        [_locationTimer2 fire];
        [[NSRunLoop currentRunLoop] addTimer:_locationTimer2 forMode:NSRunLoopCommonModes];
        
        [[NSRunLoop currentRunLoop] run];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    NSLog(@"\n ===> 程序进入后台 !");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     NSLog(@"\n ===> 程序进入前台 !");
    [self stopLocationPositingTimer2];
    if([self judgepositon])
    {
        NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
        
        NSString *UUID=[userDefaults objectForKey:@"APP_UUID"];
        NSString *TOKEN=[userDefaults objectForKey:@"APP_TOKEN"];
        if(UUID!=nil &&TOKEN!=nil)
        {
            [self startLocationPositingWithOption:YES];
        }
        
        [self crateNotificationWithDic:nil Name:@"NEWS_REFRESH"];

    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"\n ===> 程序重新激活 !");
    [self judeOrderType];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"\n ===> 程序意外暂行 !");
    [locationUtil stop];
    
    
    
    
}
#pragma mark   私有方法
-(BOOL)judgepositon
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
        [self showWarningMessage:@"定位功能不可用,请开启定位"];
        return NO;
    }
    return NO;
}

- (void)showWarningMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)putStateGetOffpointlat:latutide pointlon:longitude distance:totalDistance  ext:_extraPay
{
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    NSArray *resultArray=[array objectAtIndex:0];
    if([resultArray count]>0)
    {
        
        NSString *orderString=[NSString stringWithFormat:@"/order/%@/getoff",_orderID];
        _flagGetOff=[facade putDriverOrderState:orderString pointlat:latutide pointlon:longitude distance:totalDistance  ext:_extraPay];
    }
    
}

- (void)judeOrderType
{
    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    NSArray *resultArray=[array objectAtIndex:0];
    if(resultArray!=nil)
    {
        
        NSString *tempstate=[resultArray objectAtIndex:6];
        NSInteger stateInt=[tempstate integerValue];
        NSLog(@"stateInt===%ld",(long)stateInt);
        _ProcessStates=(OrderProcessStates)stateInt;
        //_orderID=[[resultArray objectAtIndex:5] stringValue];
        switch (_ProcessStates) {
                
            case Orderonway:
                
                break;
            case Orderarrived:
                
                break;
            case OrderProcess:
            {

                break;
            }
            case Ordergetoff:
            {
                NSString *tempTotaldis=[resultArray objectAtIndex:1];
                NSString *ext=[resultArray objectAtIndex:2];
                NSString *tempLon=[resultArray objectAtIndex:3];
                NSString *tempLat=[resultArray objectAtIndex:4];
                
                
                [self putStateGetOffpointlat:tempLat pointlon:tempLon distance:tempTotaldis ext:ext];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - MALocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location==========:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    if ( location.coordinate.longitude==-1 && location.coordinate.latitude==-1) {
        if (self.getLocationTimes==KGETLOACTIONTIMES) {
            //           self.getLocationTimes=1;
        }else{
            //self.getLocationTimes++;
            //[self startGetLocation];
            return; 
        }
    }
    self.getLocationTimes = 1;
    //获取地理位置
    if ( location!=nil && location.coordinate.latitude!=-1 && location.coordinate.longitude!=-1)
    {
        
        receiveLoationBack=YES;
        _Newestlatutide=location.coordinate.latitude;
        _Newestlongitude=location.coordinate.longitude;
        NSString *longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
        NSString *latutide=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
        
        if(_setofflongitude==0)
        {
            //替换原始位置
            _setofflongitude=_Newestlongitude;
            _setofflatutide=_Newestlatutide;
        }
        
        if(_Lastlatutide==0)
        {
            _Lastlongitude=_Newestlongitude;
            _Lastlatutide=_Newestlatutide;
            
        }
        
        double distance=[locationUtil getDistanceFromLatutide:_Lastlatutide fromLongitude:_Lastlongitude toLatutide:_Newestlatutide toLongitude:_Newestlongitude];
        NSLog(@"%f/%f     /%f/%f",_Lastlatutide,_Lastlongitude,_Newestlatutide,_Newestlongitude);
        NSLog(@"获取位置成功distance=%f",distance);

        //设置订单的起始点
        //发送位置
        if(_ProcessStates==Ordersetoff) //出发
        {
            _setofflongitude=_Newestlongitude;
            _setofflatutide=_Newestlatutide;
            NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
            if(array!=nil)
            {
                BOOL isdelete = [DBModel DeleteCooMessageWithType:@"2"];
                if(isdelete){
                    NSLog(@"删除成功");
                }
            }
        }
        if(_ProcessStates == Orderonway)  //接客途中
        {
            QiFacade*       facade;
            facade=[QiFacade sharedInstance];
            NSString *IDstring=[NSString stringWithFormat:@"/order/%@/onway",_orderID];
            _flagonway=[facade putDriverOrderState:IDstring pointlat:latutide pointlon:longitude];
            [facade addHttpObserver:self tag:_flagonway];
            
            NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
            if(array==nil)
            {
                BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:[self getLocationTimeDate] totaldistance:@"0" distance:@"0" Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",Orderonway]];
                if(isSucces)
                {
                    NSLog(@"保存成功");
                    _isInsertS = YES;
                    
                    self.locationManager.distanceFilter = 100;
                }
            }
            
        }
        if(_ProcessStates==Orderarrived)
        {
            NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
            if(array==nil)
            {
                BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:[self getLocationTimeDate] totaldistance:@"0" distance:@"0" Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",Orderarrived]];
                if(isSucces)
                {
                    NSLog(@"到达保存成功");
                    _isInsertS = YES;
                    
                    self.locationManager.distanceFilter = 100;
                }
            }else{
                
                _isInsertS = YES;
                
                self.locationManager.distanceFilter = 100;
            }
        }
        if(_ProcessStates==OrderProcess)
        {
            [self postProcess:_Newestlatutide Longitude:_Newestlongitude];
        }
        if(_ProcessStates==Ordergetoff)
        {
            
            
        }
        
        _Lastlatutide=_Newestlatutide;
        _Lastlongitude=_Newestlongitude;
        NSLog(@"获取位置");
        
    }
}

#pragma mark   CLLocationManagerDelegate

-(void)postProcess:(double)newestlatutide  Longitude:(double)newestlongitude
{
    
    NSString *longitude=[NSString stringWithFormat:@"%f",newestlongitude];
    NSString *latutide=[NSString stringWithFormat:@"%f",newestlatutide];

    NSArray *array=[DBModel GetDistanceArrayfromType:@"2" withRecentNum:1];
    NSArray *resultArray=[array objectAtIndex:0];
    if(resultArray!=nil)
    {

        NSString *timeString=[resultArray objectAtIndex:0];
        NSString *timeNow=[self getLocationTimeDate];
        double DBLastLon=[[resultArray objectAtIndex:3] doubleValue];
        double DBLastLat=[[resultArray objectAtIndex:4] doubleValue];
        double distance=[locationUtil getDistanceFromLatutide:DBLastLat fromLongitude:DBLastLon toLatutide:_Newestlatutide toLongitude:_Newestlongitude];
        NSInteger timedate=[self secondFromDateComponent:[self dateFromString:timeString] todate:[self dateFromString:timeNow]];
       
        double speed=distance/timedate;
        NSLog(@"speed===%f",speed);
        if((distance>10.0)&&(speed<40))//加速度
        //if(YES)
        {
            
            NSString *distanceStr=[resultArray objectAtIndex:1];
            NSString *totalDistance=[NSString stringWithFormat:@"%f",([distanceStr doubleValue]+distance)];
            
            NSLog(@"timeString===%@   %@ %f  %@",timeString,timeNow,distance,totalDistance);
 
            BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:timeNow totaldistance:totalDistance distance:@"0" Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",_ProcessStates]];
            if(isSucces)
            {
                QiFacade*       facade;
                facade=[QiFacade sharedInstance];
                NSString *IDstring=[NSString stringWithFormat:@"/order/%@/process",_orderID];
                _flagProcess=[facade putDriverOrderState:IDstring pointlat:latutide pointlon:longitude segment:[NSString stringWithFormat:@"%f",distance] distance:totalDistance];
                [facade addHttpObserver:self tag:_flagProcess];
            }
        }
    }
    //如果数据库中定位失败
    else
    {
        BOOL isSucces= [DBModel InsertWithMsgType:@"2" Date:[self getLocationTimeDate] totaldistance:@"0" distance:@"0" Lon:longitude Lat:latutide orderId:_orderID processStates:[NSString stringWithFormat:@"%d",Orderarrived]];
        if(isSucces)
        {
            NSLog(@"到达保存成功");
        }
        
    }
}
-(NSString *)getLocationTimeDate
{
    NSString *timeDate=@"";
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeDate=locationString;

    return timeDate;
}

-(NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSDate *date =[dateformatter dateFromString:dateString];

    return date;
}
-(NSInteger)secondFromDateComponent:(NSDate *)date1 todate:(NSDate *)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    long sec =[d day]*3600*24+[d hour]*3600+[d minute]*60+[d second];
    NSLog(@"second = %ld",[d hour]*3600+[d minute]*60+[d second]);
    return sec;
}



#pragma mark   CCBLocationDelegate
-(void)setProcessStates:(OrderProcessStates)ProcessStates
{
    NSLog(@"ProcessStates=%u",ProcessStates);
    _ProcessStates=ProcessStates;
    
}

-(void)startLocationPositingWithOption:(BOOL)isFireNow
{
    
    
    [self initAmapLocation];
    
    //心跳
    if(self.locationTimer==nil)
        {
            _getLocationTimesNew=1;
            self.locationTimer=[NSTimer scheduledTimerWithTimeInterval:COORDTIME
                                                                target:self
                                                              selector:@selector(PostlocationNew)
                                                              userInfo:nil
                                                               repeats:YES];
            if (isFireNow) {
                [self.locationTimer fire];
            }
        }
}

-(BOOL)isReceiveLoationBack;{
    return receiveLoationBack;
}

-(void)stopAllPositingTimer
{
    if(self.locationTimer!=nil)
    {
        [self.locationTimer invalidate];
        self.locationTimer=nil;
    }
    if(self.locationTimer2!=nil)
    {
        [self.locationTimer2 invalidate];
        self.locationTimer2=nil;
    }
    if(self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
    }

}

-(void)stopLocationPositingTimer{
    if(self.locationTimer!=nil)
    {
        [self.locationTimer invalidate];
        self.locationTimer=nil;
    }
}

-(void)stopLocationPositingTimer2{
    if(self.locationTimer2!=nil)
    {
        [self.locationTimer2 invalidate];
        self.locationTimer2=nil;
    }
}



-(void)PostlocationNew
{
    [self sendHeardBeat];
}


-(void)PostlocationNew2
{
    [self sendHeardBeat];
}

-(void)sendHeardBeat
{
    if(_getLocationTimesNew > HEARTBEATTIME)
    {
        _getLocationTimesNew=1;
        NSString *longitude= [NSString stringWithFormat:@"%f",_Newestlongitude];
        NSString *latutide= [NSString stringWithFormat:@"%f",_Newestlatutide];
        NSLog(@"心跳");
        QiFacade*       facade;
        facade=[QiFacade sharedInstance];
        [self exChangeMessageDataSourceQueue:^{
            //心跳
            _flag=[facade postHeartbeat:latutide pointlon:longitude];
            [facade addHttpObserver:self tag:_flag];
        }];
     
    }
    _getLocationTimesNew++;

}

- (void)newOrderselector:(NSNotification *)text{
    
    NSLog(@"－－－－－行驶中数据------");
    NSLog(@"%@",text.userInfo);
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:text.userInfo];

     CCBWindow *Mywindow=[CCBWindow instance];
    [Mywindow setUIorderDic:dic];
    [Mywindow show];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
            NSLog(@"心跳成功 /n%@",response);
    }
    if(_flagProcess!=0&&response!=nil&&iRequestTag==_flagProcess)
    {
        _flagProcess=0;
        NSLog(@"行程中  %@",response);
        
//        {
//            code = 1;
//            data =     {
//                fee = "0.03";
//                km = "0.01";
//                min = 0;
//            };
//            message = success;
//        }
        NSDictionary *processDic=[response objectForKey:@"data"];
        if(processDic!=nil)
        {
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"OrderProcessNews" object:nil userInfo:processDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        }
        
    }
    if(_flagonway!=0&&response!=nil&&iRequestTag==_flagonway)
    {
        _flagonway=0;
        NSLog(@"前往接客点  %@",response);
        
    }
    if(_flagGetOff!=0&&response!=nil&&iRequestTag==_flagGetOff)
    {
        NSLog(@"下车:%@",response);
        
        [DBModel DeleteCooMessageWithType:@"2"];
        
    }

}

- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
  
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
    }
    
    
    
    NSLog(@"失败 /n%@",response);
    
}

@end
