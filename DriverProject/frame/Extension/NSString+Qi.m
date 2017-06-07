//
//  NSString+Qi.m
//  77net
//
//  Created by liyy on 14-6-5.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "NSString+Qi.h"

@implementation NSString (Qi)

-(NSDate*)dateWithFormat:(NSString*)strDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strDateFormat];
    return [dateFormatter dateFromString:self];
}

@end
