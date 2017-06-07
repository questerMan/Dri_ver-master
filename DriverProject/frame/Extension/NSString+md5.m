//
//  NSString+md5.m
//  77net
//
//  Created by liyy on 14-6-4.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

-(NSString*)md5
{
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *strResult = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return strResult;
}

@end
