//
//  BaseAlertView.m
//  Search_CustomAlert
//
//  Created by yan.panpan on 13-9-24.
//  Copyright (c) 2013年 llbt. All rights reserved.
//

#import "BaseAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define kMaskColor [UIColor grayColor] //遮罩颜色，目前显示为透明

#define kErrorCodeTextFont [UIFont systemFontOfSize:14.0]
#define kMessageTextFont [UIFont systemFontOfSize:18.0]
#define kMessageTextMaxFontSize 18.0
#define kMessageTextMinFontSize  5.0
#define kMessageTextColor [UIColor blackColor]
#define kTitileTextColor [UIColor whiteColor]
#define kTitleFont [UIFont boldSystemFontOfSize:13]
#define kButtonTitleFont [UIFont boldSystemFontOfSize:13]
#define kDoneButtonImage nil
#define kCancelButtonImage nil
#define kButtonHeight 45
#define kBigButtonWidth 290
#define kSmallButtonWidth 145

#define kAlertWidth 290
#define kAlertSmallHeight 151
#define kAlertBigHeight 276

#define kAlertLoadingWith 129
#define kAlertLoadingHeight 107

@interface BaseAlertView (){
    UILabel *titileLabel;//标题label
    UILabel *messageLabel;//消息label
    UILabel *errCodeLabel;//错误代码label
    UIImageView *bgView;//alert的背景，有大小之分
    UIButton *btn_1;
    UIButton *btn_2;
    UIWebView *gifWebView;
    UIImageView *loadingImgView;
}

@property (nonatomic, retain) UIWindow *m_window;
@property (nonatomic,retain)UIImageView *indicatorImgView;//左边的提示图片

//按钮点击事件
- (void)buttonClick:(UIButton*)btn;

//最终定位控件subviews的位置
- (void)locationSubviews;

@end

@implementation BaseAlertView

