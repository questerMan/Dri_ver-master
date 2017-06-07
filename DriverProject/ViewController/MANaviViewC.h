//
//  MANaviViewC.h
//  DriverProject
//
//  Created by zyx on 15/9/23.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>


#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@protocol MANaviViewDelegate <NSObject>

-(void)refreshView;

@end

@interface MANaviViewC : UIViewController<MAMapViewDelegate,AMapSearchDelegate,AMapNaviManagerDelegate,IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;


@property(nonatomic ,strong)AMapGeoPoint  *StartPoint;

@property(nonatomic ,strong)AMapGeoPoint  *FinishPoint;;

@property (nonatomic, weak) id <MANaviViewDelegate> delegate;

@end

