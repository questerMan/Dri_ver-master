//
//  AppDelegate.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBModel.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "MLNavigationController.h"

typedef enum {
    Orderinitialize= 0,
    Ordersetoff,   //接客出发
    Orderonway,    //接客途中
    Orderarrived,   //到达
 //   Ordergeton,    //乘客上车
    OrderProcess,    //行程中
    Ordergetoff       //下车
    
}OrderProcessStates;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    

}


@property (strong, nonatomic) UIWindow *window;



@property (strong, nonatomic) MLNavigationController *mainViewNav;

@property(nonatomic,strong)UIViewController *mainViewController;
@property(nonatomic,strong)LoginViewController *loginView;

@property(nonatomic,assign)OrderProcessStates ProcessStates ;
@property(nonatomic,assign)double Lastlongitude;
@property(nonatomic,assign)double Lastlatutide;
@property(nonatomic,strong)NSString *orderID;

@property(nonatomic,assign)double Newestlongitude;
@property(nonatomic,assign)double Newestlatutide;


@property(nonatomic,assign)double setofflongitude;
@property(nonatomic,assign)double setofflatutide;
@property(nonatomic,assign)BOOL     isInsertS;

-(void)showLoginView;





-(void)RunSocket;
-(void)StopSocket;


//定位
-(void)startGetLocation;  //开始定位
-(BOOL)isReceiveLoationBack;   // 是否定位成功//
//-(void)reflashUserIDAndEncrypt;
-(void)startLocationPositingWithOption:(BOOL)isFireNow;   //每隔多少时间定位一次
-(void)stopAllPositingTimer;        //停止循环定位





@end

