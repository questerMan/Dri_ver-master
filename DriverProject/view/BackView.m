//
//  BackView.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BackView.h"

@implementation BackView

#define SPACING   30

#define SPACING_BOTTOM  
#define SPACING_TOP
#define SPACING_LABLE 10

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:0.5];
        [self setUI];
        
        
    }
    return self;
}


-(void)setUI
{

    _PopupView=[[UIView alloc]initWithFrame:CGRectMake(SPACING, 200, SCREEN_WIDTH-SPACING, 130)];
    _PopupView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _PopupView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_PopupView];
    
    _TitleLable=[[UILabel alloc]initWithFrame:CGRectMake(SPACING_LABLE, SPACING_LABLE, _PopupView.width-SPACING_LABLE, 40)];
    _TitleLable.text=@"前往接客点";
    _TitleLable.textColor=Textblack_COLOR;
    _TitleLable.textAlignment=NSTextAlignmentLeft;
    _TitleLable.font=[UIFont systemFontOfSize:15];
    [_PopupView addSubview:_TitleLable];
    
    _ContentLable=[[UILabel alloc]initWithFrame:CGRectMake(SPACING_LABLE, SPACING_LABLE+_TitleLable.bottom, _PopupView.width-SPACING_LABLE, 40)];
    _ContentLable.text=@"出发后不可取消，是否确定?";
    //_ContentLable.textColor=TextDisable_COLOR;
    _ContentLable.textColor=Textblack_COLOR;
    _ContentLable.textAlignment=NSTextAlignmentLeft;
    _ContentLable.font=[UIFont systemFontOfSize:12];
    [_PopupView addSubview:_ContentLable];

    _ConfirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton.frame=CGRectMake(SPACING, _ContentLable.bottom+SPACING, 60, 50);
    _ConfirmButton.backgroundColor=[UIColor clearColor];
    [_ConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ConfirmButton setTitleColor:Main_COLOR forState:UIControlStateNormal];
   // [_ConfirmButton addTarget:self action:@selector(Confirm) forControlEvents:UIControlEventTouchUpInside];
    _ConfirmButton.center=CGPointMake(KScreenWidth-30-SPACING, _ContentLable.bottom+SPACING_LABLE+5);
    [_PopupView addSubview:_ConfirmButton];
    
    _CancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _CancelButton.frame=CGRectMake(SPACING, _ContentLable.bottom+SPACING, 60, 50);
    _CancelButton.backgroundColor=[UIColor clearColor];
    [_CancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_CancelButton setTitleColor:Main_COLOR forState:UIControlStateNormal];
   // [_CancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    _CancelButton.center=CGPointMake(KScreenWidth-30-SPACING-60, _ContentLable.bottom+SPACING_LABLE+5);
    [_PopupView addSubview:_CancelButton];
    
    
    _TextField = [[UITextField alloc] initWithFrame:CGRectZero] ;
    _TextField.font = [UIFont systemFontOfSize:13];
    _TextField.placeholder = @"请认真填写附加费用,可不添";
    _TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _TextField.returnKeyType = UIReturnKeySearch;
    //_TextField.delegate = self;
    _TextField.clearButtonMode = UITextFieldViewModeNever;
    
//    [_TextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [_PopupView addSubview:_TextField];
    
    

}


#pragma mark   私有方法

-(void)Cancel
{
    [self.superview removeFromSuperview];
}


-(void)showview:(OrdersStates)states
{
    if(states==StateNullOrders)
    {

        
    }
    if(states==StateReceiveOrders)
    {
        _TitleLable.text=@"前往接客点";
        _ContentLable.text=@"为保障您的权益，出发前请先致电乘客确定合适的上车地点和上车时间";

    }
    if(states==Statesetoff)
    {
        _TitleLable.text=@"到达接客点";
        _ContentLable.text=@"为保障您的权益，请致电乘客告知您的确切位置";
        
    }
    if(states==StateGoToArrived)
    {
        _TitleLable.text=@"开始计费";
        _ContentLable.text=@"为保障您的权益，请确保乘客已上车";
        
    }
    
    if(states==StateGoToPickUp)
    {
        _TitleLable.text=@"结束计费";
        _ContentLable.text=@"本次行程已结束，停止计费";
    }
    if(states==StateBilling)
    {
        _TitleLable.text=@"现金收款";
        _ContentLable.text=@"为保障您的权益，请确认您已收到车款";
    }
    if(states==StateEndAndPay)
    {

    
    
    }
    if(states!=StateGoToPickUp)
    {
        _TextField.frame=CGRectZero;
        _ContentLable.lineBreakMode = NSLineBreakByWordWrapping;
        _ContentLable.numberOfLines=0;
        CGRect txtFrame = _ContentLable.frame;
        txtFrame = CGRectMake(SPACING_LABLE, SPACING_LABLE+_TitleLable.bottom, _PopupView.width-SPACING_LABLE, 100);
        txtFrame.size.height =[_ContentLable.text boundingRectWithSize:
                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:_ContentLable.font,NSFontAttributeName, nil] context:nil].size.height;
        _ContentLable.frame=txtFrame;
        
        _ConfirmButton.center=CGPointMake(KScreenWidth-30-SPACING, _ContentLable.bottom+SPACING_LABLE+15);
        _CancelButton.center=CGPointMake(KScreenWidth-30-SPACING-60, _ContentLable.bottom+SPACING_LABLE+15);
    
    
    }
    else
    {
        _PopupView.height+=40;
        _PopupView.top=100;
        _ContentLable.lineBreakMode = NSLineBreakByWordWrapping;
        _ContentLable.numberOfLines=0;
        CGRect txtFrame = _ContentLable.frame;
        txtFrame = CGRectMake(SPACING_LABLE, SPACING_LABLE+_TitleLable.bottom, _PopupView.width-SPACING_LABLE, 100);
        txtFrame.size.height =[_ContentLable.text boundingRectWithSize:
                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:_ContentLable.font,NSFontAttributeName, nil] context:nil].size.height;
        _ContentLable.frame=txtFrame;
        
        _TextField.frame=CGRectMake(_ContentLable.left, _ContentLable.bottom+SPACING_LABLE, _TitleLable.width, _TitleLable.height+10);
        //_TextField.backgroundColor=[UIColor yellowColor];
        _ConfirmButton.center=CGPointMake(KScreenWidth-30-SPACING, _TextField.bottom+SPACING_LABLE+5);
        _CancelButton.center=CGPointMake(KScreenWidth-30-SPACING-60, _TextField.bottom+SPACING_LABLE+5);
        
        [_TextField becomeFirstResponder];
    
    
    }
}





@end
