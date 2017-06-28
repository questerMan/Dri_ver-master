//
//  LoginViewController.m
//  DriverProject
//
//  Created by zyx on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MyMessage.h"
#import "UIColor+Hex.h"

#define MATCHSIZE(px) ([@"iPad" isEqualToString:[[UIDevice currentDevice] model]]? px*(SCREEN_W/750) : (SCREEN_W == 414)? px*414/750.0 : (SCREEN_W == 375)? px*0.5 : px*320/750.0)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithHexString:rgbValue alpha:1.0]
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#import "ForgetPasswordVC.h"


#define  LEFT_SPACING   20
#define  RINGT_SPACING   20

@interface LoginViewController ()
{
    UIScrollView *_scrollView;
    UITextField *_userNameField;
    UITextField *_passwordField;
    UIButton *_forgetpassword;
    UIButton *_loginBtn;
}
//@property(nonatomic,strong)UIScrollView *_scrollView;
//@property(nonatomic,strong)  UITextField *_userNameField;
//@property(nonatomic,strong)UITextField *_passwordField;

@property(nonatomic,assign)NSInteger flag;


@end


@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor=Main_COLOR;
    UIImageView *imageViewBG =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_login"]];
    [self.view addSubview:imageViewBG];
    
    [imageViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    [self initField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    // 设置键盘通知或者手势控制键盘消失
    [self KeyboardMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)initField
{
    
    _flag=0;
    
    _scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.scrollEnabled=YES;
    _scrollView.contentSize=CGSizeMake(SCREEN_W, SCREEN_H);
    [self.view addSubview:_scrollView];
    
    [self addPhoneField:_userNameField ToView:_scrollView withTitle:@"请输入手机号码" andTitleYoffset:230 isPassword:NO];
    [self addTextField:_passwordField ToView:_scrollView withTitle:@"请输入登录密码" andTitleYoffset:(230+46) isPassword:YES];
    _userNameField.keyboardType=UIKeyboardTypeDecimalPad;
    
    [self AddImageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyboardType)];
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
    
    [self addForgetpassword];
    
    [self AddButton];
    
}

-(void)addForgetpassword{
    UIButton *forgetpassword=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetpassword.titleLabel.font=[UIFont systemFontOfSize:MATCHSIZE(26)];
    [forgetpassword setTitleColor:UIColorFromRGB(@"#3ab48f") forState:UIControlStateNormal];
    [forgetpassword setTitle:@"登录遇到问题？" forState:UIControlStateNormal];
    [forgetpassword addTarget:self action:@selector(forgetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:forgetpassword];
    forgetpassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _forgetpassword = forgetpassword;
    [forgetpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(SCREEN_W/2 - MATCHSIZE(490)/2);
        make.top.equalTo(_passwordField.mas_bottom).offset(MATCHSIZE(20));
        make.height.offset(MATCHSIZE(30));
        make.width.offset(MATCHSIZE(200));
    }];
}

-(void)AddImageView
{
    UIImageView *loginImage=[[UIImageView alloc]init];
    loginImage.image=[UIImage imageNamed:@"logo"];
    //[loginImage sizeToFit];
    loginImage.size=CGSizeMake(147,102);
    loginImage.center=CGPointMake(_scrollView.center.x, 130);
    [_scrollView addSubview:loginImage];
    
    
    //    UILabel* APPName=[[UILabel alloc]initWithFrame:CGRectZero];
    //    APPName.text=@"丽新司机";
    //    APPName.textColor=Textwhite_COLOR;
    //    APPName.textAlignment=NSTextAlignmentLeft;
    //    APPName.font=[UIFont systemFontOfSize:20];
    //    [_scrollView addSubview:APPName];
    //    [APPName sizeToFit];
    //    APPName.center=CGPointMake(_scrollView.center.x, 130);;
    //    APPName.top=loginImage.bottom+5;
    
    
}

-(void)addPhoneField:(UITextField *)textField ToView:(UIView *)mainView withTitle:(NSString *)title andTitleYoffset:(CGFloat)y_offset isPassword:(BOOL)isPassword{
    //42
    UIImageView *FieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2,y_offset+10 , 20, 20)];
    FieldImageView.backgroundColor=[UIColor clearColor];
    FieldImageView.image=[UIImage imageNamed:@"user"];
    [mainView addSubview:FieldImageView];
    
    _userNameField=[[UITextField alloc] init];
    _userNameField.backgroundColor=[UIColor clearColor];
    _userNameField.borderStyle=UITextBorderStyleNone;
    _userNameField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _userNameField.textAlignment=NSTextAlignmentCenter;
    _userNameField.delegate=self;
    _userNameField.placeholder=title;
    _userNameField.textColor=UIColorFromRGB(@"#3ab48f");
    _userNameField.tintColor = UIColorFromRGB(@"#3ab48f");
    _userNameField.font=[UIFont systemFontOfSize:14];
    [_userNameField setValue:UIColorFromRGB(@"#3ab48f") forKeyPath:@"_placeholderLabel.textColor"];
    _userNameField.keyboardType=UIKeyboardTypeDecimalPad;
    _userNameField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _userNameField.secureTextEntry=isPassword;
    _userNameField.frame=CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2 +20,y_offset ,MATCHSIZE(490)-20, 46);
    [mainView addSubview:_userNameField];
    //SCREEN_W/2 - MATCHSIZE(490)/2,_passwordField.bottom ,MATCHSIZE(490), LINE_HEIGHT
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2,_userNameField.bottom ,MATCHSIZE(490), LINE_HEIGHT)];
    lineView.backgroundColor = UIColorFromRGB(@"#3ab48f");
    [mainView addSubview:lineView];
}

