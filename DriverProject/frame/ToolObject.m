//
//  ToolObject.m
//  77net
//
//  Created by apple on 13-11-11.
//  Copyright (c) 2013年 77. All rights reserved.
//

#import "ToolObject.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "sys/utsname.h"
#import "Reachability.h"
@interface ToolObject ()

@end

@implementation ToolObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


+(NSString*)getversion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *str=[infoDictionary objectForKey:@"CFBundleVersion"];
    NSArray *arry=[str componentsSeparatedByString:@"."];
    NSString *strver=[NSString stringWithFormat:@"%@.%@.%@",[arry objectAtIndex:0],[arry objectAtIndex:1],[arry objectAtIndex:2]];
    return strver;
}


+(BOOL)timer:(NSInteger)time key:(NSString*)key{
    long now = (long)([[NSDate date] timeIntervalSince1970]);
    if ([PLIST objectForKey:key]==nil) {
        [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:key];
        [PLIST synchronize];
        return YES;
    }
    else{
        
        NSString *strlast=[PLIST objectForKey:key];
        long longstrlast=(long)[strlast integerValue];
        if ((now-longstrlast)>time) {
            [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:key];
            [PLIST synchronize];
            return YES;
        }
        else{
            return NO;
        }
    }
}

+(NSString*)getstringFromreq:(id)sender arry:(NSArray*)arry{
    NSString *str;
    if (sender!=nil&&[sender isKindOfClass:[NSDictionary class]]) {
        if ([[sender objectForKey:@"D"] isKindOfClass:[NSDictionary class]]) {
            id ddd=[sender objectForKey:@"D"];
            for (int i=0; i<[arry count]; i++) {
                ddd=[ddd objectForKey:[arry objectAtIndex:i]];
            }
            if ([ddd isKindOfClass:[NSString class]]) {
                str=[NSString stringWithFormat:@"%@",ddd];
                return str;
            }
            else{
                return @"";
            }
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
    //return str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+(BOOL)REATAIN4{
    if (KScreenHeight==568) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)removeFileAtPath:(NSString *)filePath {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        
        if (error) {
            NSLog(@"移除文件失败，错误信息：%@", error);
        }
        else {
            NSLog(@"成功移除文件");
        }
    }
    else{
        NSLog(@"文件不存在");
    }
}



+(NSString*)getstrfromdic:(NSDictionary*)sender key:(NSString*)key{
    NSString *str=@"";
    return str;
}
+(BOOL)setnotwitdic:(NSDictionary*)dicsender id:(NSString*)idsender{
    if ([PLIST boolForKey:@"startsave"]==NO) {
        [PLIST setBool:YES forKey:@"startsave"];
        NSMutableArray *arry=[ToolObject readXmlWithDoc:[NSString stringWithFormat:@"not%@.plist",idsender]];
        if (arry==nil) {
            arry=[[NSMutableArray alloc] init];
        }
        for (int i=0; i<[arry count]; i++) {
            if ([[NSString stringWithFormat:@"%@",[dicsender objectForKey:@"ms_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[[arry objectAtIndex:i] objectForKey:@"ms_id"]]]) {
                [PLIST setBool:NO forKey:@"startsave"];
                return NO;
            }
        }
        [arry insertObject:dicsender atIndex:0];
        [ToolObject writearryfile:[NSString stringWithFormat:@"not%@.plist",idsender] userinfo:arry];
        [PLIST setBool:NO forKey:@"startsave"];
    }
    else{
        return NO;
    }
    
    
    return YES;
}




+(NSString*)getuseragernt{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );

    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    
    NSString *str;
    NSString *strversion=[NSString stringWithFormat:@"%@.%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    NSString *strnetwork;
    if ([PLIST integerForKey:@"NETWORKSTATUS"]==0) {
        strnetwork=@"OTHER";
    }
    else if ([PLIST integerForKey:@"NETWORKSTATUS"]==1){
        strnetwork=@"3GNET";
    }
    else if ([PLIST integerForKey:@"NETWORKSTATUS"]==2){
        NSString *httpMethod = [[[ToolObject fetchSSIDInfo] objectForKey:@"SSID"] uppercaseString];
        NSRange personRange = [httpMethod rangeOfString:@"77.NET"];
        
        if (personRange.length!=0) {
            strnetwork=@"QWIFI";
        }
        else{
            strnetwork=@"WIFI";
        }
        
    }
    
    
    str = [NSString stringWithFormat:@"(%@;%@;) QiQi-I/%@ NetType/%@",phoneModel,phoneVersion,strversion,strnetwork];
    return str;
}


+(int)getnoread:(NSString*)idsender{
    int d=0;
    NSMutableArray *arry=[ToolObject readXmlWithDoc:[NSString stringWithFormat:@"not%@.plist",idsender]];
    for (int i=0; i<[arry count]; i++) {
        if ([[[arry objectAtIndex:i] objectForKey:@"read"]intValue]==1) {
            d++;
        }
    }
    return d;
}


+(void)setread:(int)sender id:(NSString*)idsender{
    NSMutableArray *arry=[ToolObject readXmlWithDoc:[NSString stringWithFormat:@"not%@.plist",idsender]];
    int set=100000;
    for (int i=0; i<[arry count]; i++) {
        if (i==sender) {
            set=i;
        }
    }
    NSMutableDictionary *da=[NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:set]];
    [da setObject:@"0" forKey:@"read"];
    [arry removeObjectAtIndex:set];
    [arry insertObject:da atIndex:set];
    [ToolObject writearryfile:[NSString stringWithFormat:@"not%@.plist",idsender] userinfo:arry];
}


+(void)removenot:(int)sender all:(BOOL)all id:(NSString*)idsender{
    
    NSMutableArray *arry=[ToolObject readXmlWithDoc:[NSString stringWithFormat:@"not%@.plist",idsender]];
    
    if (all==YES) {
        [arry removeAllObjects];
    }
    else{
        [arry removeObjectAtIndex:sender];
    }
    [ToolObject writearryfile:[NSString stringWithFormat:@"not%@.plist",idsender] userinfo:arry];
}


+(BOOL)cangopushview{
    long now = (long)([[NSDate date] timeIntervalSince1970]);
    
    if ([PLIST objectForKey:@"lastpushtime"]==nil){
        [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:@"lastpushtime"];
        return YES;
    }
    else{
        NSString *strlast=[PLIST objectForKey:@"lastpushtime"];
        long longstrlast=(long)[strlast integerValue];
        if ((now-longstrlast)>5) {
            [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:@"lastpushtime"];
            return YES;
        }
        else{
            return NO;
        }
    }
    
    
    
    return YES;
}



+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = 3.1415926*lat1/180.0f;
    double radlat2 = 3.1415926*lat2/180.0f;
    //now long.
    double radlong1 = 3.1415926*lon1/180.0f;
    double radlong2 = 3.1415926*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = 3.1415926/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = 3.1415926/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = 3.1415926*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = 3.1415926/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = 3.1415926/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = 3.1415926*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}


+(BOOL)DistanceTime:(NSString*)time distancetime:(NSString*)distancetime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    long long tt=[timeString longLongValue];
    long long dd=[time longLongValue];
    
    
    if (tt>dd) {
        if ((tt-dd)>60*[distancetime intValue]) {
            return YES;
        }
        else{
            return NO;
        }
        
    }
    else{
        
        if ((dd-tt)>60*[distancetime intValue]) {
            return YES;
        }
        else{
            return NO;
        }
    }
}

+(UILabel*)initlab:(float)sender bgcolor:(BOOL)clearcolor frame:(CGRect)frame{
    UILabel *lab=[[UILabel alloc] initWithFrame:frame];
    if (clearcolor==YES) {
        lab.backgroundColor=[UIColor clearColor];
    }
    lab.font=[UIFont systemFontOfSize:sender];
    return lab;
}

+(BOOL)IOS7{
    struct utsname systemInfo;
    uname(&systemInfo);
    if ([[[UIDevice currentDevice] systemVersion] intValue]>6) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)IOS7Current
{
    struct utsname systemInfo;
    uname(&systemInfo);
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>=7&&version<8) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)IOS8{
    struct utsname systemInfo;
    uname(&systemInfo);
    if ([[[UIDevice currentDevice] systemVersion] intValue]>7) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)IOS5{
    struct utsname systemInfo;
    uname(&systemInfo);
    if ([[[UIDevice currentDevice] systemVersion] intValue]<6) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)requestsucce:(id)sender{
    
    if (![sender isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    else{
        return YES;
    }
}

+(UIImage*)getImage:(NSString *)sender{
    UIImage *img;
    img=[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:sender ofType:@""]];
    //img=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:sender ofType:@""]];
    return img;
}

+(void)messagebox:(UIViewController*)sender message:(NSString*)message{
    
    if (sender==nil || message==nil) {
        return ;
    }
    
    
    NSMutableArray *array=[NSMutableArray arrayWithObjects:sender,message, nil];
    
    [self performSelectorOnMainThread:@selector(messagebox4:) withObject:array waitUntilDone:YES];
}


+(void)messagebox4:(NSMutableArray*)sender {
    
    if(sender==nil || [sender count]<2)
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[sender objectAtIndex:1]
                                                   delegate:[sender objectAtIndex:0]
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}


+(UIImage*)getImageAtdoc:(NSString *)sender{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:sender];
    UIImage *img=[UIImage imageWithContentsOfFile:filename];
    return img;
}