- (void)show {
    //用来设置遮罩颜色时使用
    UIView *maskView = [[UIView alloc]initWithFrame:_m_window.bounds];
    [maskView setBackgroundColor:kMaskColor];
    maskView.alpha=0.5;
    [_m_window addSubview:maskView];
    [maskView release];
    
    [_m_window addSubview:self];
    [_m_window makeKeyAndVisible];

    if (self.alertType!=BaseAlertViewLoading) {
    //弹出动画，目前需求不需要
    self.alpha = 0.;

    self.transform = CGAffineTransformScale(self.transform, 0.2, 0.2);
    [UIView animateWithDuration:0.17 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    } completion:^(BOOL finished){
        /*弹碰动画*/
        [UIView animateWithDuration:0.12 animations:^{
            self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
         
    }];
    }
}

/*
 @author yanpp
 @func  重新定位alert中控件得位置
 */
- (void)locationSubviews {
    
    void(^smallBGLayout)()=^{
        self.frame = CGRectMake(0, 0, kAlertWidth, kAlertSmallHeight);
        bgView.frame = self.bounds;
        bgView.image = [UIImage imageNamed:@"onebuttonalert.png"];
        
        if (btn_2) {
            UIImageView *fenGeImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fengexian.png"]];
            fenGeImgView.frame=CGRectMake(145-0.5, bgView.frame.size.height-45.5, 1, 45.5);
            [bgView addSubview:fenGeImgView];
            [fenGeImgView release];
            [btn_1 setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y+106, kSmallButtonWidth, kButtonHeight)];
            btn_1.titleLabel.font = [UIFont systemFontOfSize:25.0];
            [btn_1 setTitleColor:[UIColor colorWithRed:59.0/255.0 green:145.0/255.0 blue:202.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn_2 setFrame:CGRectMake(btn_1.frame.origin.x + kSmallButtonWidth, btn_1.frame.origin.y, kSmallButtonWidth, kButtonHeight)];
            [btn_2.titleLabel setFont:[UIFont systemFontOfSize:25.0]];
            [btn_2 setTitleColor:[UIColor colorWithRed:59.0/255.0 green:145.0/255.0 blue:202.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            bgView.image=[UIImage imageNamed:@"onebuttonalert.png"];
//            [btn_1 setBackgroundImage:[UIImage imageNamed:@"confirmbtn"] forState:UIControlStateNormal];
            [btn_1 setTitleColor:[UIColor colorWithRed:59.0/255.0 green:145.0/255.0 blue:202.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn_1 setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y+106, kBigButtonWidth, kButtonHeight)];
            [btn_1.titleLabel setFont:[UIFont systemFontOfSize:25.0]];
        }
    };
    
    //当self.message的最大行宽< 235时，需要调用此block重定位messageLabel和indicatorImgView的origin.x
    //maxWidth 为messageSize.width
    void(^narrowMessageLayout)(CGFloat maxWidth,BaseAlertViewType alertType) = ^(CGFloat maxWidth, BaseAlertViewType alertType){
        if (maxWidth >= 247) {
            return ;
        }
        //没有图片的情况
//        CGRect messageLabelFrame = messageLabel.frame;
//        CGRect indicatorViewFrame = indicatorImgView.frame;
//        if (self.alertType == BaseAlertViewDefault || self.alertType == BaseAlertViewBig) {
//            messageLabelFrame.origin.x = (kAlertWidth - maxWidth) / 2.0;
//            messageLabelFrame.size.width = maxWidth;
//            messageLabel.frame = messageLabelFrame;
//        }
        //有图片的情况
//        else{
            //首先
//            messageLabelFrame.size.width = maxWidth;
        
            //messagelable的左边和图片indicatorView右边的距离
//            CGFloat margin = messageLabelFrame.origin.x - indicatorViewFrame.origin.x - indicatorViewFrame.size.width;
//            
//            indicatorViewFrame.origin.x = (kAlertWidth - margin - messageLabelFrame.size.width - indicatorViewFrame.size.width) / 2.0;
//            indicatorImgView.frame = indicatorViewFrame;
//            
//            messageLabelFrame.origin.x = indicatorViewFrame.origin.x + margin +indicatorViewFrame.size.width;
//            messageLabel.frame = messageLabelFrame;
//        }
    };
    
    CGSize messageSize = CGSizeZero;
    
    switch (self.alertType) {
            
            //默认样式，没有提示图片
        case BaseAlertViewDefault:
        {
            smallBGLayout();
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 102.5) lineBreakMode:NSLineBreakByCharWrapping];
            messageLabel.numberOfLines = 0;
            messageLabel.frame = CGRectMake(15 + 46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
            
            //提示图片
            self.indicatorImgView.image = [UIImage imageNamed:@"oktip"];//暂时屏蔽
            self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-messageSize.width)/2.0, messageLabel.center.y - 46/2., 46, 46);
            messageLabel.frame = CGRectMake(self.indicatorImgView.frame.origin.x+46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);

            [self addSubview:self.indicatorImgView];
        }
            break;
        case BaseAlertViewOK:{
            smallBGLayout();
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
            messageLabel.numberOfLines = 0;
            if (messageSize.height>102.5) {
                messageSize=CGSizeMake(kAlertWidth -2*15 -46-10, 102.5);
                CGSize tmpSize=[self.message sizeWithFont:[UIFont systemFontOfSize:kMessageTextMinFontSize] constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                if (tmpSize.height>102.5) {
                    messageLabel.font=[UIFont systemFontOfSize:kMessageTextMinFontSize];
                }else{
                    CGFloat fontSize= [self searchForRightFontSizeForText:self.message withMinFontSize:kMessageTextMinFontSize withMaxFontSize:kMessageTextMaxFontSize withSize:messageSize];
                    messageLabel.font=[UIFont systemFontOfSize:fontSize];
                }
            }
            
            messageLabel.frame = CGRectMake(15 + 46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
            
            //提示图片
            self.indicatorImgView.image = [UIImage imageNamed:@"oktip"];//暂时屏蔽
            self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-messageSize.width)/2.0, messageLabel.center.y - 46/2., 46, 46);
            messageLabel.frame = CGRectMake(self.indicatorImgView.frame.origin.x+46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
            
            [self addSubview:self.indicatorImgView];

        }
            break;
            ////绿色提示图片
        case BaseAlertViewCommon:
        {
            smallBGLayout();
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -31 -5, 2000) lineBreakMode:NSLineBreakByCharWrapping];
            messageLabel.numberOfLines = 0;
            messageLabel.frame = CGRectMake(15 + 31 +5 , (kAlertSmallHeight -  (titileLabel.frame.size.height + titileLabel.frame.origin.y) - kButtonHeight -15 - messageSize.height)/2 + (titileLabel.frame.size.height + titileLabel.frame.origin.y) , kAlertWidth -2*15 - 31 - 5, messageSize.height);
            
            //提示图片
//            indicatorImgView.image = [UIImage imageNamed:@"alert_common"];//暂时屏蔽
            self.indicatorImgView.frame = CGRectMake(15, messageLabel.center.y - 31/2., 31, 31);
            [self addSubview:self.indicatorImgView];
        }
            break;
        case BaseAlertViewMessage:
        {
            smallBGLayout();
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -31 -5, 2000) lineBreakMode:NSLineBreakByCharWrapping];
            messageLabel.numberOfLines = 0;
            messageLabel.frame = CGRectMake(15 + 31 +5 , (kAlertSmallHeight -  (titileLabel.frame.size.height + titileLabel.frame.origin.y) - kButtonHeight -15 - messageSize.height)/2 + (titileLabel.frame.size.height + titileLabel.frame.origin.y) , kAlertWidth -2*15 - 31 - 5, messageSize.height);
            
            //提示图片