-(void)addTextField:(UITextField *)textField ToView:(UIView *)mainView withTitle:(NSString *)title andTitleYoffset:(CGFloat)y_offset isPassword:(BOOL)isPassword{
    //42
    UIImageView *FieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2,y_offset+MATCHSIZE(50)+12 , 20, 20)];
    FieldImageView.backgroundColor=[UIColor clearColor];
    FieldImageView.image=[UIImage imageNamed:@"password"];
    [mainView addSubview:FieldImageView];
    
    
    
    _passwordField=[[UITextField alloc] init];
    _passwordField.backgroundColor=[UIColor clearColor];
    _passwordField.borderStyle=UITextBorderStyleNone;
    _passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordField.textAlignment=NSTextAlignmentCenter;
    _passwordField.delegate=self;
    _passwordField.placeholder=title;
    _passwordField.textColor=UIColorFromRGB(@"#3ab48f");
    _passwordField.tintColor = UIColorFromRGB(@"#3ab48f");
    [_passwordField setValue:UIColorFromRGB(@"#3ab48f") forKeyPath:@"_placeholderLabel.textColor"];
    _passwordField.font=[UIFont systemFontOfSize:14];
    _passwordField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passwordField.secureTextEntry=isPassword;
    _passwordField.frame=CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2 +20,y_offset+MATCHSIZE(50) ,MATCHSIZE(490)-20, 46);
    [mainView addSubview:_passwordField];
    
    
    //SCREEN_W/2 - MATCHSIZE(490)/2,_passwordField.bottom ,MATCHSIZE(490), LINE_HEIGHT
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - MATCHSIZE(490)/2,_passwordField.bottom ,MATCHSIZE(490), LINE_HEIGHT)];
    lineView.backgroundColor = UIColorFromRGB(@"#3ab48f");
    [mainView addSubview:lineView];

}

-(void)AddButton
{
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = MATCHSIZE(35);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginBtn setTitleColor:UIColorFromRGB(@"#3ab48f") forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    loginBtn.layer.borderWidth = MATCHSIZE(2);
    loginBtn.layer.borderColor = UIColorFromRGB(@"#3ab48f").CGColor;
    loginBtn.layer.masksToBounds = YES;
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:UIColorFromRGB(@"#ffffff") forState:UIControlStateHighlighted];
    
    [_scrollView addSubview:loginBtn];
    
    //    UIImage *loginBg=[UIImage imageNamed:@"button_ok_yellow.png"];
    //    loginBg=[loginBg stretchableImageWithLeftCapWidth:(loginBg.size.width*0.5f) topCapHeight:(loginBg.size.height*0.5f)];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_forgetpassword.mas_bottom).offset(MATCHSIZE(80));
        make.height.offset(MATCHSIZE(70));
        make.width.offset(MATCHSIZE(392));
    }];
    _loginBtn = loginBtn;
    
}

