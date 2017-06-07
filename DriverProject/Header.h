//
//  Header.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#ifndef DriverProject_Header_h
#define DriverProject_Header_h


#endif



#define PLIST [NSUserDefaults standardUserDefaults]



//  常见属性的设置
#define TEXTFIELD_HEIGHT                44
#define TABLEVIEWCELL_HEIGHT            44
#define CORNER_RADIUS                   4

#define FF                              0.5           //  大小与像素比例

//  定义UI部件之间的距离
#define GAP2                            2
#define GAP4                            4
#define GAP8                            8
#define GAP16                           16
#define GAP20                           20
#define GAP32                           32

//  定义字体大小
#define FONT8                           8
#define FONT10                          10
#define FONT12                          12
#define FONT14                          14
#define FONT16                          16

//  一些公用图片
#define RIGHT_ARROW_IMAGE               @"right_arrow.png"
#define ROUND_CIRCLE_IMAGE              @"round_circle.png"
#define CIRCLE_ARROW_IMAGE              @"circle_arrow.png"
#define RIGHT_STANDARD_IMAGE            @"right_standard_arrow.png"

//  状态图片
#define IMAGE_WAIT                  [UIImage imageNamed:@"engage_wait.png"]
#define IMAGE_SUCCESS               [UIImage imageNamed:@"engage_success.png"]
#define IMAGE_SUCCESS_EXPIRE        [UIImage imageNamed:@"engage_success_expire.png"]
#define IMAGE_CANCEL                [UIImage imageNamed:@"engage_cancel.png"]
#define IMAGE_FAIL                  [UIImage imageNamed:@"engaga_fail.png"]
/*!
 将存放在NSUserDefaults中
 */
//  判断是否第一次运行
#define NOT_FIRST_RUN                   @"notFirstRun"

//  存放用户信息
#define PASSWORD                        @"password"
#define LOGIN_SUCCESS                   @"login_success"
#define LOGOUT_NOW                      @"logout_now"

//  存放个人信息(UD -- userDefault)
#define UD_NICK_NAME                    @"nickname"
#define UD_SEX                          @"sex"
#define UD_PORTRAIT                     @"portrait"
#define IF_TEST                         @"2"
//  >>> 暂时没用上
//  存储UI信息
#define NAVIGATIONBAR_HEIGHT            @"navigationbar_height"             //  导航栏高度
#define STATUS_NAVIGATIONBAR_HEIGHT     @"status_navigationbar_height"                //
#define TABBAR_HEIGHT                   @"tabbar_height"                    //  TabBar栏高度
#define STATUSBAR_HEIGHT                @"statusbar_height"                 //  顶部状态栏高度


//  存储UI信息（用于矩阵字典中）     在矩阵字典中使用后面部分
#define NAVBAR_H                        @"navbar_H"
#define STATUS_NAV_BAR_H                @"status_nav_bar_H"
#define TABBAR_H                        @"tabbar_H"
#define STATUSBAR_H                     @"statusbar_H"


/*!
 将存放在字典中
 */
//  用于json解析

#define GET_USER_INFO                   @"get_user_info"
#define GET_BUI_INFO                    @"get_bui_info"


//  “我的定一定” 现在 数据
#define Kindent_now_list            @"indent_now_list_path.xml"
























#define Search_User @"m.php/user/search"

#define PLIST [NSUserDefaults standardUserDefaults]
#define SVPERROR [SVProgressHUD showErrorWithStatus:@"对不起！出了点小错，工程师正在玩命修复。"];
#define SVPERRORDET [SVProgressHUD showErrorWithStatus:[result objectForKey:@"M"]];
#define KEY_ACTIVITY_LAST_TIME          @"ACTIVITY_LAST_TIME"
#define THEUSERNAME                     @"user_name"
#define THEPASSWORD                     @"pass_word"
#define THEUDID                         @"phone_udid"
#define THE_NEEDPASSWORD                @"net_password"
#define BTHEUSERNAME                    @"buser_name"
#define BTHEPASSWORD                    @"bpass_word"
#define TOKENKEY                        @"tokenkey"
#define BTOKENKEY                       @"btokenkey"
#define MEMBERINFO                      @"ismember"
#define HAVETABBAR                      @"1"
#define HAVENOTTABBAR                   @"0"
#define LASTPHONENUMBER                 @"lastPhoneNumber"

