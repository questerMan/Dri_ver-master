//
//  NSDate+Qi.h
//  77net
//
//  Created by liyy on 14-6-5.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Qi)

/**
 *  date转换成时间字符串
 *
 *  @param strDateFormat 时间格式 例如：@"yyyy-MM-dd HH:mm:ss"
 *
 *  @return NSString 对象
 */
-(NSString*)stringWithFormat:(NSString*)strDateFormat;

@end
