//
//  DriverunView.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-5.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "DriverunView.h"

@implementation DriverunView




-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.backgroundColor=[UIColor grayColor];
//        [self setUI:frame];
        
        
    }
    return self;
}


-(void)AddButton:(UIViewController *)controller
{
    //self.backgroundColor=[UIColor grayColor];
    //[self setUI];
    
    _RunButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _RunButton.backgroundColor=Assist_COLOR;
    _RunButton.frame=CGRectMake(5, 5,50 , 50);
    [_RunButton setTitle:@"出车" forState:UIControlStateNormal];
    _RunButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [_RunButton setTitleColor:Textwhite_COLOR forState:UIControlStateNormal];
    _RunButton.layer.cornerRadius=_RunButton.width/2;
    [self addSubview:_RunButton];
    if(controller&&[controller respondsToSelector:@selector(RunDriver)])
    {
        [_RunButton addTarget:controller action:@selector(RunDriver) forControlEvents:UIControlEventTouchUpInside];
    }

    
}




-(void)setUI
{
    _RunButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _RunButton.backgroundColor=Assist_COLOR;
    _RunButton.frame=CGRectMake(5, 5,50 , 50);
    [_RunButton setTitle:@"出车" forState:UIControlStateNormal];
    [_RunButton setTitleColor:Textwhite_COLOR forState:UIControlStateNormal];
    _RunButton.layer.cornerRadius=_RunButton.width/2;
    [self addSubview:_RunButton];
    


}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
