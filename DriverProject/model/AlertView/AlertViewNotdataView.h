//
//  AlertViewNotdataView.h
//  DriverProject
//
//  Created by zyx on 15/10/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

typedef enum {
    AlertViewDefault = 0,
    AlertViewNew,
    AlertViewBill,
    AlertViewScore,
    AlertViewtrip,
    AlertViewCoupon,
    AlertViewBalance,

}AlertViewType;



#import <UIKit/UIKit.h>

@interface AlertViewNotdataView : UIView



-(void)showNotdatdaView:(AlertViewType)AlertViewType;

-(void)hideNotdataView;


@end
