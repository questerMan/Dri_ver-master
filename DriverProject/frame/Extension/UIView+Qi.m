//
//  UIView+Qi.m
//  77net
//
//  Created by liyy on 14-4-14.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "UIView+Qi.h"

@implementation UIView (Qi)

+(UIView*)viewWithFrame:(CGRect)frame
{
    UIView *view = [[[self class] alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)left
{
    return self.frame.origin.x;
}

-(CGFloat)top
{
    return self.frame.origin.y;
}

-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)buttom
{
    return self.frame.origin.y + self.frame.size.height;
}


-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)removeAllSubviews
{
    UIView* child = nil;
    while (self.subviews.count)
    {
        child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
