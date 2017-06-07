//
//  ForgetPasswordVC.m
//  DriverProject
//
//  Created by zyx on 15/9/25.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//
#import "RegisterProtocolView.h"
#import "ForgetPasswordVC.h"
#import "MyMessage.h"
#import "RegisterProtocolView.h"
#import "TourismVC.h"
#define LEFT_SPACING   15  //左间距

#define MIDDLE_SPACING   5   //中间

#define  FIELD_WIDE   (KScreenWidth-2*LEFT_SPACING)
#define  FIELD_HEIGHT  50
#define  BUTTON_WIDE  80   //button的宽度

#define MAXSMSTIME 60

@interface ForgetPasswordVC ()
{
    NSInteger smsTime;
}
@property(nonatomic,strong)UILabel *introduceLabel;
@property(nonatomic,strong)UITextField* phoneField;
@property(nonatomic,strong)UITextField* passField;
@property(nonatomic,strong)UITextField* codeField;

@property(nonatomic,strong)UIButton* codeButton;
@property(nonatomic,strong)UIButton* confirmButton;

@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,assign)NSInteger Codeflag;
@property(nonatomic,strong)NSTimer *smsTimer;
@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Textlightwhite_COLOR;
    self.backView.backgroundColor=Textwhite_COLOR;
    self.backLabel.text=@"重置密码";
    self.backLabel.textColor=Textblack_COLOR;
     self.backButtonimage.image=[UIImage imageNamed:@"common_navbar_return.png"];
    //[self titlelableMiddle];
    _flag=0;
    [self initUI];
    
    [self.backButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)initUI
{
    _introduceLabel=[[UILabel alloc]init];
    _introduceLabel.textColor=Textgray_COLOR;
    _introduceLabel.text=@"请验证您的手机号码并设置新密码";
    _introduceLabel.font=[UIFont systemFontOfSize:FONT_SIZE_MID_2];
    [_introduceLabel sizeToFit];
    //_introduceLabel.center=CGPointMake(_backButton.right+15, CUSTOM_NAV_HEIGHT);
    _introduceLabel.origin=CGPointMake(LEFT_SPACING, CUSTOM_NAV_HEIGHT+20);
    [self.view addSubview:_introduceLabel];
    //+++++++++++++
    [self addPhoneField:_phoneField ToView:self.view withTitle:@"请输入手机号码" andTitleYoffset:(_introduceLabel.bottom+20) isPassword:NO withWide:(self.view.width-2*LEFT_SPACING-MIDDLE_SPACING-BUTTON_WIDE) withColor:Textgray_COLOR];
    
    [self addCodeField:_codeField ToView:self.view withTitle:@"请输入验证码" andTitleYoffset:(_phoneField.bottom) isPassword:YES withWide:(self.view.width-2*LEFT_SPACING) withColor:Textgray_COLOR];
    
    [self addPassField:_passField ToView:self.view withTitle:@"请填写新密码" andTitleYoffset:(_codeField.bottom) isPassword:YES withWide:(self.view.width-2*LEFT_SPACING) withColor:Textgray_COLOR];
    //+++++++++++++
    
    
    _codeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_codeButton setFrame:CGRectMake(_phoneField.right+10,_phoneField.top+5, self.view.width-(_phoneField.right+15)-LEFT_SPACING, _phoneField.height-5)];
    [_codeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _codeButton.backgroundColor=[UIColor clearColor];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeButton setTitle:@"验证" forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(codeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    UIImage *loginBg=[UIImage imageNamed:@"button_ok_yellow.png"];
    loginBg=[loginBg stretchableImageWithLeftCapWidth:(loginBg.size.width*0.5f) topCapHeight:(loginBg.size.height*0.5f)];
    [_codeButton setBackgroundImage:loginBg forState:UIControlStateNormal];
    
    
    _confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(LEFT_SPACING,_passField.bottom+20 , _passField.width, _passField.height)];
    _confirmButton.titleLabel.font=[UIFont systemFontOfSize:15];
    _confirmButton.backgroundColor=[UIColor clearColor];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"重设密码" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(reSetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
     [_confirmButton setBackgroundImage:loginBg forState:UIControlStateNormal];
    
    
    RegisterProtocolView* protocolView = [[RegisterProtocolView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:protocolView];
    
    protocolView.frame = CGRectMake((self.view.width - protocolView.width)*0.5, _confirmButton.bottom + 10, protocolView.width, protocolView.height);
    [protocolView.protocolBtn addTarget:self action:@selector(protocolBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)addPhoneField:(UITextField *)textField ToView:(UIView *)mainView withTitle:(NSString *)title andTitleYoffset:(CGFloat)y_offset isPassword:(BOOL)isPassword  withWide:(CGFloat)wide withColor:(UIColor *)color{
    //42
//    UIImageView *FieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACING,y_offset , 30, 30)];
//    FieldImageView.backgroundColor=[UIColor grayColor];
//    [mainView addSubview:FieldImageView];
    
    _phoneField=[[UITextField alloc] init];
    _phoneField.backgroundColor=[UIColor clearColor];
    _phoneField.borderStyle=UITextBorderStyleNone;
    _phoneField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneField.textAlignment=NSTextAlignmentLeft;
    _phoneField.delegate=self;
    _phoneField.keyboardType=UIKeyboardTypePhonePad;
    _phoneField.font=[UIFont systemFontOfSize:14];
    _phoneField.placeholder=title;
    _phoneField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _phoneField.secureTextEntry=isPassword;
    _phoneField.frame=CGRectMake(LEFT_SPACING,y_offset , wide, 46);
    [mainView addSubview:_phoneField];
    _phoneField.returnKeyType=UIReturnKeyNext;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACING, _phoneField.bottom, wide,LINE_HEIGHT)];
    lineView.backgroundColor=Dividingline_COLOR;
    [mainView addSubview:lineView];
    
    
}
-(void)addCodeField:(UITextField *)textField ToView:(UIView *)mainView withTitle:(NSString *)title andTitleYoffset:(CGFloat)y_offset isPassword:(BOOL)isPassword  withWide:(CGFloat)wide withColor:(UIColor *)color{
    //42
//     UIImageView *FieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACING,y_offset , 30, 30)];
//    FieldImageView.backgroundColor=[UIColor grayColor];
//    [mainView addSubview:FieldImageView];
    
    _codeField=[[UITextField alloc] init];
    _codeField.backgroundColor=[UIColor clearColor];
    _codeField.borderStyle=UITextBorderStyleNone;
    _codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _codeField.textAlignment=NSTextAlignmentLeft;
    _codeField.delegate=self;
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.font=[UIFont systemFontOfSize:14];
    _codeField.placeholder=title;
    _codeField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    //_codeField.secureTextEntry=isPassword;
    _codeField.frame=CGRectMake(LEFT_SPACING,y_offset , wide, 46);
    [mainView addSubview:_codeField];
    _codeField.returnKeyType=UIReturnKeyNext;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACING, _codeField.bottom, wide, LINE_HEIGHT)];
    lineView.backgroundColor=Dividingline_COLOR;
    [mainView addSubview:lineView];
    
    
}
-(void)addPassField:(UITextField *)textField ToView:(UIView *)mainView withTitle:(NSString *)title andTitleYoffset:(CGFloat)y_offset isPassword:(BOOL)isPassword  withWide:(CGFloat)wide withColor:(UIColor *)color{
    //42
//    UIImageView *FieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(LEFT_SPACING,y_offset , 30, 30)];
//    FieldImageView.backgroundColor=[UIColor grayColor];
//    [mainView addSubview:FieldImageView];
    
    _passField=[[UITextField alloc] init];
    _passField.backgroundColor=[UIColor clearColor];
    _passField.borderStyle=UITextBorderStyleNone;
    _passField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passField.textAlignment=NSTextAlignmentLeft;
    _passField.delegate=self;
    _passField.font=[UIFont systemFontOfSize:14];
    _passField.placeholder=title;
    _passField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passField.secureTextEntry=isPassword;
    _passField.frame=CGRectMake(LEFT_SPACING,y_offset , wide, 46);
    [mainView addSubview:_passField];
    _passField.returnKeyType=UIReturnKeySend;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACING, _passField.bottom, wide, 0.5)];
    lineView.backgroundColor=Dividingline_COLOR;
    [mainView addSubview:lineView];
    
    
}
-(void)codeBtnPressed
{
    NSString *phone = _phoneField.text;
    if ([phone length]==0) {
        [_phoneField becomeFirstResponder];
        return;
    }

    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _Codeflag=[facade postGetCodeWithphone:_phoneField.text];
    [facade addHttpObserver:self tag:_Codeflag];

}

