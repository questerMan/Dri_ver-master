//
//  NSString+Qi.h
//  77net
//
//  Created by liyy on 14-6-5.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Qi)

/**
 *  时间字符串转换成 date
 *
 *  @param strDateFormat 时间格式 例如：@"yyyy-MM-dd HH:mm:ss"
 *
 *  @return NSDate 对象
 */
-(NSDate*)dateWithFormat:(NSString*)strDateFormat;

@end
