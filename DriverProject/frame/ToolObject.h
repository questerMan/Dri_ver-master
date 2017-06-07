//
//  ToolObject.h
//  77net
//
//  Created by apple on 13-11-11.
//  Copyright (c) 2013年 77. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ToolObject : UIViewController




+(BOOL)IOS7;   //判断是否ios7操作系统
+(BOOL)IOS5;   //判断是否ios5操作系统
+(BOOL)IOS8;
+(BOOL)IOS7Current;//判断是否是ios7的系统
+(BOOL)REATAIN4;//判断是否宽屏机型
+(BOOL)requestsucce:(id)sender;
+(UIImage*)getImage:(NSString *)sender;
+(UIImage*)getImageAtdoc:(NSString *)sender;
+(NSString*)getstringFromreq:(id)sender arry:(NSArray*)arry;
+(void)messagebox:(UIViewController*)sender message:(NSString*)message;
+(void)messagebox4:(NSMutableArray*)sender;
+(BOOL)canshowBusHomePage;
+(NSInteger)getNetWorkStatus;
+(id)fetchSSIDInfo;
+(NSString*)gettxt:(NSString*)name;      //读取txt文本  name 文件名字，不保护后缀
+(void)writearryfile:(NSString*)thename userinfo:(id)sender;
+(NSDictionary*)readJsonWithDoc:(NSString*)name;
+(NSMutableArray*)readXmlWithDoc:(NSString*)name;
+(UILabel*)initlab:(float)sender bgcolor:(BOOL)clearcolor frame:(CGRect)frame;
+(BOOL)IsEnableWIFI;//判断网络环境是否wifi
+(BOOL)IsEnable3G;//判断网络环境是否3g
+(UIColor *)colorWithHexString: (NSString *) stringToConvert;
+(NSString*)getstrfromdic:(NSDictionary*)sender key:(NSString*)key;
+(BOOL)validateMobile:(NSString* )mobile;//正则表达式验证是否是手机号
+(BOOL)isBlankString:(NSString *)string;//判断字符串是否为空
+(BOOL)DistanceTime:(NSString*)time distancetime:(NSString*)distancetime;    //判断当前时间是否跟目标时间距离
+(BOOL)matchPassword:(NSString*)password;//正则匹配密码
+(BOOL)stringContainsEmoji:(NSString *)string;//判断字符串中是否带有emoji表情
+(NSString *)encodeToPercentEscapeString: (NSString *) input;//URL中带特殊字符或是中文的处理方法
+(NSMutableDictionary*)getDic:(NSMutableDictionary*)sender;
+(NSMutableArray*)getArray:(NSMutableArray*)sender;
+(BOOL)setnotwitdic:(NSDictionary*)dicsender id:(NSString*)idsender;
+(int)getnoread:(NSString*)idsender;
+(void)setread:(int)sender id:(NSString*)idsender;
+(void)removenot:(int)sender all:(BOOL)all id:(NSString*)idsender;
+(NSString*)getversion;
+(id)fromarry:(id)senderid keyid:(int)keyid;
+(id)fromdic:(id)senderid keyid:(NSString*)keyid;
+(BOOL)cangopushview;
+(double)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
//百度坐标转换火星坐标（有少许误差）
//+(CLLocation*)locationMarsFromBaiDu:(CLLocation*)locationDegrees;
//火星坐标转百度
//+(CLLocation*)LocationToBaiDu:(CLLocation *)locationDegrees;


+(BOOL)isPhoneNumber:(NSString *)str;//
+(void)initAllPlistData;
+(void)removeFileAtPath:(NSString *)filePath;
+(BOOL)canresectloacation;//是否可以重现获取地址位置

+(NSString*)getuseragernt;
+(NSString*)getaddressid;
+(NSMutableArray*)gettmpdata;//获取购物车列表
+(void)addtocart:(NSDictionary*)sender;//商品加入购物车
+(void)deleteitem:(NSString*)bui_id item_id:(NSString*)item_id;//减少商品   bui_id商铺id   item_id商品id
+(void)deletetheitem:(NSString*)bui_id item_id:(NSString*)item_id;//直接删除该项商品   bui_id商铺id   item_id商品id
+(NSInteger)getitemnum:(NSString*)bui_id item_id:(NSString*)item_id;//查看该商品在购物车里的总数量    bui_id商铺id   item_id商品id
+(NSInteger)getallitemmum;
+(void)addTheSameCommodity:(NSString *)bui_id item_id:(NSString *)item_id;//购物车里面已知商品的数量增加1

+(void)addItemArray:(NSArray*)sender;
+(void)repItemmum:(NSString*)bui_id item_id:(NSString*)item_id item_num:(NSInteger)item_num;
+(NSArray*)resetitem:(NSArray*)sender;   //刷新商品的状态

+(NSInteger)getitemmumwithbui:(NSString*)bui_id;  //获取该商家已点选的商品数量

+(NSString*)getAddressString;

//判断该行为的时间间隔   time 时间单位（秒）   key 键值，每个动作的键值最好独立
+(BOOL)timer:(NSInteger)time key:(NSString*)key;

+(NSArray*)order:(NSArray*)sender;  //数组简单排序

+(NSArray*)resettheitem:(NSArray*)sender fromarry:(NSArray*)fromarry;

+(NSArray*)reparray:(NSArray*)sender fromarry:(NSArray*)fromarry;   //替换
@end
