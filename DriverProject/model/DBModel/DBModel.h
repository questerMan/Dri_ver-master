//
//  DBModel.h
//  socketIOexample
//
//  Created by ccb on 13-11-21.
//  Copyright (c) 2013年 saturngod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBModel : NSObject
+(BOOL)InsertWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr MsgSeq:(NSString *)msgSeq andIsRead:(NSString *)isRead;
+(BOOL)UpdateIsRead:(NSString *)isRead ToMsgType:(NSString *)msgType;
+(BOOL)UpdateIsRead:(NSString *)isRead ToMsgType:(NSString *)msgType WithMsgSeq:(NSString *)msgSeq;
+(NSInteger)GetUnreadNumofMsgType:(NSString *)msgType;
+(NSUInteger)GetTotalNumofMsgType:(NSString *)msgType;
+(NSArray *)GetMessagefromMsgType:(NSString *)msgType withRecentNum:(int)num;
+(NSArray *)GetUnreadMessagefromMsgType:(NSString *)msgType withRecentNum:(int)num;
+(BOOL)DeleteWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr MsgSeq:(NSString *)msgSeq;
+(BOOL)DeleteWithMsgType:(NSString*)msgType;
+(BOOL)SaveLoginTime:(NSString *)loginTime;
+(BOOL)SaveLastLoginTime:(NSString *)lastLoginTime;
+(NSString *)GetLoginTime;
+(NSString *)GetLastLoginTime;
+(BOOL)InsertWithCardNo:(NSString *)cardNum Avl_Lmt:(NSString *)avl_lmt Cr_Lmt:(NSString *)cr_lmt Wd_Lmt:(NSString *)wd_lmt Bal:(NSString *)bal andCcy:(NSString *)ccy;
+(NSArray *)GetCreditInfo;
+(BOOL)EraseMessageTable;
+(BOOL)EraseCreditInfo;
+(BOOL)SaveMSGLastReflashTime:(NSDate *)msgLastReflashTime;
+(BOOL)SaveCreditLastReflashTime:(NSDate *)creditLastReflashTime;
+(NSDate *)GetMsgLastReflashTime;
+(NSDate *)GetCreditLastReflashTime;
+(BOOL)InsertCreditInfoWithTimeTag:(NSString *)timeTag CardNo:(NSString *)cardNum Avl_Lmt:(NSString *)avl_lmt Cr_Lmt:(NSString *)cr_lmt Wd_Lmt:(NSString *)wd_lmt Bal:(NSString *)bal andCcy:(NSString *)ccy;
+(NSArray *)GetCreditInfoWithTimeTag:(NSString *)timeTag;
+(NSArray *)GetCreditInfoWithCardNum:(NSString *)cardNum TimeTag:(NSString *)timeTag;
+(BOOL)InsertUserListWithUserId:(NSString *)userId;
+(NSArray *)GetUserList;
+(BOOL)DeleteFromUserListWithUserId:(NSString *)tmpUser;






//userString为用户账户   类型为  2
+(BOOL)InsertWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr titleString:(NSString *)titleString;
+(NSArray *)GetMessagewithRecentNum:(int)num;
+(BOOL)DeleteFromUserListWithUserString;


//用户定位  类型为  3
+(BOOL)InsertWithMsgType:(NSString *)msgType  Date:(NSString *)timeStr totaldistance:(NSString *)totaldistance distance:(NSString *)distance Lon:(NSString *)Lon Lat:(NSString *)Lat orderId:(NSString *)orderid processStates:(NSString *)processStates;
+(NSArray *)GetDistanceArrayfromType:(NSString *)msgType withRecentNum:(int)num;
+(BOOL)DeleteCooMessageWithType:(NSString *)msgType;





@end