#pragma mark 键盘事件
-(void)KeyboardMessage
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)keyboardWillShow:(NSNotification *)Notification
{
    NSDictionary *userInfo=[Notification userInfo];
    NSValue *aValue=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    int height=keyboardRect.size.height;
    //********************
    NSLog(@"键盘高度为:%d",height);
    
    [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    if(IOS7_OR_LATER)
    {
        [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)Notification
{
    NSDictionary *userInfo=[Notification userInfo];
    NSValue *aValue=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    int height=keyboardRect.size.height;
    //********************
    NSLog(@"键盘高度为:%d",height);
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)hidekeyboardType
{
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
}


#pragma mark 登录
-(void)loginBtnPressed{
    NSLog(@"按下登录按钮");
    
    NSString *userName=_userNameField.text;
    NSString *password=_passwordField.text;
    if ([userName length]==0) {
        //        [self showWarningMessage:@"请输入用户名。"];
        [_userNameField becomeFirstResponder];
        return;
    }
    //    if ([userName length]<6) {
    //        [self showWarningMessage:@"用户名应为6-20位的数字或字母。"];
    //        return;
    //    }
    if ([password length]==0) {
        //        [self showWarningMessage:@"请输入密码。"];
        [_passwordField becomeFirstResponder];
        return;
    }
    //    if ([password length]<6) {
    //        [self showWarningMessage:@"密码应为6-10位的数字或字母。"];
    //        return;
    //    }
    
    [self hidekeyboardType];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade postLogon:_userNameField.text password:_passwordField.text];
    [facade addHttpObserver:self tag:_flag];
    
}


-(void)forgetBtnPressed
{
    
    ForgetPasswordVC *forgetPasswordVC=[[ForgetPasswordVC alloc] init];
    //[self presentModalViewController:forgetPasswordVC animated:YES];
    [self presentViewController:forgetPasswordVC animated:YES completion:nil];
    
    
    
    //    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    //        [self presentViewController:aSelect animated:YES completion:nil]; // ios 5 and 以上
    //    }else{
    //        [self presentModalViewController:aSelect animated:YES]; // ios 4 and 以下
    //    }
    
}





-(void)registerBtnPressed{
    NSLog(@"按下注册按钮");
    
}

//-(void)showWarningMessage:(NSString *)message{
//    NSArray *BtnTitleArr = @[@"确定"];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",message]  delegate:nil cancelButtonTitle:[BtnTitleArr objectAtIndex:0] otherButtonTitles:nil, nil];
//    [alert show];
//
//
//}

#pragma mark **************UITextField***************
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    if (textField==_userNameField) {
        //输入格式化
        if (text.length>20) {
            return NO;
        }
        
    }
    if (textField==_passwordField) {
        //密码10位数限制
        
        if (text.length > 10)
            return NO;
    }
    
    if ([string isEqualToString:@"\n"])
    {
        // 回车键，关闭键盘
        [_userNameField resignFirstResponder];
        [_passwordField resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (void)textFieldBegin:(UITextField *)textField{
    if (textField==_userNameField) { //增加下拉用户列表，如果不需要用户列表直接屏蔽本行代码即可
    }
    //[_scrollView adjustOffsetToNewOffset:textField];
    
}
-(void)adjustOffsetToNewOffset:(UITextField *)textField{
    float animateDuration=0;
    if (animateDuration==0) {
        animateDuration=0.25f;
    }
    [UIView animateWithDuration:animateDuration  animations:^
     {
         _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x,
                                                 20);
     }];
}



#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
        _flag=0;
        
        NSString *UUID=[response objectForKey:@"uuid"];
        NSString *access_token=[response objectForKey:@"access_token"];
        NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:UUID forKey:@"APP_UUID"];
        [userDefaults setObject:access_token forKey:@"APP_TOKEN"];
        [userDefaults synchronize];
        
        
        if([response isKindOfClass:[NSDictionary class]])
        {
            MyMessage *mymessage=[MyMessage instance];
            NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:response];
            mymessage.userinfoDic=dic;
            
        }
        
        
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate RunSocket];
        delegate.window.rootViewController=delegate.mainViewNav;
        NSNotification *notification =[NSNotification notificationWithName:@"RefreshNotifi" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [delegate startLocationPositingWithOption:YES];
        
    }
    
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
    }
    
    [self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
}











@end
