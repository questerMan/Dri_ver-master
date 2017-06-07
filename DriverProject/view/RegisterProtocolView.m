//
//  RegisterProtocolView.m
//  DriverProject
//
//  Created by zyx on 15/12/7.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RegisterProtocolView.h"
#define MID(a) ((a)*0.5)


@implementation RegisterProtocolView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        
        UIFont* font = [UIFont systemFontOfSize:12];
        UIColor* titleColor = [UIColor grayColor];
        UIColor* contentColor = [UIColor blueColor];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [tipsLabel setBackgroundColor:[UIColor clearColor]];
        [tipsLabel setFont:font];
        [tipsLabel setTextColor:titleColor];
        tipsLabel.text = @"使用广汽，就表示您同意广汽的";
        [tipsLabel sizeToFit];
        [self addSubview:tipsLabel];
        
        
        UILabel* protocolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [protocolLabel setBackgroundColor:[UIColor clearColor]];
        [protocolLabel setFont:font];
        [protocolLabel setTextColor:contentColor];
        protocolLabel.text = @"用户协议";
        [protocolLabel sizeToFit];
        [self addSubview:protocolLabel];
        
        UIView* protocolLine = [[UIView alloc] initWithFrame:CGRectZero];
        protocolLine.backgroundColor = contentColor;
        [self addSubview:protocolLine];
        
        UIButton* protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:protocolBtn];
        self.protocolBtn = protocolBtn;
        
        CGFloat v_padding = 5;
        CGFloat h_padding = 1;
        CGFloat firstWidth = tipsLabel.width;
        CGFloat secondWidth = protocolLabel.width;
        
        CGFloat width = firstWidth + h_padding +  secondWidth;
        CGFloat height = v_padding + MAX(tipsLabel.height, protocolLabel.height) + v_padding;
        self.frame = CGRectMake(0, 0, width, height);
        
        tipsLabel.frame = CGRectMake(0, MID(height - tipsLabel.height), tipsLabel.width, tipsLabel.height);
        
        protocolLabel.frame = CGRectMake(tipsLabel.right + h_padding, MID(height - protocolLabel.height), protocolLabel.width, protocolLabel.height);
        protocolLine.frame = CGRectMake(protocolLabel.left, protocolLabel.bottom + 1, protocolLabel.width, 1);
        protocolBtn.frame = CGRectInset(protocolLabel.frame, -v_padding, -v_padding);
        
    }
    return self;
}



@end
