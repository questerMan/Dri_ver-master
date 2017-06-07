//
//  UILabel+Qi.m
//  77net
//
//  Created by liyy on 14-4-14.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "UILabel+Qi.h"

@implementation UILabel (Qi)

+(id)labelWithFrame:(CGRect)frame
{
    UILabel *label = [[[self class] alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end
