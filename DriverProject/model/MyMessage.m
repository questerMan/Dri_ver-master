//
//  MyMessage.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-26.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MyMessage.h"

@implementation MyMessage



static MyMessage *sharedMyMessage = nil;

+(id)instance
{
    if (nil == sharedMyMessage)
    {
        sharedMyMessage = [[MyMessage alloc] init];
        
    }
    return sharedMyMessage;
}

-(void)dealloc{
    [userinfoDic release];

    userinfoDic=nil;

    [super dealloc];
}

+ (CGSize)heightFosizeForString:(NSString *)value fontSize:(UIFont *)Font andWidth:(float)width
{
    CGSize sizeToFit=(CGSize){0,0};
    NSString *string=value;
    if([value length]>0){
        if(IOS7_OR_LATER)
        {
            
            sizeToFit=[string boundingRectWithSize:
                       CGSizeMake(width, 1000)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font,NSFontAttributeName, nil] context:nil].size;
            
            
        }
        else
        {
            sizeToFit=[string sizeWithFont:Font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
        }
    }
    else
    {
        return sizeToFit;
    }
    
    return sizeToFit;
    
}
+(CGFloat)widthFromWord:(NSString *)Value fontSize:(UIFont *)Font
{
    if(!(Value.length>0)) return 0;
    CGSize sizeToFit=(CGSize){0,0};
    NSString *string=Value;
    CGFloat Height=[MyMessage HeightFromfontSize:Font];
    if(IOS7_OR_LATER)
    {
        
        sizeToFit=[string boundingRectWithSize:
                   CGSizeMake(1000, Height)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font,NSFontAttributeName, nil] context:nil].size;
        
        
    }
    else
    {
        sizeToFit=[string sizeWithFont:Font constrainedToSize:CGSizeMake(1000, Height) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    return sizeToFit.width;

}

+(CGFloat)HeightFromfontSize:(UIFont *)Font
{
    CGSize sizeToFit=(CGSize){0,0};
    NSString *string=@"野";
    CGFloat width=100;
    if(IOS7_OR_LATER)
    {

        sizeToFit=[string boundingRectWithSize:
               CGSizeMake(width, 1000)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font,NSFontAttributeName, nil] context:nil].size;


    }
    else
    {
        sizeToFit=[string sizeWithFont:Font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    }

    
    return sizeToFit.height;

}





@end
