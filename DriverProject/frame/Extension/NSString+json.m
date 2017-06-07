//
//  NSString+json.m
//  77net
//
//  Created by liyy on 14-4-21.
//  Copyright (c) 2014年 liyy. All rights reserved.
//

#import "NSString+json.h"

@implementation NSString (json)

- (id)jsonValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil)
    {
       return nil;
    }
    
    return result;
}
@end
