//
//  DBModel.m
//  socketIOexample
//
//  Created by ccb on 13-11-21.
//  Copyright (c) 2013年 saturngod. All rights reserved.
//

#import "DBModel.h"

#define DBNAME @"ccbmessage.db"
#define TABLENAME [NSString stringWithFormat:@"USER_%@_MSG",[[NSUserDefaults standardUserDefaults] objectForKey:@"APP_UUID"]]
#define TABLEUSERINFO [NSString stringWithFormat:@"USER_%@_INFO",[[NSUserDefaults standardUserDefaults] objectForKey:@"APP_UUID"]]
#define TABLECREDITINFO [NSString stringWithFormat:@"USER_%@_CREDITINFO",[[NSUserDefaults standardUserDefaults] objectForKey:@"APP_UUID"]]
#define TABLEUSERLIST @"USER_LIST"
//#define TABLEUSERINFO  [NSString stringWithFormat:@"%@INFO",@"test123"]

@implementation DBModel

+(BOOL)isTableOK:(NSString *)tableName inDB:(FMDatabase*)db
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?",tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)InsertWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr MsgSeq:(NSString *)msgSeq andIsRead:(NSString *)isRead{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL insertResult=NO;
    @try {
        if (![self isTableOK:TABLENAME inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (MSGTYPE TEXT,MESSAGE TEXT,DATE TEXT,MSGSEQ TEXT PRIMARY KEY,ISREAD TEXT)",TABLENAME];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (MSGTYPE,MESSAGE,DATE,MSGSEQ,ISREAD) VALUES ('%@','%@','%@','%@','%@')",TABLENAME,msgType,message,timeStr,msgSeq,isRead];
        insertResult= [db executeUpdate:insertStr];
        [db commit];
        if (insertResult) {
            NSLog(@"insertSuccess");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return insertResult;
}









+(BOOL)UpdateIsRead:(NSString *)isRead ToMsgType:(NSString *)msgType{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL rs  = YES;
    @try {
        if (![self isTableOK:TABLENAME inDB:db]) {
            [db close];
            return NO;
        }
        [db beginTransaction];
        NSString *updateStr;
     
        updateStr=[NSString stringWithFormat:@"UPDATE %@ SET ISREAD = '%@' WHERE MSGTYPE = '%@'",TABLENAME,isRead,msgType];
       
        rs = [db executeUpdate:updateStr];
//        rs = [db executeUpdate:@"UPDATE name = ? SET ISREAD = ? WHERE MSGTYPE = ?",TABLENAME,isRead,msgType];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return rs;

}

+(BOOL)UpdateIsRead:(NSString *)isRead ToMsgType:(NSString *)msgType WithMsgSeq:(NSString *)msgSeq{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL rs  = YES;
    @try {
        if (![self isTableOK:TABLENAME inDB:db]) {
            [db close];
            return NO;
        }
        [db beginTransaction];
        NSString *updateStr;
        
        updateStr=[NSString stringWithFormat:@"UPDATE %@ SET ISREAD = '%@' WHERE MSGSEQ = '%@' and MSGTYPE = '%@'",TABLENAME,isRead,msgSeq,msgType];
        
        rs = [db executeUpdate:updateStr];
        //        rs = [db executeUpdate:@"UPDATE name = ? SET ISREAD = ? WHERE MSGTYPE = ?",TABLENAME,isRead,msgType];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return rs;
}

+(NSInteger)GetUnreadNumofMsgType:(NSString *)msgType{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return 0;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return 0;
    }
    NSInteger count=0;
    
    @try {
      
        NSString *isRead=@"0";
        FMResultSet *rs;
        if ([msgType isEqualToString:@"-1"]) {
            NSString *selectStr=[NSString stringWithFormat:@"select count(*) as 'Total' from %@ WHERE ISREAD = '%@'",TABLENAME,isRead];
            rs = [db executeQuery:selectStr];
//            rs = [db executeQuery:@"select count(*) as 'Total' from name = ? WHERE ISREAD = ?",TABLENAME,isRead];
        }else{
            NSString *selectStr=[NSString stringWithFormat:@"select count(*) as 'Total' from %@ WHERE MSGTYPE = '%@' and ISREAD = '%@'",TABLENAME,msgType,isRead];
            rs = [db executeQuery:selectStr];
//        rs = [db executeQuery:@"select count(*) as 'Total' from name = ? WHERE MSGTYPE = ? and ISREAD = ?",TABLENAME,msgType,isRead];
        }
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
           count = [rs intForColumn:@"Total"];
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return count;

}

+(NSUInteger)GetTotalNumofMsgType:(NSString *)msgType{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return 0;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return 0;
    }
    NSUInteger count=0;
    
    @try {
        FMResultSet *rs;
        NSString *selectStr=[NSString stringWithFormat:@"select count(*) as 'Total' from %@ WHERE MSGTYPE = '%@'",TABLENAME,msgType];
        rs = [db executeQuery:selectStr];
    
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            count = [rs intForColumn:@"Total"];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    return count;
}

+(NSArray *)GetMessagefromMsgType:(NSString *)msgType withRecentNum:(int)num{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return nil;
    }
     NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
       
        if (num==-1) {
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@' Order by MSGSEQ Desc",TABLENAME,msgType];
            FMResultSet *rs = [db executeQuery:selectStr];
//            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ? Order by DATE Desc",TABLENAME,msgType];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"MSGSEQ"];
                NSString* tempReadStatus=[rs stringForColumn:@"ISREAD"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,tempReadStatus,nil];
                [resultArr addObject:arr];
                [arr release];
            }

        }else{
            NSNumber *nsNum=[NSNumber numberWithInt:num];
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@'  Order by MSGSEQ Desc limit '%@'",TABLENAME,msgType,nsNum];
            FMResultSet *rs = [db executeQuery:selectStr];
//            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ?  Order by DATE Desc limit ?",TABLENAME,msgType,nsNum];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"MSGSEQ"];
                NSString* tempReadStatus=[rs stringForColumn:@"ISREAD"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,tempReadStatus,nil];
                [resultArr addObject:arr];
                [arr release];
            }

        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if (num==-1) {
        if ([resultArr count]==0) {
            return nil;
        }
        return [resultArr autorelease];
    }else{
        if ([resultArr count]==0) {
            return nil;
        }
//        return [[resultArr reverseObjectEnumerator] allObjects];
        return [resultArr autorelease];
    }
    
}

+(NSArray *)GetUnreadMessagefromMsgType:(NSString *)msgType withRecentNum:(int)num{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        NSString *isRead=@"0";
        if (num==-1) {
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@' and ISREAD = '%@' Order by MSGSEQ Desc",TABLENAME,msgType,isRead];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ? Order by DATE Desc",TABLENAME,msgType];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"MSGSEQ"];
                NSString* tempReadStatus=[rs stringForColumn:@"ISREAD"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,tempReadStatus,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }else{
            NSNumber *nsNum=[NSNumber numberWithInt:num];
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@' and ISREAD = '%@' Order by MSGSEQ Desc limit '%@'",TABLENAME,msgType,isRead,nsNum];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ?  Order by DATE Desc limit ?",TABLENAME,msgType,nsNum];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"MSGSEQ"];
                NSString* tempReadStatus=[rs stringForColumn:@"ISREAD"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,tempReadStatus,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if (num==-1) {
        if ([resultArr count]==0) {
            return nil;
        }
        return [resultArr autorelease];
    }else{
        if ([resultArr count]==0) {
            return nil;
        }
        //        return [[resultArr reverseObjectEnumerator] allObjects];
        return [resultArr autorelease];
    }

}
//+(NSString *)getTableName{
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"MBSH_ID"];
//}
+(BOOL)DeleteWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr MsgSeq:(NSString *)msgSeq
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE MSGTYPE = '%@' and MESSAGE = '%@' and DATE = '%@' and MSGSEQ = '%@'",TABLENAME,msgType,message,timeStr,msgSeq];

        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }
    
}

+(BOOL)DeleteWithMsgType:(NSString*)msgType{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE MSGTYPE = '%@'",TABLENAME,msgType];
        
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }
    
}

+(BOOL)EraseMessageTable{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return YES;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@",TABLENAME];
        
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }

}

