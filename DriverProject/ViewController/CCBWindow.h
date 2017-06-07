//
//  CCBWindow.h
//  CCB_VerifyCodeStore
//
//  Created by pim on 14-9-9.
//  Copyright (c) 2014年 pim. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainWindowDelegate;

@interface CCBWindow : UIWindow

+(id)instance;

-(void)show;

-(void)dismiss;

-(void)ShowLastMessage:(NSString *)LastString WithMainStr:MainStr User:UserId;

-(BOOL)isShow;
@property(nonatomic,strong)UITableView *DetailstableView;


-(void)setUIorderDic:(NSDictionary *)orderDic;


@property (nonatomic, weak) id<MainWindowDelegate> MainDelegate;


@end



@protocol MainWindowDelegate <NSObject>

-(void)ReLoadingTableViewDate;

@end