#define ADDRESS_UPDATE                  @"addr_update"
#define ENVIRONMENT                     @"ENVIRONMENT"           //1是正式服   2是测试服
//1是个人版  2代表企业版本
#define PERSON_YES                      1


#define SEVER_API                       @"http://driver.api.gaclixin.com"
#define SEVER_TEST                      @"http://192.168.0.103/gac_lixin/api/driver/v1/index.php"


#define BUS_LOGIN                       @"BUSLOGIN"
#define API_VERISION_NUM                @"30"
#define API_VERISION                    [NSString stringWithFormat:@"V=%@",API_VERISION_NUM]
#define GET_NEEDPASSWORD                [[PLIST objectForKey:THE_NEEDPASSWORD] intValue]
#define THE_BUSNOREAD                   [NSString stringWithFormat:@"%@_busnoread%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define THE_USERNOREAD                  [NSString stringWithFormat:@"%@_usernoread%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]

#define THECART                         [NSString stringWithFormat:@"%@cart%@_",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define THEADDRESS                      [NSString stringWithFormat:@"%@_myaddress%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//当前位置
#define THECURRENTADDRESS               [NSString stringWithFormat:@"%@_mycurrentaddress%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//所选择城市
#define THESELECTCITY                   [NSString stringWithFormat:@"_selectcity"]
//启动应用的首次
#define THEFIRSTOPENAPP                 [NSString stringWithFormat:@"THEFIRSTOPENAPP"]
#define THEFIRSTLOC                     [NSString stringWithFormat:@"%@_firstloc%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_NAME                  [NSString stringWithFormat:@"%@_backcardname%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_TYPE                  [NSString stringWithFormat:@"%@_backcardtype%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_NUM                   [NSString stringWithFormat:@"%@_backcardNum%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define SHOWSHARE                       [NSString stringWithFormat:@"%@showshare%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//最后弹出商家详情页
#define LASTTIME                        [NSString stringWithFormat:@"%@lasttime%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//最后弹出网络激活成功的文字
#define LASTONLINETIME                  [NSString stringWithFormat:@"%@lastonlinetime%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define LASTLCACTION                    [NSString stringWithFormat:@"%@LASTLCACTION%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define ROOM                            [NSString stringWithFormat:@"%@ROOM%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define RoutersBus                      [NSString stringWithFormat:@"%@RoutersBus%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define HAVEMESSAGE                     [NSString stringWithFormat:@"%@HAVEMESSAGE%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define FIRSTOPEN                       [NSString stringWithFormat:@"%@FIRSTOPEN%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]

//人均水平缓存值
#define RG                              [NSString stringWithFormat:@"%@RG%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//急送分类缓存值
#define KW                              [NSString stringWithFormat:@"%@KW%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//距离分类缓存值
#define FL                              [NSString stringWithFormat:@"%@FL%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define TAKEOUTFL                       [NSString stringWithFormat:@"%@TAKEOUTFL%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TAKEOUTRG                       [NSString stringWithFormat:@"%@TAKEOUTRG%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TAKEOUTKW                       [NSString stringWithFormat:@"%@TAKEOUTKW%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define ThemeColor                      [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stye" ofType:@"plist"]] objectForKey:@"ThemeColor"]


#define ONLINESTATUS                    @"ONLINESTATUS"
#define SERVERMAC                       @"SERVERMAC"
#define SERVERWAN                       @"SERVERWAN"
#define SERVERLAN                       @"SERVERLAN"
#define THESERVERIP                     @"THESERVER_IP"
#define BID                             @"THE_BID"
#define BKEY                            @"THE_KEY"
#define MYIPHONEMAC                     @"THE_IPHONE_MAC"
#define GETDAGAERROR                    @"GETDAGAERROR"
#define HOMEPAGEKEY                     [NSString stringWithFormat:@"%@HOMEPAGEKEY%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TYPETD                          @"TYPETD"
#define TYPELK                          @"TYPELK"
#define THEMONEY                        @"THEMONEY"
#define BUSDATA                         @"BUSDATA"
#define MOBCHECK                        @"MOBCHECK"
#define CANSHARE                        @"CANSHARE"
//定位成功，位置发生改变
#define LOACSUCCE                       @"LOACSUCCE"
//定位失败
#define LOACFAIL                        @"LOACFAIL"
//定位成功，位置未发生改变
#define LOACSUCCENOCHANCE               @"LOACSUCCE"
//是否切换位置
#define CHANCELOACSUCCENO               @"CHANCELOACSUCCENO"
//是否开启定位
#define LOACON                          @"LOACON"


