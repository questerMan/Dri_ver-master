//
//  NSString+QiEncoding.h
//  77net
//  URL编解码
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QiEncoding)

-(NSString *)URLEncodedString;

-(NSString *)URLDecodedString;

@end