+(NSString*)gettxt:(NSString*)name{
    NSError *error;
    NSString *textContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    return textContents;
}


+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}


+(void)writearryfile:(NSString*)thename userinfo:(id)sender{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:thename];
    [sender writeToFile:filename  atomically:YES];
}


+(NSDictionary*)readJsonWithDoc:(NSString*)name{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:name];
    NSDictionary *array=[NSDictionary dictionaryWithContentsOfFile:filename];
    return array;
}



+(NSMutableArray*)readXmlWithDoc:(NSString*)name{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:name];
    NSArray *array=[NSArray arrayWithContentsOfFile:filename];
    NSMutableArray *nsarry=[NSMutableArray arrayWithArray:array];
    return nsarry;
}


+(BOOL)canshowBusHomePage{
    long now = (long)([[NSDate date] timeIntervalSince1970]);
    NSString *strlast=[PLIST objectForKey:LASTTIME];
    long longstrlast=(long)[strlast integerValue];

    if ((now-longstrlast)>7200) {
        [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:LASTTIME];
        [PLIST synchronize];
        return YES;
    }
    else{
        return NO;
    }
}


+(BOOL)canresectloacation{
    long now = (long)([[NSDate date] timeIntervalSince1970]);
    NSString *strlast=[PLIST objectForKey:LASTLCACTION];
    long longstrlast=(long)[strlast integerValue];
    
    if ((now-longstrlast)>300) {
        [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:LASTLCACTION];
        [PLIST synchronize];
        return YES;
    }
    else{
        return NO;
    }
}


+(BOOL)canshowNetwokesuccer{
    
    
    long now = (long)([[NSDate date] timeIntervalSince1970]);
    NSString *strlast=[PLIST objectForKey:LASTTIME];
    long longstrlast=(long)[strlast integerValue];
    
    if ((now-longstrlast)>7200) {
        [PLIST setObject:[NSString stringWithFormat:@"%ld",now] forKey:LASTTIME];
        [PLIST synchronize];
        return YES;
    }
    else{
        return NO;
    }
    
    
    
}


+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


