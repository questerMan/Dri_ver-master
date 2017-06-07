//
//  NSDate+Qi.m
//  77net
//
//  Created by liyy on 14-6-5.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "NSDate+Qi.h"

@implementation NSDate (Qi)
-(NSString*)stringWithFormat:(NSString*)strDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strDateFormat];
    return [dateFormatter stringFromDate:self];
}

@end
