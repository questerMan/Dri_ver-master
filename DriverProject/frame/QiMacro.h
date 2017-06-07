//
//  QiMacro.h
//  77net
//  常用宏定义
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#ifndef _7net_QiMacro_h
#define _7net_QiMacro_h

#pragma mark - 单例模式
//单例模式宏

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
        + (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
            return __singleton__; \
        }

#endif



#pragma mark - 颜色
//颜色

#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#ifndef RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#endif

#ifndef Color16
#define Color16(str) [ToolObject colorWithHexString:(str)]
#endif

#pragma mark - 字体
//字体
#ifndef SYSTEM_FONT
#define SYSTEM_FONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef BOLD_FONT
#define BOLD_FONT(size) [UIColor boldSystemFontOfSize:(size)]
#endif


//#pragma mark - log信息开关
////log信息
//
//#ifndef QI_LOG_FLAG
//#define QI_LOG_FLAG (1)
//#endif
//
//#if QI_LOG_FLAG > 0
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif


#pragma mark - 系统版本号判断
//系统版本号判断
//大于等于 7.0
#define IOS7_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

//大于等于 6.0
#define IOS6_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

//大于等于 5.0
#define IOS5_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending)



#pragma mark - 判断设备
//是否为iphone5
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568)

//设备屏幕大小
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height


