//
//  UIView+Qi.h
//  77net
//
//  Created by liyy on 14-4-14.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Qi)

+(id)viewWithFrame:(CGRect)frame;

-(CGFloat)left;
-(CGFloat)top;

-(CGFloat)right;
-(CGFloat)buttom;

-(CGFloat)width;
-(CGFloat)height;

-(void)removeAllSubviews;

@end
