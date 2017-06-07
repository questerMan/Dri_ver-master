//
//  UIButton+Qi.m
//  77net
//
//  Created by liyy on 14-4-14.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "UIButton+Qi.h"

@implementation UIButton (Qi)

+(id)buttonWithFrame:(CGRect)frame
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

@end
