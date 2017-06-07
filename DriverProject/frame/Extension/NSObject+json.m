//
//  NSObject+json.m
//  77net
//
//  Created by liyy on 14-4-21.
//  Copyright (c) 2014年 liyy. All rights reserved.
//

#import "NSObject+json.h"

@implementation NSObject (json)

-(NSString*)JsonString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil)
    {
       return nil;
    }
    else
    {
        return [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    }
}

@end