//            indicatorImgView.image = [UIImage imageNamed:@"alert_message"];//暂时屏蔽
            self.indicatorImgView.frame = CGRectMake(15, messageLabel.center.y - 31/2., 31, 31);
            [self addSubview:self.indicatorImgView];
            
        }
            break;
        case BaseAlertViewWarn:
        {
            smallBGLayout();
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
            messageLabel.numberOfLines = 0;
            if (messageSize.height>102.5) {
                messageSize=CGSizeMake(kAlertWidth -2*15 -46-10, 102.5);
              CGSize tmpSize=[self.message sizeWithFont:[UIFont systemFontOfSize:kMessageTextMinFontSize] constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                if (tmpSize.height>102.5) {
                    messageLabel.font=[UIFont systemFontOfSize:kMessageTextMinFontSize];
                }else{
                   CGFloat fontSize= [self searchForRightFontSizeForText:self.message withMinFontSize:kMessageTextMinFontSize withMaxFontSize:kMessageTextMaxFontSize withSize:messageSize];
                    messageLabel.font=[UIFont systemFontOfSize:fontSize];
                }
            }
            messageLabel.frame = CGRectMake(15 + 46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
            
            //提示图片
            self.indicatorImgView.image = [UIImage imageNamed:@"warningtip"];//暂时屏蔽
            self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-messageSize.width)/2.0, messageLabel.center.y - 46/2., 46, 46);
            messageLabel.frame = CGRectMake(self.indicatorImgView.frame.origin.x+46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
            
            [self addSubview:self.indicatorImgView];
        }
            break;
            
            //
        case BaseAlertViewBig:
        {
            self.frame = CGRectMake(0, 0, kAlertWidth, kAlertBigHeight);
            bgView.frame = self.bounds;
//            bgView.image = [UIImage imageNamed:@"alert_big"];//暂时屏蔽
            
            NSLog(@"bgView--->%@",bgView);
            
            if (btn_2) {
                [btn_1 setFrame:CGRectMake(32, kAlertBigHeight - 15 -kButtonHeight, kSmallButtonWidth, kButtonHeight)];
                btn_1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
                [btn_2 setFrame:CGRectMake(btn_1.frame.origin.x + kSmallButtonWidth +10, btn_1.frame.origin.y, kSmallButtonWidth, kButtonHeight)];
                [btn_2.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
            } else {
                [btn_1 setFrame:CGRectMake((kAlertWidth- kBigButtonWidth)/2., kAlertBigHeight - 15 -kButtonHeight, kBigButtonWidth, kButtonHeight)];
                [btn_1.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
            }
            messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(235, 2000) lineBreakMode:NSLineBreakByCharWrapping];
            messageLabel.numberOfLines = 0;
            messageLabel.frame = CGRectMake(15, (kAlertBigHeight - (titileLabel.frame.size.height + titileLabel.frame.origin.y)  - kButtonHeight -15 - messageSize.height)/2 +(titileLabel.frame.size.height + titileLabel.frame.origin.y) , kAlertWidth -2*15, messageSize.height);
        }
            break;
        case  BaseAlertViewLoading:
        {
            self.frame = CGRectMake(0, 0, kAlertLoadingWith, kAlertLoadingHeight);
            bgView.frame = self.bounds;
            bgView.image = [UIImage imageNamed:@"loadingbg.png"];
            CGSize gifSize=[UIImage imageNamed:@"loadinggif.gif"].size;
            gifWebView=[[UIWebView alloc] initWithFrame:CGRectMake(108, bgView.frame.origin.y+90, gifSize.width, gifSize.height)];
           // gifWebView=[[UIWebView alloc] initWithFrame:CGRectMake(80, bgView.frame.origin.y+85, gifSize.width, gifSize.height)];
            NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loadinggif" ofType:@"gif"]];
            gifWebView.scalesPageToFit=YES;
            gifWebView.userInteractionEnabled=NO;
            gifWebView.opaque=NO;
            [gifWebView setBackgroundColor:[UIColor clearColor]];
            [gifWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            [self addSubview:gifWebView];
            [gifWebView release];
            loadingImgView=[[UIImageView alloc] initWithFrame:CGRectMake(kAlertLoadingWith/2.0-30, 14.0, 60, 60)];
            loadingImgView.image= [UIImage imageNamed:@"loadingicon.png"];
            [self addSubview:loadingImgView];
            [loadingImgView release];
//            indicatorImgView.image = [UIImage imageNamed:@"loadingicon.png"];
//            indicatorImgView.frame=CGRectMake(-kAlertLoadingWith/2.0-30-kAlertLoadingWith/2.0, 14.0, 60, 60);
//            [self addSubview:indicatorImgView];
//            UIFont *font=[UIFont systemFontOfSize:16.0];
//            messageLabel.font=font;
            messageLabel.text=@"努力加载中";
            messageSize=[messageLabel.text sizeWithFont:kMessageTextFont];
            messageLabel.frame=CGRectMake(bgView.center.x-messageSize.width/2.0, bgView.frame.origin.y+80, messageSize.width, messageSize.height);
//            messageLabel.frame=CGRectMake(-kAlertLoadingWith-25, bgView.frame.origin.y+80, messageSize.width, messageSize.height);
            
        }
            break;
        case BaseAlertViewError:
        {
            smallBGLayout();
            if (self.errorCode) {
                messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                messageLabel.numberOfLines = 0;
                if (messageSize.height>102.5-18) {
                    messageSize=CGSizeMake(kAlertWidth -2*15 -46-10, 102.5-18);
                    CGSize tmpSize=[self.message sizeWithFont:[UIFont systemFontOfSize:kMessageTextMinFontSize] constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                    if (tmpSize.height>102.5-18) {
                        messageLabel.font=[UIFont systemFontOfSize:kMessageTextMinFontSize];
                    }else{
                        CGFloat fontSize= [self searchForRightFontSizeForText:self.message withMinFontSize:kMessageTextMinFontSize withMaxFontSize:kMessageTextMaxFontSize withSize:messageSize];
                        messageLabel.font=[UIFont systemFontOfSize:fontSize];
                    }
                }

                CGSize errSize=[self.errorCode sizeWithFont:kErrorCodeTextFont];
                UILabel *tmpErrCodeLabel=[[UILabel alloc] init];
                tmpErrCodeLabel.font=kErrorCodeTextFont;
                tmpErrCodeLabel.textAlignment=NSTextAlignmentLeft;
                tmpErrCodeLabel.textColor=[UIColor grayColor];
                tmpErrCodeLabel.text=self.errorCode;
                tmpErrCodeLabel.backgroundColor=[UIColor clearColor];
                CGFloat with=messageSize.width>errSize.width?messageSize.width:errSize.width;
                messageLabel.frame = CGRectMake(15 + 46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
                
                //提示图片
                self.indicatorImgView.image = [UIImage imageNamed:@"errortip"];//暂时屏蔽
                self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-with)/2.0, messageLabel.center.y+errSize.height/2.0 - 46/2., 46, 46);
                messageLabel.frame = CGRectMake(self.indicatorImgView.frame.origin.x+46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height-errSize.height)/2  , messageSize.width, messageSize.height);
                self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-with)/2.0, messageLabel.center.y+errSize.height/2.0 - 46/2., 46, 46);
                tmpErrCodeLabel.frame=CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y+messageLabel.frame.size.height, errSize.width, errSize.height);
                [self addSubview:tmpErrCodeLabel];
                [self addSubview:self.indicatorImgView];
                [tmpErrCodeLabel release];
            }else{
                messageSize = [self.message sizeWithFont:kMessageTextFont constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                messageLabel.numberOfLines = 0;
                if (messageSize.height>102.5) {
                    messageSize=CGSizeMake(kAlertWidth -2*15 -46-10, 102.5);
                    CGSize tmpSize=[self.message sizeWithFont:[UIFont systemFontOfSize:kMessageTextMinFontSize] constrainedToSize:CGSizeMake(kAlertWidth -2*15 -46-10, 2000) lineBreakMode:NSLineBreakByWordWrapping];
                    if (tmpSize.height>102.5) {
                        messageLabel.font=[UIFont systemFontOfSize:kMessageTextMinFontSize];
                    }else{
                        CGFloat fontSize= [self searchForRightFontSizeForText:self.message withMinFontSize:kMessageTextMinFontSize withMaxFontSize:kMessageTextMaxFontSize withSize:messageSize];
                        messageLabel.font=[UIFont systemFontOfSize:fontSize];
                    }
                }

                messageLabel.frame = CGRectMake(15 + 46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
                
                //提示图片
                self.indicatorImgView.image = [UIImage imageNamed:@"errortip"];//暂时屏蔽
                self.indicatorImgView.frame = CGRectMake((bgView.frame.size.width-46-10-messageSize.width)/2.0, messageLabel.center.y - 46/2., 46, 46);
                messageLabel.frame = CGRectMake(self.indicatorImgView.frame.origin.x+46+10 ,2.5+ (kAlertSmallHeight -  2.5 - kButtonHeight - messageSize.height)/2  , messageSize.width, messageSize.height);
                
                [self addSubview:self.indicatorImgView];
            }
            
        }
            break;

        
        default:
            break;
    }
    narrowMessageLayout(messageSize.width,self.alertType);
    messageLabel.adjustsFontSizeToFitWidth=YES;
    messageLabel.minimumFontSize=5.0;
    self.center = _m_window.center;
}

