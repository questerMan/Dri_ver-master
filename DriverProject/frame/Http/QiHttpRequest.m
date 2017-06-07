//
//  QiHttpRequest.m
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "QiHttpRequest.h"
#import "NSString+json.h"
@implementation QiHttpRequest

-(id)jsonValue
{
    NSString* strResponse = [self responseString];
    id response = [strResponse jsonValue];
    if (response == nil)
    {
        NSString* resultStirng = nil;
        //过滤无用数据
        NSRange range = [strResponse rangeOfString:@"{"];
        NSRange range2 = [strResponse rangeOfString:@"}}" options:NSBackwardsSearch];
        if (range.location != NSNotFound
            && range2.location != NSNotFound
            && range.location < range2.location)
        {
            resultStirng = [strResponse substringWithRange:NSMakeRange(range.location, range2.location+range2.length-range.location)];
            
            response = [resultStirng jsonValue];
        }
    }
    
    return response;
}

@end
