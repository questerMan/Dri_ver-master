//
//  TourismVC.h
//  DriverProject
//
//  Created by zyx on 15/9/28.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseSetViewController.h"
//出行热点
@interface TourismVC : BaseSetViewController

@property(nonatomic,strong) NSString*titlelable;
@property(nonatomic,strong) NSString*urlString;
@property(nonatomic,assign) BOOL  isdismissSelf;
@end
