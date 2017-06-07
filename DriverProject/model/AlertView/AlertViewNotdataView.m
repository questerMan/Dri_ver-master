//
//  AlertViewNotdataView.m
//  DriverProject
//
//  Created by zyx on 15/10/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AlertViewNotdataView.h"

@interface  AlertViewNotdataView()
@property(nonatomic,strong)UIImageView *typeImageView;
@property(nonatomic,strong)UILabel *typelable;

@end


@implementation AlertViewNotdataView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        [self setUI];
        
        
    }
    return self;
}

-(void)setUI
{
    _typeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 55, 60, 60)];
    _typeImageView.backgroundColor=[UIColor clearColor];
    _typeImageView.hidden=YES;
    [self addSubview:_typeImageView];
    
    _typelable=[[UILabel alloc] initWithFrame:CGRectMake(55, 2, 250, 40)];
    _typelable.text=@"暂无数据";
    _typelable.backgroundColor=[UIColor clearColor];
    _typelable.textColor = TextDisable_COLOR;
    _typelable.font = [UIFont systemFontOfSize:15.0f];
#ifdef __IPHONE_6_0
    _typelable.textAlignment = NSTextAlignmentCenter;
#else
    _typelable.textAlignment = UITextAlignmentCenter;
#endif
    [self addSubview:_typelable];
    
    _typelable.hidden=YES;

}



-(void)showNotdatdaView:(AlertViewType)AlertViewType
{
    switch (AlertViewType) {
        case AlertViewNew:
            _typeImageView.image=[UIImage imageNamed:@"newnotdatda.png"];
            break;
        case AlertViewBill:
            _typeImageView.image=[UIImage imageNamed:@"billnotdataImage.png"];
            break;
        case AlertViewScore:
        {
            _typeImageView.image=[UIImage imageNamed:@"scorenotdataImage.png"];
            _typelable.text=@"暂无业绩记录";
            break;
        }
        case AlertViewtrip:
            _typeImageView.image=[UIImage imageNamed:@"tripnotdataimage.png"];
            break;
        case AlertViewCoupon:
            _typeImageView.image=[UIImage imageNamed:@"couponnotdataimage.png"];
            break;
        case AlertViewBalance:
            _typeImageView.image=[UIImage imageNamed:@"balancenotdataimage.png"];
            break;
            
            
        default:
            break;
    }
    
    
    _typeImageView.center=self.center;
    _typeImageView.top=60;
    _typeImageView.hidden=NO;
    _typeImageView.size=CGSizeMake(60, 60);
    
    
    _typelable.size=CGSizeMake(120, 60);
    [_typelable sizeToFit];
    _typelable.center=_typeImageView.center;
    _typelable.top=_typeImageView.bottom+10;
    _typelable.hidden=NO;
}

-(void)hideNotdataView
{
    _typeImageView.hidden=YES;
    _typeImageView.frame=CGRectZero;

    _typelable.hidden=YES;
    _typelable.frame=CGRectZero;
}



@end