+(UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return nil;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//正则表达式匹配手机号
+(BOOL) validateMobile:(NSString* )mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((\\(\\d{3}\\))|(\\d{3}\\-))?((13)|(14)|(15)|(17)|(18)){1}\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



+(BOOL)isPhoneNumber:(NSString *)str
{
    //去除字符串中的空格
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (newStr.length>11)
    {
        //截取后11位
        newStr = [newStr substringFromIndex:newStr.length - 11];
        NSLog(@"%@",newStr);
        return [self validateMobile:newStr];// 匹配11位是否为手机号
    }
    
    else if (newStr.length<11)
        
    {
        return NO;
    }
    
    else
    {
        return [self validateMobile:newStr];
    }
}

#pragma -mark 重新初始化PLIST
+(void)initAllPlistData
{

    //移除PLIST中的所有数据
    NSDictionary *dictionary = [PLIST dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [PLIST removeObjectForKey:key];
        [PLIST synchronize];
    }
    
    //重新初始化PLIST
    if ([PLIST objectForKey:MYIPHONEMAC]==nil) {
        [PLIST setObject:@"02:00:00:00:00:00" forKey:MYIPHONEMAC];
    }
    [PLIST setInteger:0 forKey:@"NETWORKSTATUS"];
    [PLIST setBool:NO forKey:RoutersBus];
    [PLIST setBool:NO forKey:@"CANSHOW"];
    [PLIST setObject:@"1" forKey:CANSHARE];
    [PLIST setObject:@"" forKey:THEFIRSTLOC];
    
    if ([PLIST objectForKey:@"OpenSound"]==nil) {
        [PLIST setObject:@"0" forKey:@"OpenSound"];
    }
    
    if ([PLIST objectForKey:ENVIRONMENT]==nil) {
        [PLIST setObject:@"http://www.77.net/api/api.php" forKey:ENVIRONMENT];
    }
    
    if ([PLIST objectForKey:THE_NEEDPASSWORD]==nil) {
        [PLIST setObject:@"0" forKey:THE_NEEDPASSWORD];
    }
    if ([PLIST objectForKey:ROOM]==nil) {
        [PLIST setObject:@"0" forKey:ROOM];
    }
    
    if ([PLIST objectForKey:FIRSTOPEN]==nil) {
        [PLIST setObject:@"1" forKey:ROOM];
    }
    
    if ([PLIST objectForKey:THEMONEY]==nil) {
        [PLIST setObject:@"30" forKey:THEMONEY];
    }
    [PLIST setObject:@"0" forKey:@"CHENKNETWORK"];
    [PLIST setObject:@"" forKey:@"DQBid"];
    [PLIST setObject:@"" forKey:@"DQbui_name"];
    [PLIST setObject:@"0" forKey:LASTTIME];
    [PLIST setObject:@"0" forKey:LASTONLINETIME];
    [PLIST setBool:NO forKey:LOGOUT_NOW];
    [[NSNotificationCenter defaultCenter] postNotificationName:BUI_ID_CHANGE object:[PLIST objectForKey:@"DQBid"]];
    [PLIST setObject:@"" forKey:SERVERMAC];
    [PLIST setBool:NO forKey:@"AUTOLOGIN"];
    
    if ([PLIST objectForKey:THESELECTCITY]==nil) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:@"440100" forKey:@"ar_code"];
        [dic setObject:@"231" forKey:@"ar_id"];
        [dic setObject:@"广州" forKey:@"ar_name"];
        [PLIST setObject:dic forKey:THESELECTCITY];
    }
    
    //NSLog(@"%@",[PLIST objectForKey:THESELECTCITY]);
    
    if ([PLIST objectForKey:SHOWSHARE]==nil) {
        [PLIST setObject:@"1" forKey:SHOWSHARE];
    }
    
    if ([PLIST objectForKey:ONLINESTATUS]==nil) {
        [PLIST setObject:@"0" forKey:ONLINESTATUS];
    }
    
    if ([PLIST objectForKey:MOBCHECK]==nil) {
        [PLIST setObject:@"0" forKey:MOBCHECK];
    }
    
    if ([PLIST doubleForKey:@"bui_lat"]==0) {
        [PLIST setDouble:23.13502414452598 forKey:@"bui_lat"];
        [PLIST setDouble:113.3297527129085 forKey:@"bui_lot"];
        [PLIST synchronize];
    }

    [PLIST synchronize];
}

+(NSMutableDictionary*)getDic:(NSMutableDictionary*)sender{
    NSMutableDictionary *dicc=[[NSMutableDictionary alloc] init];
    for (int i=0; i<[[sender allKeys] count]; i++) {
        if ([[sender objectForKey:[[sender allKeys] objectAtIndex:i]] isKindOfClass:[NSNull class]]) {
            [dicc setObject:@"" forKey:[[sender allKeys] objectAtIndex:i]];
        }
        else{
            [dicc setObject:[sender objectForKey:[[sender allKeys] objectAtIndex:i]] forKey:[[sender allKeys] objectAtIndex:i]];
        }
    }
    
    return dicc;
}
+(NSMutableArray*)getArray:(NSMutableArray*)sender{
    NSMutableArray *arry=[[NSMutableArray alloc] init];
    for (int i=0; i<[sender count]; i++) {
        if ([[sender objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            [arry addObject:[ToolObject getDic:[sender objectAtIndex:i]]];
        }
        else{
            if ([[sender objectAtIndex:i] isKindOfClass:[NSNull class]]) {
                [arry addObject:@""];
            }
            else{
                [arry addObject:[sender objectAtIndex:i]];
            }
        }
    }
    return arry;
}

//返回0为无链接  1为腾达类型   2为磊科类    3为未知类
+(NSInteger)getNetWorkStatus{
    NSInteger KK;
    
    if ([[[ToolObject fetchSSIDInfo] allKeys] count]>0) {
        NSString *httpMethod = [[[ToolObject fetchSSIDInfo] objectForKey:@"SSID"] uppercaseString];
        NSRange personRange = [httpMethod rangeOfString:@"77.NET"];
        NSString *MAC = [[[ToolObject fetchSSIDInfo] objectForKey:@"BSSID"] uppercaseString];
        NSRange personRange2 = [MAC rangeOfString:@"C8:3A:35"];
        NSRange personRange3 = [MAC rangeOfString:@"08:10:77"];
        NSRange personRange4 = [MAC rangeOfString:@"04:8D:38"];
        
        
        
        if (personRange.length!=0) {
            if (personRange2.length!=0) {
                //腾达
                KK=1;
            }
            else if(personRange3.length!=0||personRange4.length!=0){
                KK=2;
            }
            else{
                KK=3;
            }
        }
        else{
            KK=0;
        }
    }
    else{
        KK=0;
    }
    return KK;
}

//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(BOOL)matchPassword:(NSString*)password
{
    //判断是否是中文
    NSString *pwRegex = @"^[\\x00-\\xff]{6,16}$";
    NSPredicate *passwordlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex];
    if (![passwordlTest evaluateWithObject:password]) {
        return NO;
    }
    //密码是否是除数字和字母以外的其他字符
    //    NSString *pwRegex1 = @"^[^a-zA-Z0-9]{6,16}$";
    //    NSPredicate *passwordlTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex1];
    //    if ([passwordlTest1 evaluateWithObject:password]) {
    //        return NO;
    //    }
    //密码是否是纯字母
    //    NSString* pwRegex2 = @"^[a-zA-Z]{6,16}$";
    //    NSPredicate *pwTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex2];
    //    if ([pwTest2 evaluateWithObject:password]) {
    //        return NO;
    //    }
    //判断是否包含emoji表情
    if ([self stringContainsEmoji:password]) {
        return NO;
    }
    //密码是否是纯数字
    //    NSString* pwRegex3 = @"^[0-9]{6,16}$";
    //    NSPredicate *pwTest3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex3];
    //    if ([pwTest3 evaluateWithObject:password]) {
    //        return NO;
    //    }
    //判断是否有空格
    NSString *pwRegex4 = @"^[^\\s+]{6,16}$";
    NSPredicate *passwordlTest4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex4];
    if (![passwordlTest4 evaluateWithObject:password]) {
        return NO;
    }
    return YES;
}

