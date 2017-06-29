//
//  CCBWindow.m
//  CCB_VerifyCodeStore
//
//  Created by pim on 14-9-9.
//  Copyright (c) 2014年 pim. All rights reserved.
//

#import "CCBWindow.h"
//#import "DBModel.h"
#import "OrderDetails.h"
#define MAXSMSTIME 60
@interface CCBWindow ()
<UIAlertViewDelegate>
{
    NSInteger _flag;
    NSInteger smsTime;
    NSString *_confirmBTitle;
}


@property(nonatomic,strong)OrderDetails *myOrderDetails;
@property(nonatomic,strong)UIView *maskView;


@property(nonatomic,strong) UILabel *timelable;
@property(nonatomic,strong) NSTimer *smsTimer;


@property(assign)BOOL SelfisShow;
@end


@implementation CCBWindow
static  CCBWindow *sharedWindow = nil;



@synthesize maskView;

+ (id)instance
{
    if (nil == sharedWindow)
    {
        sharedWindow = [[CCBWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return sharedWindow;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _confirmBTitle =@"";
        _flag=0;
        
        self.windowLevel=UIWindowLevelAlert;
        self.backgroundColor=[UIColor clearColor];
        
        maskView = [[UIView alloc]initWithFrame:self.frame];
        [self addSubview:maskView];
        maskView.backgroundColor=[UIColor clearColor];

        
        UIView *maskViewtap=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 180)];
         maskViewtap.backgroundColor=[UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:0.5];
        [maskView addSubview:maskViewtap];
   
        _SelfisShow=NO;
        
    }
    return self;
}

- (void)timer{
    if (smsTime>0) {
        smsTime--;

        NSString * smsTimestring=[NSString stringWithFormat:@"%@(%ld秒)",_confirmBTitle,(long)smsTime];
        [_myOrderDetails.confirmButton setTitle:smsTimestring forState: UIControlStateNormal];
    }else{
        if (_smsTimer != nil) {
            [_smsTimer invalidate];
            _smsTimer = nil;
            
        }
        
        [self hideshowWindow];

    }
}

- (void)setUIorderDic:(NSDictionary *)orderDic
{
    NSString *action=[orderDic objectForKey:@"action"];
    if([action isEqualToString:@"order_accept"])
    {
        _confirmBTitle = @"知道了";
    }else {
        _confirmBTitle = @"应单";
    }
    _myOrderDetails=[[OrderDetails alloc]initWithFrame:CGRectMake(0, 180, KScreenWidth, KScreenHeight-180)];
    _myOrderDetails.orderDic=orderDic;
    [_myOrderDetails.confirmButton addTarget:self action:@selector(replyOrder) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:_myOrderDetails];
    
    
}

#pragma mark  *******私有方法********

- (void)replyOrder
{
    if([_confirmBTitle isEqualToString:@"知道了"])
    {
        if([(NSObject *)_MainDelegate respondsToSelector:@selector(ReLoadingTableViewDate)])
        {
            [_MainDelegate ReLoadingTableViewDate];
        }
        _flag=0;
        [self hideshowWindow];
        
        [self crateNotificationWithDic:nil];
    }
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *lon=[NSString stringWithFormat:@"%f",delegate.Newestlongitude];
    NSString *lat=[NSString stringWithFormat:@"%f",delegate.Newestlatutide];
    
    QiFacade* facade;
    facade=[QiFacade sharedInstance];
    NSString *IDstring=[NSString stringWithFormat:@"%@",[_myOrderDetails.orderDic objectForKey:@"order_id"]];
    _flag=[facade putreplyOrder:IDstring lon:lon lat:lat];
    [facade addHttpObserver:self tag:_flag];    
}

- (void)crateNotificationWithDic:(NSDictionary *) userInfo
{
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"NEWS_REFRESH" object:nil userInfo:userInfo];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}




-(BOOL)isShow
{
    return _SelfisShow;
}
-(void)hideshowWindow
{
    if (_smsTimer != nil) {
        [_smsTimer invalidate];
        _smsTimer = nil;
        
    }

    
    NSLog(@"hideshowWindow");
    if(_myOrderDetails!=nil)
    {
        _myOrderDetails=nil;
    }
    [self resignKeyWindow];
    sharedWindow=nil;
     [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    _SelfisShow=NO;
        
}

-(void)show
{
    if(_SelfisShow)
        return;
    [self makeKeyAndVisible];
    
    
    if (_smsTimer != nil) {
        [_smsTimer invalidate];
        _smsTimer = nil;
        
    }
    smsTime=MAXSMSTIME+1;
    [self timer];
    _smsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
    
}

-(void)dismiss
{
    if(!_SelfisShow)
        return;
    [self hideshowWindow];
   

}

#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
   
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&_flag==iRequestTag)
    {
        
        //刷新
        if(_MainDelegate&&[(NSObject *)_MainDelegate respondsToSelector:@selector(ReLoadingTableViewDate)])
        {
            [_MainDelegate ReLoadingTableViewDate];
        }
        
        _flag=0;
        [self hideshowWindow];
        
        [self crateNotificationWithDic:nil];
    }
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
        _flag=0;
        [self hideshowWindow];
    }
    
    
    
    NSLog(@"失败 /n%@",response);
    
}

#pragma mark -AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
