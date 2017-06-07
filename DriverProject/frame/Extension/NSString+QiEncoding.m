//
//  NSString+QiEncoding.m
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "NSString+QiEncoding.h"

@implementation NSString (QiEncoding)

-(NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	return result;
}

-(NSString*)URLDecodedString
{
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (__bridge CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
	return result;
}

@end