+(NSString*)getaddressid{
    if ([PLIST objectForKey:THEADDRESS]==nil) {
        return @"";
    }
    else{
        return [NSString stringWithFormat:@"%@",[[PLIST objectForKey:THEADDRESS] objectForKey:@"pa_id"]];
    }
}

+(void)addItemArray:(NSArray*)sender{
    for (int i=0; i<[sender count]; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[sender objectAtIndex:i]];
        NSArray *array=[dic objectForKey:@"item_list"];
        for (int j=0; j<[array count]; j++) {
            NSDictionary *dicitem=[array objectAtIndex:j];
            NSMutableDictionary *dicc=[[NSMutableDictionary alloc] init];
            [dicc setObject:[dic objectForKey:@"bui_id"] forKey:@"bui_id"];
            [dicc setObject:[dic objectForKey:@"bui_name"] forKey:@"bui_name"];
            [dicc setObject:[dic objectForKey:@"bui_takeout_free"] forKey:@"bui_takeout_free"];
            [dicc setObject:[dic objectForKey:@"bui_takeout_money"] forKey:@"bui_takeout_money"];
            [dicc setObject:[dic objectForKey:@"bui_takeout_ship"] forKey:@"bui_takeout_ship"];
            for (int k=0; k<[[dicitem allKeys] count]; k++) {
                if (![[[dicitem allKeys] objectAtIndex:k] isEqualToString:@"bit_num"]) {
                    [dicc setObject:[dicitem objectForKey:[[dicitem allKeys] objectAtIndex:k]] forKey:[[dicitem allKeys] objectAtIndex:k]];
                }
            }
            int ddd=[[dicitem objectForKey:@"bit_num"] intValue];
            for (int dj=0; dj<ddd; dj++) {
                [ToolObject addtocart:dicc];
            }
        }
    }
}