#define CUSTOM_STATE_HEIGHT               20                   //  状态栏的高度
#define CUSTOM_NAV_HEIGHT               (44+20)                   //  导航栏的高度
#define CUSTOM_TAB_TO_DELETE            110                  // tableView的高度需要减去的值

#define WX_SHARE_SUCCESS                @"WeiXinShareSuccess"
#define WX_SHARE_FAILED                 @"WeiXinShareFailed"
#define SINA_WEIBO_SHARE_SUCCESS        @"SinaWeiboShareSuccess"
#define SINA_WEIBO_SHARE_FAILED         @"SinaWeiboShareFailed "
#define hWX_SHARE_SUCCESS               @"hWeiXinShareSuccess"
#define hWX_SHARE_FAILED                @"hWeiXinShareFailed"
#define hSINA_WEIBO_SHARE_SUCCESS       @"hSinaWeiboShareSuccess"
#define hSINA_WEIBO_SHARE_FAILED        @"hSinaWeiboShareFailed "
#define WIFICHACE                       @"WIFICHACE"
#define GETMACFAIL                      @"GETMACFAIL"
#define GETMACSUCCESS                   @"GETMACSUCCESS"
#define BUI_ID_CHANGE                   @"ChangeStoreId"
#define GET_COUPON                      @"getCoupon"
#define NEED_RELOAD                     @"needReload"
#define WEB_RELOAD                      @"webReload"
#define LOADNEWWEB                      @"loadnewweb"
#define STOREHOME                       @"storeHome"


#define TransfomXY(A)  (A/2)
#define TransfomFont(A)  (A/2)



#define factors_value      3

#define FONT_SIZE_0   （100/factors_value）
#define FONT_SIZE_1   （74/factors_value）

#define FONT_SIZE_2   （56/factors_value)

#define FONT_SIZE_3   （48/factors_value)
#define FONT_SIZE_4   （40/factors_value）

#define FONT_SIZE_5   （34/factors_value）
#define FONT_SIZE_6   （30/factors_value）
#define FONT_SIZE_7   （28/factors_value）





//大
#define FONT_SIZE_BIG_1            22
#define FONT_SIZE_BIG_2            20
#define FONT_SIZE_BIG_3            18
#define FONT_SIZE_BIG_4            16

//中
#define FONT_SIZE_MID_1            15
#define FONT_SIZE_MID_2            14

//小
#define FONT_SIZE_SMALL_1          13
#define FONT_SIZE_SMALL_2          12


//get_address
//refusal


#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height



//展开文字和压缩文字高度差
#define KAddHeight  self.currentHeight - self.initHeight
#define KInitStoreInfoHeight 95
#define KStoreInfoHeightAndConnectViewHeight 95+40

#define KConnectionViewHeight 40



//////////////////////////////////////////////////////
//记录当前cell是否是展开状态
//static BOOL isUnfold;

#define kSectionButtonHeight 35
#define KStoreImageWidth 87
#define KAddressTitleWidth 45
//#define KAddressContentWidth KScreenWidth-(_storeImage.frame.size.width+14)-20-45
#define KAddressContentWidth KScreenWidth-166

#define KConnectionViewHeight 40
#define KDishesCellHeight 60


//  成功、确认中、待支付、已到店、已取消、失败
#define XS_IMAGE_SUCCESS               [UIImage imageNamed:@"成功.png"]
#define XS_IMAGE_CONFIRMING            [UIImage imageNamed:@"确认中.png"]
#define XS_IMAGE_NEEDS_PAY             [UIImage imageNamed:@"待支付.png"]
#define XS_IMAGE_REACHED               [UIImage imageNamed:@"已到店.png"]
#define XS_IMAGE_CANCELED              [UIImage imageNamed:@"已取消.png"]
#define XS_IMAGE_FAIL                  [UIImage imageNamed:@"失败.png"]