+(BOOL)SaveLoginTime:(NSString *)loginTime{
    if (loginTime==nil) {
        loginTime=@"";
    }
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL result=YES;
    @try {
        if (![self isTableOK:TABLEUSERINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,INFOTYPE TEXT,LOGINTIME TEXT,LASTLOGINTIME TEXT,MSGLASTREFLASHTIME DOUBLE,CREDITLASTREFLASHTIME DOUBLE,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLEUSERINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        
        if ([rs next]) {
            @try {
            NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET LOGINTIME = '%@' WHERE INFOTYPE = '%@'",TABLEUSERINFO,loginTime,@"0"];
            [db beginTransaction];
            result = [db executeUpdate:updateStr];
            [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return result;
        }
  
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (INFOTYPE,LOGINTIME) VALUES ('%@','%@')",TABLEUSERINFO,@"0",loginTime];
        result=[db executeUpdate:insertStr];
        [db commit];
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return result;

}

+(BOOL)SaveLastLoginTime:(NSString *)lastLoginTime{
    if (lastLoginTime==nil) {
        lastLoginTime=@"";
    }
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL result=YES;
    @try {
        if (![self isTableOK:TABLEUSERINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,INFOTYPE TEXT,LOGINTIME TEXT,LASTLOGINTIME TEXT,MSGLASTREFLASHTIME DOUBLE,CREDITLASTREFLASHTIME DOUBLE,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLEUSERINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        
        if ([rs next]) {
            @try {
                NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET LASTLOGINTIME = '%@' WHERE INFOTYPE = '%@'",TABLEUSERINFO,lastLoginTime,@"0"];
                [db beginTransaction];
                result = [db executeUpdate:updateStr];
                [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return result;
        }
        
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (INFOTYPE,LASTLOGINTIME) VALUES ('%@','%@')",TABLEUSERINFO,@"0",lastLoginTime];
        result=[db executeUpdate:insertStr];
        [db commit];
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return result;
}

+(BOOL)SaveMSGLastReflashTime:(NSDate *)msgLastReflashDate{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL result=YES;
    NSTimeInterval msgLastReflashTime=[msgLastReflashDate timeIntervalSince1970];
    @try {
        if (![self isTableOK:TABLEUSERINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,INFOTYPE TEXT,LOGINTIME TEXT,LASTLOGINTIME TEXT,MSGLASTREFLASHTIME DOUBLE,CREDITLASTREFLASHTIME DOUBLE,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLEUSERINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        
        if ([rs next]) {
            @try {
                NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET MSGLASTREFLASHTIME = '%f' WHERE INFOTYPE = '%@'",TABLEUSERINFO,msgLastReflashTime,@"0"];
                [db beginTransaction];
                result = [db executeUpdate:updateStr];
                [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return result;
        }
        
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (INFOTYPE,MSGLASTREFLASHTIME) VALUES ('%@','%f')",TABLEUSERINFO,@"0",msgLastReflashTime];
        result=[db executeUpdate:insertStr];
        [db commit];
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return result;

}

+(BOOL)SaveCreditLastReflashTime:(NSDate *)creditLastReflashDate{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL result=YES;
    NSTimeInterval creditLastReflashTime=[creditLastReflashDate timeIntervalSince1970];
    @try {
        if (![self isTableOK:TABLEUSERINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,INFOTYPE TEXT,LOGINTIME TEXT,LASTLOGINTIME TEXT,MSGLASTREFLASHTIME DOUBLE,CREDITLASTREFLASHTIME DOUBLE,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLEUSERINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        
        if ([rs next]) {
            @try {
                NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET CREDITLASTREFLASHTIME = '%f' WHERE INFOTYPE = '%@'",TABLEUSERINFO,creditLastReflashTime,@"0"];
                [db beginTransaction];
                result = [db executeUpdate:updateStr];
                [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return result;
        }
        
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (INFOTYPE,CREDITLASTREFLASHTIME) VALUES ('%@','%f')",TABLEUSERINFO,@"0",creditLastReflashTime];
        result=[db executeUpdate:insertStr];
        [db commit];
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return result;
    
}

+(NSDate *)GetMsgLastReflashTime{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSDate *msgLastReflashTime=nil;
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs = [db executeQuery:selectStr];
        
        if ([rs next])
        {
            // just print out what we've got in a number of formats.
            msgLastReflashTime=[rs dateForColumn:@"MSGLASTREFLASHTIME"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return msgLastReflashTime;

}

+(NSDate *)GetCreditLastReflashTime{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSDate *creditLastReflashTime=nil;
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs = [db executeQuery:selectStr];
        
        if ([rs next])
        {
            // just print out what we've got in a number of formats.
            creditLastReflashTime=[rs dateForColumn:@"CREDITLASTREFLASHTIME"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return creditLastReflashTime;
    
}

+(NSString *)GetLoginTime{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSString *loginTime=nil;
    @try {
        
     
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
            FMResultSet *rs = [db executeQuery:selectStr];
           
            if ([rs next])
            {
                // just print out what we've got in a number of formats.
                loginTime=[rs stringForColumn:@"LOGINTIME"];
            }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return loginTime;
}

+(NSString *)GetLastLoginTime{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSString *lastLoginTime=nil;
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"0"];
        FMResultSet *rs = [db executeQuery:selectStr];
        
        if ([rs next])
        {
            // just print out what we've got in a number of formats.
            lastLoginTime=[rs stringForColumn:@"LASTLOGINTIME"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    return lastLoginTime;

}

+(BOOL)InsertWithCardNo:(NSString *)cardNum Avl_Lmt:(NSString *)avl_lmt Cr_Lmt:(NSString *)cr_lmt Wd_Lmt:(NSString *)wd_lmt Bal:(NSString *)bal andCcy:(NSString *)ccy{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL result=YES;
    @try {
        if (![self isTableOK:TABLEUSERINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,INFOTYPE TEXT,LOGINTIME TEXT,LASTLOGINTIME TEXT,MSGLASTREFLASHTIME DOUBLE,CREDITLASTREFLASHTIME DOUBLE,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLEUSERINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE INFOTYPE='%@' and CARDNO = '%@' and CCY = '%@'",TABLEUSERINFO,@"1",cardNum,ccy];
        FMResultSet *rs=[db executeQuery:checkSameStr];
       if ([rs next])
        {
            @try {
                NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET AVL_LMT = '%@' and CR_LMT='%@' and WD_LMT='%@' and BAL='%@' WHERE INFOTYPE = '%@' and CARDNO='%@' and CCY='%@'",TABLEUSERINFO,avl_lmt,cr_lmt,wd_lmt,bal,@"1",cardNum,ccy];
                [db beginTransaction];
                result = [db executeUpdate:updateStr];
                [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return result;
        }else{
            
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (INFOTYPE,CARDNO,AVL_LMT,CR_LMT,WD_LMT,BAL,CCY) VALUES ('%@','%@','%@','%@','%@','%@','%@')",TABLEUSERINFO,@"1",cardNum,avl_lmt,cr_lmt,wd_lmt,bal,ccy];
        result=[db executeUpdate:insertStr];
        [db commit];
        }
       
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return result;

}

//+(NSInteger)GetNumOfCreditInfo{
//    
//}

+(NSArray *)GetCreditInfo{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"1"];
            FMResultSet *rs = [db executeQuery:selectStr];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc] initWithCapacity:0];
                NSString* tmpCardNum=[rs stringForColumn:@"CARDNO"];
                NSString* tmpAvl_Lmt=[rs stringForColumn:@"AVL_LMT"];
                NSString* tmpCr_Lmt=[rs stringForColumn:@"CR_LMT"];
                NSString* tmpWd_Lmt=[rs stringForColumn:@"WD_LMT"];
                NSString* tmpBal=[rs stringForColumn:@"BAL"];
                NSString* tmpCcy=[rs stringForColumn:@"CCY"];
                [tmpDict setObject:tmpCardNum forKey:@"CARDNO"];
                [tmpDict setObject:tmpAvl_Lmt forKey:@"AVL_LMT"];
                [tmpDict setObject:tmpCr_Lmt forKey:@"CR_LMT"];
                [tmpDict setObject:tmpWd_Lmt forKey:@"WD_LMT"];
                [tmpDict setObject:tmpBal forKey:@"BAL"];
                [tmpDict setObject:tmpCcy forKey:@"CCY"];
                [resultArr addObject:tmpDict];
                [tmpDict release];
            }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if ([resultArr count]==0) {
        return nil;
    }
    return [resultArr autorelease];
   
}

+(BOOL)EraseCreditInfo{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLEUSERINFO inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE INFOTYPE = '%@'",TABLEUSERINFO,@"1"];
        
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }

}

+(BOOL)InsertCreditInfoWithTimeTag:(NSString *)timeTag CardNo:(NSString *)cardNum Avl_Lmt:(NSString *)avl_lmt Cr_Lmt:(NSString *)cr_lmt Wd_Lmt:(NSString *)wd_lmt Bal:(NSString *)bal andCcy:(NSString *)ccy{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL insertResult=NO;
    @try {
        if (![self isTableOK:TABLECREDITINFO inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,TIMETAG TEXT,CARDNO TEXT,AVL_LMT TEXT,CR_LMT TEXT,WD_LMT TEXT,BAL TEXT,CCY TEXT)",TABLECREDITINFO];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE TIMETAG='%@' and CARDNO = '%@' and CCY = '%@'",TABLECREDITINFO,timeTag,cardNum,ccy];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        while ([rs next])
        {
            [db close]; return NO;
        }

        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (TIMETAG,CARDNO,AVL_LMT,CR_LMT,WD_LMT,BAL,CCY) VALUES ('%@','%@','%@','%@','%@','%@','%@')",TABLECREDITINFO,timeTag,cardNum,avl_lmt,cr_lmt,wd_lmt,bal,ccy];
        insertResult= [db executeUpdate:insertStr];
        [db commit];
        if (insertResult) {
            NSLog(@"insertSuccess");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return insertResult;

}

+(NSArray *)GetCreditInfoWithTimeTag:(NSString *)timeTag{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLECREDITINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE TIMETAG = '%@'",TABLECREDITINFO,timeTag];
        FMResultSet *rs = [db executeQuery:selectStr];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc] initWithCapacity:0];
            NSString* tmpCardNum=[rs stringForColumn:@"CARDNO"];
            NSString* tmpAvl_Lmt=[rs stringForColumn:@"AVL_LMT"];
            NSString* tmpCr_Lmt=[rs stringForColumn:@"CR_LMT"];
            NSString* tmpWd_Lmt=[rs stringForColumn:@"WD_LMT"];
            NSString* tmpBal=[rs stringForColumn:@"BAL"];
            NSString* tmpCcy=[rs stringForColumn:@"CCY"];
            [tmpDict setObject:tmpCardNum forKey:@"CARDNO"];
            [tmpDict setObject:tmpAvl_Lmt forKey:@"AVL_LMT"];
            [tmpDict setObject:tmpCr_Lmt forKey:@"CR_LMT"];
            [tmpDict setObject:tmpWd_Lmt forKey:@"WD_LMT"];
            [tmpDict setObject:tmpBal forKey:@"BAL"];
            [tmpDict setObject:tmpCcy forKey:@"CCY"];
            [resultArr addObject:tmpDict];
            [tmpDict release];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if ([resultArr count]==0) {
        return nil;
    }
    return [resultArr autorelease];
}

+(NSArray *)GetCreditInfoWithCardNum:(NSString *)cardNum TimeTag:(NSString *)timeTag{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLECREDITINFO inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE TIMETAG = '%@' and CARDNO = '%@'",TABLECREDITINFO,timeTag,cardNum];
        FMResultSet *rs = [db executeQuery:selectStr];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSMutableDictionary *tmpDict=[[NSMutableDictionary alloc] initWithCapacity:0];
            NSString* tmpCardNum=[rs stringForColumn:@"CARDNO"];
            NSString* tmpAvl_Lmt=[rs stringForColumn:@"AVL_LMT"];
            NSString* tmpCr_Lmt=[rs stringForColumn:@"CR_LMT"];
            NSString* tmpWd_Lmt=[rs stringForColumn:@"WD_LMT"];
            NSString* tmpBal=[rs stringForColumn:@"BAL"];
            NSString* tmpCcy=[rs stringForColumn:@"CCY"];
            [tmpDict setObject:tmpCardNum forKey:@"CARDNO"];
            [tmpDict setObject:tmpAvl_Lmt forKey:@"AVL_LMT"];
            [tmpDict setObject:tmpCr_Lmt forKey:@"CR_LMT"];
            [tmpDict setObject:tmpWd_Lmt forKey:@"WD_LMT"];
            [tmpDict setObject:tmpBal forKey:@"BAL"];
            [tmpDict setObject:tmpCcy forKey:@"CCY"];
            [resultArr addObject:tmpDict];
            [tmpDict release];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if ([resultArr count]==0) {
        return nil;
    }
    return [resultArr autorelease];
}


+(BOOL)InsertUserListWithUserId:(NSString *)userId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL insertResult=NO;
    @try {
        if (![self isTableOK:TABLEUSERLIST inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (USERID TEXT PRIMARY KEY,INSERTTIME TEXT)",TABLEUSERLIST];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        NSDate *nowDate=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *insertTime=[dateFormatter stringFromDate:nowDate];
        [dateFormatter release];
        NSString *checkSameStr=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE USERID='%@'",TABLEUSERLIST,userId];
        FMResultSet *rs=[db executeQuery:checkSameStr];
        if ([rs next]) {
            @try {
                NSString *updateStr=[NSString stringWithFormat:@"UPDATE %@ SET INSERTTIME = '%@' WHERE USERID = '%@'",TABLEUSERLIST,insertTime,userId];
                [db beginTransaction];
                insertResult = [db executeUpdate:updateStr];
                [db commit];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
            return insertResult;
        }
        
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (USERID,INSERTTIME) VALUES ('%@','%@')",TABLEUSERLIST,userId,insertTime];
        insertResult= [db executeUpdate:insertStr];
        [db commit];
        if (insertResult) {
            NSLog(@"insertSuccess");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return insertResult;
}

+(NSArray *)GetUserList{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLEUSERLIST inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        
        NSString *selectStr=[NSString stringWithFormat:@"select * from %@ Order by INSERTTIME Desc",TABLEUSERLIST];
        FMResultSet *rs = [db executeQuery:selectStr];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSString* userId=[rs stringForColumn:@"USERID"];
            [resultArr addObject:userId];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if ([resultArr count]==0) {
        return nil;
    }
    return [resultArr autorelease];
}

+(BOOL)DeleteFromUserListWithUserId:(NSString *)tmpUser{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLEUSERLIST inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE USERID = '%@'",TABLEUSERLIST,tmpUser];
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }
}


#pragma mark   司机端

+(BOOL)InsertWithMsgType:(NSString*)msgType Message:(NSString*)message Date:(NSString*)timeStr titleString:(NSString *)titleString
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL insertResult=NO;
    @try {
        if (![self isTableOK:TABLENAME inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (MSGTYPE TEXT,MESSAGE TEXT,DATE TEXT,TITLE TEXT,USER TEXT PRIMARY KEY)",TABLENAME];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (MSGTYPE,MESSAGE,DATE,USER) VALUES ('%@','%@','%@','%@','%@')",TABLENAME,msgType,message,timeStr,titleString,TABLENAME];
        insertResult= [db executeUpdate:insertStr];
        [db commit];
        if (insertResult) {
            NSLog(@"insertSuccess");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return insertResult;
}

+(NSArray *)GetMessagewithRecentNum:(int)num
{
    
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        if (num==-1) {
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE USER = '%@' Order by DATE Desc",TABLENAME,TABLENAME];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ? Order by DATE Desc",TABLENAME,msgType];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"TITLE"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }else{
            NSNumber *nsNum=[NSNumber numberWithInt:num];
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE USER = '%@'  Order by DATE Desc limit '%@'",TABLENAME,TABLENAME,nsNum];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ?  Order by DATE Desc limit ?",TABLENAME,msgType,nsNum];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempMessage=[rs stringForColumn:@"MESSAGE"];
                NSString* tempTimeStr=[rs stringForColumn:@"DATE"];
                NSString* tempMsgSeq=[rs stringForColumn:@"TITLE"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempMsgType,tempMessage,tempTimeStr,tempMsgSeq,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if (num==-1) {
        if ([resultArr count]==0) {
            return nil;
        }
        return [resultArr autorelease];
    }else{
        if ([resultArr count]==0) {
            return nil;
        }
        //        return [[resultArr reverseObjectEnumerator] allObjects];
        return [resultArr autorelease];
    }
    
}


+(BOOL)DeleteFromUserListWithUserString
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE USER = '%@'",TABLENAME,TABLENAME];
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }
}

#pragma mark-  用户定位
+(BOOL)InsertWithMsgType:(NSString *)msgType  Date:(NSString *)timeStr totaldistance:(NSString *)totaldistance distance:(NSString *)distance Lon:(NSString *)Lon Lat:(NSString *)Lat orderId:(NSString *)orderid processStates:(NSString *)processStates;
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return NO;
    }
    BOOL insertResult=NO;
    @try {
        if (![self isTableOK:TABLENAME inDB:db]) {
            NSString *createTableStr=[NSString stringWithFormat:@"CREATE TABLE %@ (MSGTYPE TEXT,DATE TEXT PRIMARY KEY,TOTALDIS TEXT,DISTANCE TEXT,LON TEXT,LAT TEXT,ORDERID TEXT,STATE TEXT)",TABLENAME];
            [db beginTransaction];
            [db executeUpdate:createTableStr];
            [db commit];
        }
        
        [db beginTransaction];
        NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (MSGTYPE,DATE,TOTALDIS,DISTANCE,LON,LAT,ORDERID,STATE) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",TABLENAME,msgType,timeStr,totaldistance,distance,Lon,Lat,orderid,processStates];
        insertResult= [db executeUpdate:insertStr];
        [db commit];
        if (insertResult) {
            NSLog(@"insertSuccess");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insert exception: %@",[exception reason] );
    }
    @finally {
        [db close];
    }
    
    return insertResult;
}

+ (NSArray *)GetDistanceArrayfromType:(NSString *)msgType withRecentNum:(int)num
{
    
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];  
    if (![db open]) {
        ////DeBugLog(@"Could not open db.");
        return nil;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return nil;
    }
    NSMutableArray *resultArr=[[NSMutableArray alloc] initWithCapacity:0];
    @try {
        
        if (num==-1) {
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@' Order by DATE Desc",TABLENAME,msgType];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ? Order by DATE Desc",TABLENAME,msgType];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
               // NSString* tempMsgType=[rs stringForColumn:@"MSGTYPE"];
                NSString* tempData=[rs stringForColumn:@"DATE"];
                NSString* tempTotaldis=[rs stringForColumn:@"TOTALDIS"];
                NSString* tempDic=[rs stringForColumn:@"DISTANCE"];
                 NSString* tempLon=[rs stringForColumn:@"LON"];
                 NSString* tempLat=[rs stringForColumn:@"LAT"];
                NSString* tempID=[rs stringForColumn:@"ORDERID"];
                NSString* tempstate=[rs stringForColumn:@"STATE"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempData,tempTotaldis,tempDic,tempLon,tempLat,tempID,tempstate,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }else{
            NSNumber *nsNum=[NSNumber numberWithInt:num];
            NSString *selectStr=[NSString stringWithFormat:@"select * from %@ WHERE MSGTYPE = '%@'  Order by DATE Desc limit '%@'",TABLENAME,msgType,nsNum];
            FMResultSet *rs = [db executeQuery:selectStr];
            //            FMResultSet *rs = [db executeQuery:@"select * from name = ? WHERE MSGTYPE = ?  Order by DATE Desc limit ?",TABLENAME,msgType,nsNum];
            while ([rs next])
            {
                // just print out what we've got in a number of formats.
                NSString* tempData=[rs stringForColumn:@"DATE"];
                NSString* tempTotaldis=[rs stringForColumn:@"TOTALDIS"];
                NSString* tempDic=[rs stringForColumn:@"DISTANCE"];
                NSString* tempLon=[rs stringForColumn:@"LON"];
                NSString* tempLat=[rs stringForColumn:@"LAT"];
                NSString* tempID=[rs stringForColumn:@"ORDERID"];
                NSString* tempstate=[rs stringForColumn:@"STATE"];
                NSArray *arr=[[NSArray alloc] initWithObjects:tempData,tempTotaldis,tempDic,tempLon,tempLat,tempID,tempstate,nil];
                [resultArr addObject:arr];
                [arr release];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
    }
    
    if (num==-1) {
        if ([resultArr count]==0) {
            return nil;
        }
        return [resultArr autorelease];
    }
    else{
        if ([resultArr count]==0) {
            return nil;
        }
        //        return [[resultArr reverseObjectEnumerator] allObjects];
        return [resultArr autorelease];
    }
}

+(BOOL)DeleteCooMessageWithType:(NSString *)msgType
{
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBNAME];
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        //DeBugLog(@"Could not open db.");
        return NO;
    }
    if (![self isTableOK:TABLENAME inDB:db]) {
        [db close];
        return NO;
    }
    BOOL rs = YES;
    @try {
        [db beginTransaction];
        NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE MSGTYPE = '%@'",TABLENAME,msgType];
        rs = [db executeUpdate:deleteStr];
        [db commit];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return rs;
    }

}


@end