+(void)addtocart:(NSDictionary*)sender{
    
    NSMutableArray *arr=[ToolObject gettmpdata];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    NSMutableArray *arry=[[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    int kk=10000;
    
    for (int i=0; i<[arr count]; i++) {
        
        if ([[[arr objectAtIndex:i] objectForKey:@"bui_id"] isEqualToString:[sender objectForKey:@"bui_id"]]) {
            kk=i;
            dic=[NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
            [arry addObjectsFromArray:[dic objectForKey:@"item_list"]];
        }
    }
    
    
    
    
    
    //购物车没有添加过该商家商品
    [dic setObject:[sender objectForKey:@"bui_id"] forKey:@"bui_id"];
    if ([[sender allKeys] containsObject:@"bui_name"]) {
        [dic setObject:[sender objectForKey:@"bui_name"] forKey:@"bui_name"];
    }
    else{
        return;
        //[dic setObject:@"" forKey:@"bui_name"];
    }
    
    if ([[sender allKeys] containsObject:@"bui_takeout_free"]) {
        [dic setObject:[sender objectForKey:@"bui_takeout_free"] forKey:@"bui_takeout_free"];
    }
    else{
        [dic setObject:@"0" forKey:@"bui_takeout_free"];
    }
    [dic setObject:[sender objectForKey:@"bui_takeout_ship"] forKey:@"bui_takeout_ship"];
    [dic setObject:[sender objectForKey:@"bui_takeout_money"] forKey:@"bui_takeout_money"];
    
    //购物车已有该商家商品   对比队列中是否有同名商品，有则改变购买数量
    if ([arry count]>0) {
        int dd=1000;
        for (int i=0; i<[arry count]; i++) {
            if ([[sender objectForKey:@"bit_id"] intValue]==[[[arry objectAtIndex:i] objectForKey:@"bit_id"] intValue]) {
                dd=i;
                dict=[NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            }
        }
        
        if (dd!=1000) {
            NSString *strmun;
            
            //如果有带添加数量
            if ([[sender allKeys] containsObject:@"count"]) {
                if ([[sender objectForKey:@"count"] length]==0) {
                    strmun=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"item_num"] intValue]+1];
                }
                else{
                    strmun=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"item_num"] intValue]+[[sender objectForKey:@"count"] intValue]];
                }
            }
            else{
                strmun=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"item_num"] intValue]+1];
            }
            [dict setObject:strmun forKey:@"item_num"];
            [arry replaceObjectAtIndex:dd withObject:dict];
        }
        else {
            dict =[[NSMutableDictionary alloc] init];
            [dict setObject:[sender objectForKey:@"bit_id"] forKey:@"bit_id"];
            
            
            //如果有带添加数量
            if ([[sender allKeys] containsObject:@"count"]) {
                if ([[sender objectForKey:@"count"] length]==0) {
                    [dict setObject:@"1" forKey:@"item_num"];
                }
                else{
                    [dict setObject:[NSString stringWithFormat:@"%@",[sender objectForKey:@"count"]] forKey:@"item_num"];
                }
            }
            else{
                [dict setObject:@"1" forKey:@"item_num"];
            }
            [dict setObject:[sender objectForKey:@"bit_price"] forKey:@"bit_price"];
            [dict setObject:[sender objectForKey:@"bit_name"] forKey:@"bit_name"];
            if ([[sender allKeys] containsObject:@"bit_pack_price"]) {
                [dict setObject:[sender objectForKey:@"bit_pack_price"] forKey:@"bit_pack_price"];
            }
            else{
                [dict setObject:@"0" forKey:@"bit_pack_price"];
            }
            
            if ([[sender allKeys] containsObject:@"bit_unit"]) {
                [dict setObject:[sender objectForKey:@"bit_unit"] forKey:@"bit_unit"];
            }
            else{
                [dict setObject:@"" forKey:@"bit_unit"];
            }
            
            [dict setObject:@"1" forKey:@"have"];
            if ([[sender allKeys] containsObject:@"bit_url"]) {
                [dict setObject:[sender objectForKey:@"bit_url"]  forKey:@"bit_url"];
            }
            else{
                [dict setObject:@""  forKey:@"bit_url"];
            }
            
            if ([[sender allKeys] containsObject:@"bit_oprice"]) {
                [dict setObject:[sender objectForKey:@"bit_oprice"] forKey:@"bit_oprice"];
            }
            else{
                [dict setObject:@"0" forKey:@"bit_oprice"];
            }

            if ([[sender allKeys] containsObject:@"bit_dimg"]) {
                [dict setObject:[sender objectForKey:@"bit_dimg"] forKey:@"bit_dimg"];
            }
            else{
                [dict setObject:@"" forKey:@"bit_dimg"];
            }
            [arry addObject:dict];
        }
    }
    else{
        dict =[[NSMutableDictionary alloc] init];
        [dict setObject:[sender objectForKey:@"bit_id"] forKey:@"bit_id"];
        if ([[sender allKeys] containsObject:@"count"]) {
            if ([[sender objectForKey:@"count"] length]==0) {
                [dict setObject:@"1" forKey:@"item_num"];
            }
            else{
                [dict setObject:[NSString stringWithFormat:@"%@",[sender objectForKey:@"count"]] forKey:@"item_num"];
            }
        }
        else{
            [dict setObject:@"1" forKey:@"item_num"];
        }
        [dict setObject:[sender objectForKey:@"bit_price"] forKey:@"bit_price"];
        [dict setObject:[sender objectForKey:@"bit_name"] forKey:@"bit_name"];

        if ([[sender allKeys] containsObject:@"bit_pack_price"]) {
            [dict setObject:[sender objectForKey:@"bit_pack_price"] forKey:@"bit_pack_price"];
        }
        else{
            [dict setObject:@"0" forKey:@"bit_pack_price"];
        }
        
        if ([[sender allKeys] containsObject:@"bit_unit"]) {
            [dict setObject:[sender objectForKey:@"bit_unit"] forKey:@"bit_unit"];
        }
        else{
            [dict setObject:@"" forKey:@"bit_unit"];
        }
        
        
        if ([[sender allKeys] containsObject:@"bit_url"]) {
            [dict setObject:[sender objectForKey:@"bit_url"]  forKey:@"bit_url"];
        }
        else{
            [dict setObject:@""  forKey:@"bit_url"];
        }
        if ([[sender allKeys] containsObject:@"bit_dimg"]) {
            [dict setObject:[sender objectForKey:@"bit_dimg"] forKey:@"bit_dimg"];
        }
        else{
            [dict setObject:@"" forKey:@"bit_dimg"];
        }
        
        if ([[sender allKeys] containsObject:@"bit_oprice"]) {
            [dict setObject:[sender objectForKey:@"bit_oprice"] forKey:@"bit_oprice"];
        }
        else{
            [dict setObject:@"0" forKey:@"bit_oprice"];
        }
        [dict setObject:@"1" forKey:@"have"];
        [arry addObject:dict];
    }

    [dic setObject:arry forKey:@"item_list"];
    if (kk!=10000) {
        [arr replaceObjectAtIndex:kk withObject:dic];
    }
    else{
        [arr addObject:dic];
    }
    [PLIST setObject:arr forKey:THECART];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
    
}