-(void)reSetBtnPressed
{
    NSString *userName=_phoneField.text;
    NSString *password=_passField.text;
    NSString *codeString=_codeField.text;
    if ([userName length]==0) {
        // [self showWarningMessage:@"请输入手机号"];
        [_phoneField becomeFirstResponder];
        return;
    }
    // 内测阶段，暂时屏蔽
//    if ([userName length]!=11) {
//        [self showWarningMessage:@"手机号输入不对"];
//        return;
    //    }
    if ([codeString length]==0) {
        //[self showWarningMessage:@"请输入验证码！"];
        [_codeField becomeFirstResponder];
        return;
    }
    if ([password length]==0) {
        //[self showWarningMessage:@"请输入密码！"];
        [_passField becomeFirstResponder];
        return;
    }
    if ([password length]<6) {
        [self showWarningMessage:@"密码太短了！"];
        [_passField becomeFirstResponder];
        return;
    }
    
    
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flag=[facade postForgetPassord:_phoneField.text password:_passField.text vcode:_codeField.text];
    [facade addHttpObserver:self tag:_flag];
}

-(void)leftButtonPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark RegisterProtocolView
-(void)protocolBtnTouched:(UIButton*)sender
{

    TourismVC* vc = [TourismVC new];
    vc.titlelable = @"用户协议";
    vc.urlString =@"http://www.gaclixin.com/help/driver_policy.html";
    vc.isdismissSelf = YES;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark **************UITextField***************
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    if (textField==_phoneField) {
        //输入格式化
        if (text.length>20) {
            return NO;
        }
        
    }
    if (textField==_passField) {
        //密码30位数限制
        if (text.length > 30)
            return NO;
    }
    
    if ([string isEqualToString:@"\n"])
    {
        // 回车键，关闭键盘
        [_phoneField resignFirstResponder];
        [_passField resignFirstResponder];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if([_phoneField isFirstResponder])
    {
        [_codeField becomeFirstResponder];
    }
    
    if([_codeField isFirstResponder])
    {
        [_passField becomeFirstResponder];
    }
    if([_passField isFirstResponder])
    {
        [self  reSetBtnPressed];
    }
    
    return YES;
}
- (void)textFieldBegin:(UITextField *)textField{
    if (textField==_phoneField) { //增加下拉用户列表，如果不需要用户列表直接屏蔽本行代码即可
    }
    
}



#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    NSLog(@"成功 /n%@",response);
    if(_flag!=0&&response!=nil&&iRequestTag==_flag)
    {
        _flag=0;
        //[self showWarningMessage:@"成功"];
        
        NSString *UUID=[response objectForKey:@"uuid"];
        NSString *access_token=[response objectForKey:@"access_token"];
        NSUserDefaults*userDefaults= [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:UUID forKey:@"APP_UUID"];
        [userDefaults setObject:access_token forKey:@"APP_TOKEN"];
        [userDefaults synchronize];
        
        
        if([response isKindOfClass:[NSDictionary class]])
        {
            MyMessage *mymessage=[MyMessage instance];
            NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:response];
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
    if(_Codeflag!=0&&response!=nil&&iRequestTag==_Codeflag)
    {
        _Codeflag=0;
        
        if (_smsTimer != nil) {
            [_smsTimer invalidate];
            _smsTimer = nil;
            
        }
        smsTime=MAXSMSTIME+1;
        [self timer];
        _smsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
       
        
        UIView *codeView=[[UIView alloc]initWithFrame:CGRectZero];
        codeView.frame=_codeButton.frame;
        codeView.backgroundColor=[UIColor clearColor];
        codeView.tag=1100;
        [self.view addSubview:codeView];
    
    }
    
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);
    }
    
    //[self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
}

-(void)timer{
    if (smsTime>0) {
        smsTime--;
        NSString * smsTimestring=[NSString stringWithFormat:@"%d秒",smsTime];
        [_codeButton setTitle:smsTimestring forState: UIControlStateNormal];
        //_codeButton.enabled = NO;
    }else{
        if (_smsTimer != nil) {
            [_smsTimer invalidate];
            _smsTimer = nil;
            
        }
        UIView *codeView=[self.view viewWithTag:1100];
        [codeView removeFromSuperview];
        
        
        
        NSString *title = [NSString stringWithFormat:@"验证"];
        [_codeButton setTitle:title forState: UIControlStateNormal];
    }
    
}


@end





