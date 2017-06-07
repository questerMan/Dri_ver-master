//
//  BaseAlertView.h
//  Search_CustomAlert
//
//  Created by yan.panpan on 13-9-24.
//  Copyright (c) 2013年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BaseAlertViewDefault = 0,//默认样式，显示提示内容，可以有标题，可以没有，无图片
    BaseAlertViewMessage, //提示发送一条短信，显示短信图片
    BaseAlertViewWarn, //红色提示图片
    BaseAlertViewCommon,//绿色提示图片
    BaseAlertViewBig,//大型提示框
    BaseAlertViewLoading,
    BaseAlertViewError,
    BaseAlertViewOK
}BaseAlertViewType;

@interface BaseAlertView : UIView

/*
 @var buttonIndex == 1 对应左边按钮回调
 @var buttonIndex == 2 对应右边按钮回调
 @var 该参数不设置时，默认alert直接消失
 */
@property (nonatomic, copy) void (^callbackBlock)(NSInteger buttonIndex);//按钮点击回调

@property (nonatomic, retain) NSString *errorCode;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSArray *buttonTitleArr;//按钮标题集合
@property (nonatomic, assign) BaseAlertViewType alertType;//提示框的种类

//弹出提示框
- (void)show;

/*
 @author yanpp
 @func 初始化
 @var arr根据标题集合中元素个数，确定按钮个数
 */
- (id)initWithTitle:(NSString*)titl message:(NSString*)mess btnTitleArray:(NSArray*)arr alertType:(BaseAlertViewType)type;
- (id)initWithTitle:(NSString*)titl message:(NSString*)mess btnTitleArray:(NSArray*)arr alertType:(BaseAlertViewType)type errorCode:(NSString *)err;

//+(void)BaseAlertShow:(NSString*)message;
-(void)hideLoading;
-(void)setMessageLabelTextAlignment:(NSTextAlignment)textAlignment;


















@end
