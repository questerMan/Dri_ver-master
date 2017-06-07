//
//  UIImage+Qi.h
//  77net
//
//  Created by liyy on 14-4-16.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Qi)

//透明
- (UIImage *)transprent;

//圆形
- (UIImage *)rounded;
- (UIImage *)rounded:(CGRect)rect;

//拉伸
- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

//选择
- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;

//变灰
- (UIImage *)grayscale;

//转换颜色值
- (UIColor *)patternColor;

//裁剪
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)imageInRect:(CGRect)rect;

//等比缩放
- (UIImage *)scaleToSize:(CGSize)size;

//合并
+ (UIImage *)merge:(NSArray *)images;
- (UIImage *)merge:(UIImage *)image;
- (UIImage *)resize:(CGSize)newSize;

//通过扩展名转换成data数据
- (NSData *)dataWithExt:(NSString *)ext;

//修复图片方向
- (UIImage *)fixOrientation;

//view 转换成image
+(UIImage*)imageFromView:(UIView*)view;

@end
