//
//  MyMessage.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-26.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DrivePoint=0,    //初始化
    Drivesetoff,  //司机出发位置  应单位置
    Driveonway,    //途中的位置
    Drivearrived,    //司机到达接客点的位置   并且乘客上车位置
    DriveProcess,    //订单进行中的位置
    Drivegetoff      //乘客下车的位置

    
}LocationStates;



@interface MyMessage : NSObject
{
    
    NSDictionary  *userinfoDic;//获取的数据
    
}
@property(retain,nonatomic)NSDictionary  *userinfoDic;//获取的数据

@property(retain,nonatomic)NSString *isOnline;

@property(retain,nonatomic)NSArray  *setoffPointArr;//出发位置的数据


+(id)instance;


+ (CGSize)heightFosizeForString:(NSString *)value fontSize:(UIFont *)Font andWidth:(float)width;
+(CGFloat)widthFromWord:(NSString *)Value fontSize:(UIFont *)Font;
+(CGFloat)HeightFromfontSize:(UIFont *)Font;





@end