- (id)initWithTitle:(NSString*)titl message:(NSString*)mess btnTitleArray:(NSArray*)arr alertType:(BaseAlertViewType)type
{
    self = [super init];
    if (self) {
        self.title = titl;
        self.message = mess;
        self.buttonTitleArr = arr;
        self.alertType = type;
        self.frame = CGRectMake(0, 0, kAlertWidth, 1);
        _m_window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _m_window.windowLevel = UIWindowLevelStatusBar +1;
        _m_window.opaque = NO;
       
        bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 293.0,1)];
        [self addSubview:bgView];
        
        //titleLabel,位置在alert中的确定的
        titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kAlertWidth, 20)];
        //假如没有标题
        [titileLabel setBackgroundColor:[UIColor clearColor]];
        if (!self.title || [self.title length] == 0) {
            titileLabel.frame = CGRectZero;
        }
        NSLog(@"titileLabel.frame----->>%@",NSStringFromCGRect(titileLabel.frame));
        titileLabel.font = kTitleFont;
#ifdef __IPHONE_6_0
        titileLabel.textAlignment = NSTextAlignmentCenter;
#else
        titileLabel.textAlignment = UITextAlignmentCenter;
#endif
        titileLabel.textColor = kTitileTextColor;
        titileLabel.text = _title;
        [self addSubview:titileLabel];
        
        //messageTitle，在alert中位置有可能变化
        messageLabel = [[UILabel alloc]init];
        messageLabel.font = kMessageTextFont;
        messageLabel.textColor = kMessageTextColor;
        messageLabel.text = _message;
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:messageLabel];
        
        //indicatorImgView，有可能有有可能没有，但是位置固定
        self.indicatorImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 46, 46)] autorelease];
        
        
        //放置按钮
        switch ([_buttonTitleArr count]) {
            case 1:
            {
                btn_1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
                [btn_1 setTitle:[_buttonTitleArr objectAtIndex:0] forState:UIControlStateNormal];
                btn_1.tag = 1;
//                [btn_1 setBackgroundImage:[UIImage imageNamed:@"alert_bigBTN"] forState:UIControlStateNormal];//暂时屏蔽
                [btn_1 setFrame:CGRectMake(0, 0, kBigButtonWidth, kButtonHeight)];
                [btn_1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn_1];
            }
                break;
            case 2:
            {
                btn_1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
                [btn_1 setTitle:[_buttonTitleArr objectAtIndex:0] forState:UIControlStateNormal];
                btn_1.tag = 1;
//                [btn_1 setBackgroundImage:[UIImage imageNamed:@"cancelbtn.png"] forState:UIControlStateNormal];
                [btn_1 setFrame:CGRectMake(0, 0, kSmallButtonWidth, kButtonHeight)];
                [btn_1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn_1];
                
                btn_2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
                [btn_2 setTitle:[_buttonTitleArr objectAtIndex:1] forState:UIControlStateNormal];
//                [btn_2 setBackgroundImage:[UIImage imageNamed:@"confirmbtn.png"] forState:UIControlStateNormal];
                [btn_2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_2.tag = 2;
                [self addSubview:btn_2];
            }
                break;
            default:
                break;
        }
    }
    [self locationSubviews];
    return self;
}