+(void)repItemmum:(NSString*)bui_id item_id:(NSString*)item_id item_num:(NSInteger)item_num{
    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
        int kkk=0;
        NSMutableDictionary *dic;
        for (int i=0; i<[ARRAY count]; i++) {
            if ([[[ARRAY objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                dic=[NSMutableDictionary dictionaryWithDictionary:[ARRAY objectAtIndex:i]];
                kkk=i;
            }
        }
        
        //判断购物车中是否有该商家商品

            NSMutableArray *arritemlist=[NSMutableArray arrayWithArray:[dic objectForKey:@"item_list"]];
            int ddd=1000;
            NSMutableDictionary *dicc;
            for (int i=0; i<[arritemlist count]; i++) {
                if ([[[arritemlist objectAtIndex:i] objectForKey:@"bit_id"] intValue]==[item_id intValue]) {
                    ddd=i;
                    dicc=[NSMutableDictionary dictionaryWithDictionary:[arritemlist objectAtIndex:i]];
                }
            }

        
        
        
        if (item_num==0) {
            if ([arritemlist count]>1) {
                [arritemlist removeObjectAtIndex:ddd];
                [dic setObject:arritemlist forKey:@"item_list"];
                [ARRAY replaceObjectAtIndex:kkk withObject:dic];
            }
            else{
                [ARRAY removeObjectAtIndex:kkk];
            }
            [PLIST setObject:ARRAY forKey:THECART];
        }
        else{

            [dicc setObject:[NSString stringWithFormat:@"%d",(int)item_num] forKey:@"item_num"];
            [arritemlist replaceObjectAtIndex:ddd withObject:dicc];
            [dic setObject:arritemlist forKey:@"item_list"];
            [ARRAY replaceObjectAtIndex:kkk withObject:dic];
            [PLIST setObject:ARRAY forKey:THECART];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
        }

                
        NSLog(@"%@",[PLIST objectForKey:THECART]);

        

    }
    else{
        return;
    }
}


+(void)deleteitem:(NSString*)bui_id item_id:(NSString*)item_id{
    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
        NSMutableDictionary *dic;
        int kkk=1000;
        for (int i=0; i<[ARRAY count]; i++) {
            if ([[[ARRAY objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                kkk=i;
                dic=[NSMutableDictionary dictionaryWithDictionary:[ARRAY objectAtIndex:i]];
            }
        }
        
        //判断购物车中是否有该商家商品
        if (kkk!=1000) {
            NSMutableArray *arritemlist=[NSMutableArray arrayWithArray:[dic objectForKey:@"item_list"]];
            int ddd=1000;
            NSMutableDictionary *dicc;
            for (int i=0; i<[arritemlist count]; i++) {
                if ([[[arritemlist objectAtIndex:i] objectForKey:@"bit_id"] intValue]==[item_id intValue]) {
                    ddd=i;
                    dicc=[NSMutableDictionary dictionaryWithDictionary:[arritemlist objectAtIndex:i]];
                }
            }
            //判断购物车中是否有同名商品
            if (ddd!=1000) {
                
                //判断该商品选中数量是否为1
                if ([[dicc objectForKey:@"item_num"] intValue]==1) {
                    
                    if ([arritemlist count]>1) {
                        [arritemlist removeObjectAtIndex:ddd];
                        [dic setObject:arritemlist forKey:@"item_list"];
                        [ARRAY replaceObjectAtIndex:kkk withObject:dic];
                    }
                    else{
                        [ARRAY removeObjectAtIndex:kkk];
                    }
                    
                    [PLIST setObject:ARRAY forKey:THECART];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
                }
                else{
                    int cccc=[[dicc objectForKey:@"item_num"] intValue];
                    [dicc setObject:[NSString stringWithFormat:@"%d",cccc-1] forKey:@"item_num"];
                    [arritemlist replaceObjectAtIndex:ddd withObject:dicc];
                    [dic setObject:arritemlist forKey:@"item_list"];
                    [ARRAY replaceObjectAtIndex:kkk withObject:dic];
                    [PLIST setObject:ARRAY forKey:THECART];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
                }
                
            }
            else{
                
                return;
            }
        }
        else{
            return;
        }
    }
    else{
        return;
    }
}



+(void)deletetheitem:(NSString*)bui_id item_id:(NSString*)item_id{
    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
        NSMutableDictionary *dic;
        int kkk=1000;
        for (int i=0; i<[ARRAY count]; i++) {
            if ([[[ARRAY objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                kkk=i;
                dic=[NSMutableDictionary dictionaryWithDictionary:[ARRAY objectAtIndex:i]];
            }
        }
        
        //判断购物车中是否有该商家商品
        if (kkk!=1000) {
            NSMutableArray *arritemlist=[NSMutableArray arrayWithArray:[dic objectForKey:@"item_list"]];
            int ddd=1000;
            NSMutableDictionary *dicc;
            for (int i=0; i<[arritemlist count]; i++) {
                if ([[[arritemlist objectAtIndex:i] objectForKey:@"bit_id"] intValue]==[item_id intValue]) {
                    ddd=i;
                    dicc=[NSMutableDictionary dictionaryWithDictionary:[arritemlist objectAtIndex:i]];
                }
            }
            
            if (ddd!=1000) {

                [arritemlist removeObjectAtIndex:ddd];
                if ([arritemlist count]==0) {
                    [ARRAY removeObjectAtIndex:kkk];
                }
                else{
                    [dic setObject:arritemlist forKey:@"item_list"];
                    [ARRAY replaceObjectAtIndex:kkk withObject:dic];
                }
                [PLIST setObject:ARRAY forKey:THECART];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
            }
            else{
                return;
            }
        }
        else{
            return;
        }
    }
    else{
        return;
    }
}

+(void)addTheSameCommodity:(NSString *)bui_id item_id:(NSString *)item_id
{

    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
        NSMutableDictionary *dic;
        
        int kkk=1000;
        for (int i=0; i<[ARRAY count]; i++) {
            if ([[[ARRAY objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                kkk=i;
                dic=[NSMutableDictionary dictionaryWithDictionary:[ARRAY objectAtIndex:i]];
            }
        }

        
        if (kkk!=1000) {
            NSMutableArray *arritemlist=[NSMutableArray arrayWithArray:[dic objectForKey:@"item_list"]];
            int ddd=1000;
            NSMutableDictionary *dicc;
            for (int i=0; i<[arritemlist count]; i++) {
                if ([[[arritemlist objectAtIndex:i] objectForKey:@"bit_id"] intValue]==[item_id intValue]) {
                    ddd=i;
                    dicc=[NSMutableDictionary dictionaryWithDictionary:[arritemlist objectAtIndex:i]];
                }
            }
            
            
            if (ddd!=1000) {
                int cccc=[[dicc objectForKey:@"item_num"] intValue];
                
                
                
                [dicc setObject:[NSString stringWithFormat:@"%d",cccc+1] forKey:@"item_num"];
                [arritemlist replaceObjectAtIndex:ddd withObject:dicc];
                [dic setObject:arritemlist forKey:@"item_list"];
                [ARRAY replaceObjectAtIndex:kkk withObject:dic];
                [PLIST setObject:ARRAY forKey:THECART];
            }
            
        }

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChange" object:nil];
    
}

+(NSInteger)getitemnum:(NSString*)bui_id item_id:(NSString*)item_id{
    NSInteger dd=0;
    NSMutableArray *arr=[PLIST objectForKey:THECART];
    NSDictionary *dic;
    if (arr!=nil){
        int ddd=1000;
        for (int i=0; i<[arr count]; i++) {
            if ([[[arr objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                ddd=i;
                dic=[arr objectAtIndex:i];
            }
        }
        
        if (ddd==1000) {
            dd=0;
        }
        else{
            
            int kck=1000;
            NSArray *arry=[dic objectForKey:@"item_list"];
            for (int i=0; i<[arry count]; i++) {
                if ([item_id isEqualToString:[[arry objectAtIndex:i] objectForKey:@"bit_id"]]) {
                    kck=i;
                }
            }
            
            if (kck!=1000) {
                dd=[[[arry objectAtIndex:kck] objectForKey:@"item_num"] integerValue];
            }
            else{
                dd=0;
            }
        }
    }
    else{
        dd=0;
    }
    
    return dd;
}


+(NSInteger)getitemmumwithbui:(NSString*)bui_id{
    NSInteger dd=0;
    NSMutableArray *arr=[PLIST objectForKey:THECART];
    NSDictionary *dic;
    if (arr!=nil){
        int ddd=1000;
        for (int i=0; i<[arr count]; i++) {
            if ([[[arr objectAtIndex:i] objectForKey:@"bui_id"] intValue]==[bui_id intValue]) {
                ddd=i;
                dic=[arr objectAtIndex:i];
            }
        }
        
        if (ddd==1000) {
            dd=0;
        }
        else{
            NSArray *arry=[dic objectForKey:@"item_list"];
            for (int i=0; i<[arry count]; i++) {
                dd+=[[[arry objectAtIndex:i] objectForKey:@"item_num"] integerValue];
            }
        }
    }
    else{
        dd=0;
    }
    
    return dd;
}


+(NSMutableArray*)gettmpdata{
    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
    }
    return ARRAY;
}


+(NSInteger)getallitemmum{
    NSInteger ddd=0;
    NSMutableArray *ARRAY=[[NSMutableArray alloc] init];
    if ([PLIST objectForKey:THECART]!=nil) {
        [ARRAY addObjectsFromArray:[PLIST objectForKey:THECART]];
        for (int i=0; i<[ARRAY count]; i++) {
            NSArray *array=[[ARRAY objectAtIndex:i] objectForKey:@"item_list"];
            for (int j=0; j<[array count]; j++) {
                ddd+=[[[array objectAtIndex:j] objectForKey:@"item_num"] integerValue];
            }
        }
    }
    else{
        ddd=0;
    }
    return ddd;
}



+(NSString*)getAddressString{
    NSString *str;
    NSDictionary *dict = [PLIST objectForKey:THEADDRESS];
    
    
    
    if (dict.count > 0) {
        NSString * addressName = dict[@"pa_address"];
        
        if (addressName && ![addressName isEqualToString:@" "]&&[addressName length]!=0) {
            //dd=1;
            str = dict[@"pa_address"];
        }else{
            if ([PLIST objectForKey:THECURRENTADDRESS]!=nil) {
                if ([[[PLIST objectForKey:THECURRENTADDRESS] allKeys] containsObject:@"address"]){
                    //dd=2;
                    str=[[PLIST objectForKey:THECURRENTADDRESS] objectForKey:@"address"];
                }
                else{
                    str=@"请选择收货地址";
                }
            }
            else{
                str=@"请选择收货地址";
            }
        }
    }
    else{
        if ([PLIST objectForKey:THECURRENTADDRESS]!=nil) {
            if ([[[PLIST objectForKey:THECURRENTADDRESS] allKeys] containsObject:@"address"]){
                //dd=2;
                str=[[PLIST objectForKey:THECURRENTADDRESS] objectForKey:@"address"];
            }
            else{
                str=@"请选择收货地址";
            }
        }
        else{
            str=@"请选择收货地址";
        }
    }
 
    return str;
}

/**
 
 *
 
 * @brief: 判断文本中是否有emoij表情
 
 *
 
 * @param: string 要判断的文本
 
 *
 
 * @return BOOL值 YES有 NO没有
 
 *
 
 */
+(BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     returnValue = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 returnValue = YES;
                 
             }
             
             
             
         } else {
             
             
             
             if (0x2100 <= hs && hs <= 0x27ff) {
                 
                 returnValue = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 returnValue = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 returnValue = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 returnValue = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 
                 returnValue = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return returnValue;
    
}

//URL中带特殊字符或是中文的处理方法
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)input,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    return outputStr;
}
//百度坐标转换火星坐标（有少许误差）
+(CLLocation*)locationMarsFromBaiDu:(CLLocation*)locationDegrees
{
    
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = locationDegrees.coordinate.longitude - 0.0065, y = locationDegrees.coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double lon = z * cos(theta);
    double lat = z * sin(theta);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return location;
}
+(CLLocation*)LocationToBaiDu:(CLLocation *)locationDegrees
{
    
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = locationDegrees.coordinate.longitude;
    double y = locationDegrees.coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double  bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:bd_lat longitude:bd_lon];
    return location;
}

+(id)fromarry:(id)senderid keyid:(int)keyid{
    if ([senderid isKindOfClass:[NSArray class]]) {
        NSArray *arry=senderid;
        if([arry count]>keyid)
        {
            return [arry objectAtIndex:keyid];
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

+(id)fromdic:(id)senderid keyid:(NSString*)keyid{
    if ([senderid isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic=senderid;
        if([[dic allKeys] containsObject:keyid])
        {
            return [dic objectForKey:keyid];
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}


+(NSArray*)order:(NSArray*)sender{
    NSArray *arry=[sender sortedArrayUsingSelector:@selector(compare:)];
    return arry;
}


+(NSArray*)resetitem:(NSArray*)sender{
    NSMutableArray *nsarry=[ToolObject gettmpdata];
 
    NSMutableArray *arraylist=[[NSMutableArray alloc] init];
    
    
    for (int i=0; i<[nsarry count]; i++) {
        
        NSMutableDictionary *dicbui=[NSMutableDictionary dictionaryWithDictionary:[nsarry objectAtIndex:i]];
        NSMutableArray *aftarry=[[NSMutableArray alloc] init];
        NSMutableArray *otherarry=[[NSMutableArray alloc] init];
        NSMutableArray *arryitemlist=[NSMutableArray arrayWithArray:[dicbui objectForKey:@"item_list"]];
        for (int j=0; j<[sender count]; j++) {
            if ([[[sender objectAtIndex:j] objectForKey:@"bui_id"] isEqualToString:[dicbui objectForKey:@"bui_id"]]) {
                
                NSArray *arrylistnow=[[sender objectAtIndex:j] objectForKey:@"item_list"];

                for (int k=0; k<[arryitemlist count]; k++) {
               
                    for (int l=0; l<[arrylistnow count]; l++) {
                        if ([[[arrylistnow objectAtIndex:l] objectForKey:@"bit_id"] isEqualToString:[[arryitemlist objectAtIndex:k] objectForKey:@"bit_id"]]) {
                            [arryitemlist replaceObjectAtIndex:k withObject:[arrylistnow objectAtIndex:l]];
                            [otherarry addObject:[NSString stringWithFormat:@"%d",k]];
            
                        }
                    }

                }   
            }
        }
        
        
        for (int k=0; k<[arryitemlist count]; k++) {
            NSMutableDictionary *itemdic=[NSMutableDictionary dictionaryWithDictionary:[arryitemlist objectAtIndex:k]];
            
            NSString *have=@"0";
            for (int oo=0; oo<[otherarry count]; oo++) {
                if ([[otherarry objectAtIndex:oo] intValue]==k) {
                    have=@"1";
                }
            }
            [itemdic setObject:have forKey:@"have"];

            [aftarry addObject:itemdic];
        }
        [dicbui setObject:aftarry forKey:@"item_list"];
        [arraylist addObject:dicbui];
    }
    NSLog(@"%@",arraylist);
    [PLIST setObject:arraylist forKey:THECART];
    return (NSArray*)arraylist;
}




+(NSArray*)resettheitem:(NSArray*)sender fromarry:(NSArray*)fromarry{
    NSMutableArray *nsarry=[NSMutableArray arrayWithArray:fromarry];
    
    NSMutableArray *arraylist=[[NSMutableArray alloc] init];
    
    
    for (int i=0; i<[nsarry count]; i++) {
        
        NSMutableDictionary *dicbui=[NSMutableDictionary dictionaryWithDictionary:[nsarry objectAtIndex:i]];
        NSMutableArray *aftarry=[[NSMutableArray alloc] init];
        NSMutableArray *otherarry=[[NSMutableArray alloc] init];
        NSMutableArray *arryitemlist=[NSMutableArray arrayWithArray:[dicbui objectForKey:@"item_list"]];
        for (int j=0; j<[sender count]; j++) {
            if ([[[sender objectAtIndex:j] objectForKey:@"bui_id"] isEqualToString:[dicbui objectForKey:@"bui_id"]]) {
                
                NSArray *arrylistnow=[[sender objectAtIndex:j] objectForKey:@"item_list"];
                
                for (int k=0; k<[arryitemlist count]; k++) {
                    
                    for (int l=0; l<[arrylistnow count]; l++) {
                        if ([[[arrylistnow objectAtIndex:l] objectForKey:@"bit_id"] isEqualToString:[[arryitemlist objectAtIndex:k] objectForKey:@"bit_id"]]) {
                            [arryitemlist replaceObjectAtIndex:k withObject:[arrylistnow objectAtIndex:l]];
                            [otherarry addObject:[NSString stringWithFormat:@"%d",k]];
                            
                        }
                    }
                    
                }
            }
        }
        
        
        for (int k=0; k<[arryitemlist count]; k++) {
            NSMutableDictionary *itemdic=[NSMutableDictionary dictionaryWithDictionary:[arryitemlist objectAtIndex:k]];
            
            NSString *have=@"0";
            for (int oo=0; oo<[otherarry count]; oo++) {
                if ([[otherarry objectAtIndex:oo] intValue]==k) {
                    have=@"1";
                }
            }
            [itemdic setObject:have forKey:@"have"];
            
            [aftarry addObject:itemdic];
        }
        [dicbui setObject:aftarry forKey:@"item_list"];
        [arraylist addObject:dicbui];
    }
    NSLog(@"%@",arraylist);
    [PLIST setObject:arraylist forKey:THECART];
    return (NSArray*)arraylist;
}

//sender替换目标     fromarry购物车数组
+(NSArray*)reparray:(NSArray*)sender fromarry:(NSArray*)fromarry{
    
    NSMutableArray *nsarry=[NSMutableArray arrayWithArray:fromarry];
    
    for (int i=0; i<[nsarry count]; i++) {
        
        NSMutableDictionary *dicbui=[NSMutableDictionary dictionaryWithDictionary:[nsarry objectAtIndex:i]];
        
        NSMutableArray *aftarry=[[NSMutableArray alloc] init];

        NSMutableArray *arryitemlist=[NSMutableArray arrayWithArray:[dicbui objectForKey:@"item_list"]];

        for (int j=0; j<[sender count]; j++) {
            
            if ([[[sender objectAtIndex:j] objectForKey:@"bui_id"] isEqualToString:[dicbui objectForKey:@"bui_id"]]) {
                
                NSArray *arrylistnow=[[sender objectAtIndex:j] objectForKey:@"item_list"];
                
                for (int k=0; k<[arryitemlist count]; k++) {
                    
                    for (int l=0; l<[arrylistnow count]; l++) {
                        
                        if ([[[arrylistnow objectAtIndex:l] objectForKey:@"bit_id"] isEqualToString:[[arryitemlist objectAtIndex:k] objectForKey:@"bit_id"]]) {
                            
                            [arryitemlist replaceObjectAtIndex:k withObject:[arrylistnow objectAtIndex:l]];
                            
                        }
                    }
                }
            }
        }
        
        [dicbui setObject:aftarry forKey:@"item_list"];
        
        [nsarry replaceObjectAtIndex:i withObject:dicbui];
        
    }
    
    [PLIST setObject:nsarry forKey:THECART];
    
    return (NSArray*)nsarry;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