#define AUTH_KEY    @"c84999f738ec6b"//密码加密KEY


#define FONT(x)                         [UIFont systemFontOfSize:x]
#define DEFAULTS                        [NSUserDefaults standardUserDefaults]
#define SCREEN_H                        [UIScreen mainScreen].bounds.size.height
#define SCREEN_W                        [UIScreen mainScreen].bounds.size.width
#define ViewBounds                      self.view.bounds.size.height

#define DEAD_ERROR                      @"对不起！出了点小错，工程师真在玩命修复！";









/////++++++++++++++++++++++++++
//NavBar高度
#define NavigationBar_HEIGHT 44


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]




//判断当前设备是不是iphone5
#define kScreenIphone5    (([[UIScreen mainScreen] bounds].size.height)>=568)

//获取当前屏幕的高度
#define kMainScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)

//获取当前屏幕的宽度
#define kMainScreenWidth  ([UIScreen mainScreen].applicationFrame.size.width)


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define FRAME(A,B,C,D)                      CGRectMake(A,B,C,D)



//颜色
//主蓝色
#define Main_COLOR                 [UIColor colorWithRed:(float)0x3a/255 green:(float)0xb4/255 blue:(float)0x8f/255 alpha:1]

//普通文字 黑色
#define Textblack_COLOR                 [UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:1]

//减淡文字 黑色
#define Textgray_COLOR                 [UIColor colorWithRed:(float)0x72/255 green:(float)0x72/255 blue:(float)0x72/255 alpha:1]

//禁用文字 提示文字 黑色
#define TextDisable_COLOR                 [UIColor colorWithRed:(float)0xb6/255 green:(float)0xb6/255 blue:(float)0xb6/255 alpha:1]

//分割线 黑色
#define Dividingline_COLOR                 [UIColor colorWithRed:(float)0xd8/255 green:(float)0xd8/255 blue:(float)0xd8/255 alpha:1]

//底色
#define Background_COLOR                 [UIColor colorWithRed:(float)0xfa/255 green:(float)0xfa/255 blue:(float)0xfa/255 alpha:1]


//高亮文字 图标 橙色
#define Assist_COLOR                 [UIColor colorWithRed:(float)0xf4/255 green:(float)0x94/255 blue:(float)0x2d/255 alpha:1]


//普通文字 白色
#define Textwhite_COLOR                 [UIColor colorWithRed:(float)0xff/255 green:(float)0xff/255 blue:(float)0xff/255 alpha:1]

//减淡文字 白色
#define Textlightwhite_COLOR                 [UIColor colorWithRed:(float)0xfc/255 green:(float)0xfc/255 blue:(float)0xfc/255 alpha:1]

//禁用文字 提示文字 白色
#define TextwhiteDisable_COLOR                 [UIColor colorWithRed:(float)0xf9/255 green:(float)0xf9/255 blue:(float)0xf9/255 alpha:1]

//分割线 白色
#define whiteDividingline_COLOR                 [UIColor colorWithRed:(float)0xf9/255 green:(float)0xf9/255 blue:(float)0xf9/255 alpha:1]

//辅色 蓝色
#define AssistMain_COLOR                 [UIColor colorWithRed:(float)0x0e/255 green:(float)0x8b/255 blue:(float)0x65/255 alpha:1]

//线的高度
#define LINE_HEIGHT   (1.0f/[[UIScreen mainScreen]scale])



#define Textblack_COLOR2                 [UIColor colorWithRed:(float)0x00/255 green:(float)0x00/255 blue:(float)0x00/255 alpha:1]

#define Textblack_COLOR3                 [UIColor colorWithRed:(float)0x46/255 green:(float)0x46/255 blue:(float)0x46/255 alpha:1]
#define Textblack_COLOR4                 [UIColor colorWithRed:(float)0x66/255 green:(float)0x66/255 blue:(float)0x66/255 alpha:1]