- (id)initWithTitle:(NSString*)titl message:(NSString*)mess btnTitleArray:(NSArray*)arr alertType:(BaseAlertViewType)type errorCode:(NSString *)err{
    self.errorCode=err;
    self=[self initWithTitle:titl message:mess btnTitleArray:arr alertType:type];

    
 
    return self;
}

- (void)buttonClick:(UIButton*)btn{
    if (_callbackBlock) {
        switch (btn.tag) {
            case 1:
            {
                _callbackBlock(1);
                
                //强制更新时不关闭弹出框
                if ([btn.titleLabel.text compare: @"需更新"] == NSOrderedSame)
                {
                    return;
                }
            }
                break;
            case 2:
            {
                _callbackBlock(2);
            }
                break;
            default:
                break;
        }
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        //消失动画，目前需求不需要
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.m_window = nil;
        [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    }];
    
}
-(void)hideLoading{
    self.alpha = 0.0f;
    self.m_window = nil;
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}

-(void)setMessageLabelTextAlignment:(NSTextAlignment)textAlignment{
    messageLabel.textAlignment=textAlignment;
}

- (CGFloat)binarySearchForFontSizeForText:(NSString *)text withMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize withSize:(CGSize)size
{
    // If the sizes are incorrect, return 0, or error, or an assertion.
    if (maxFontSize < minFontSize)
        return 0;
    
    // Find the middle
    CGFloat fontSize = (minFontSize + maxFontSize) / 2;
    // Create the font
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // Create a constraint size with max height
    CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
    // Find label size for current font size
    CGSize labelSize = [text sizeWithFont:font
                        constrainedToSize:constraintSize
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    // EDIT:  The next block is modified from the original answer posted in SO to consider the width in the decision. This works much better for certain labels that are too thin and were giving bad results.
    if( labelSize.height >= (size.height-10) && labelSize.width >= (size.width - 10) && labelSize.height <= (size.height) && labelSize.width <= (size.width) ) {
        //NSLog(@"'%@' LabelSize: (%f x %f) Font imprint: (%f x %f)", text, labelSize.width, labelSize.height, size.width, size.height);
        return fontSize;
    } else if( labelSize.height > size.height || labelSize.width > size.width)
        return [self binarySearchForFontSizeForText:text withMinFontSize:minFontSize withMaxFontSize:fontSize-1.0 withSize:size];
    else
        return [self binarySearchForFontSizeForText:text withMinFontSize:fontSize+1.0 withMaxFontSize:maxFontSize withSize:size];
}

-(CGFloat)searchForRightFontSizeForText:(NSString *)text withMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize withSize:(CGSize)size{
    CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
    UIFont *font;
    CGSize labelSize;
    for (int i=maxFontSize; i>minFontSize; i--) {
        font = [UIFont systemFontOfSize:i];
        labelSize = [text sizeWithFont:font
                     constrainedToSize:constraintSize
                         lineBreakMode:NSLineBreakByWordWrapping];
        if (labelSize.height<=size.height) {
            return i;
        }
    }
    return minFontSize;
}

#pragma mark Cocoa Origin Methods

- (void)dealloc {
    [titileLabel release];
    titileLabel = nil;
    [messageLabel release];
    messageLabel = nil;
    
//    [indicatorImgView release];
//    indicatorImgView = nil;
    [_indicatorImgView release];
    [btn_1 release];
    btn_1 = nil;
    [btn_2 release];
    btn_2 = nil;
    [bgView release];
    bgView = nil;
    self.m_window = nil;
    self.title = nil;
    self.errorCode=nil;
    self.message = nil;
    self.buttonTitleArr = nil;
    self.callbackBlock = nil;
    [super dealloc];
}


@end
