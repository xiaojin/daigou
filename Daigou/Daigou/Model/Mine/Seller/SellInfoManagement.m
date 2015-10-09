//
//  SellInfoManagement.m
//  Daigou
//
//  Created by jin on 9/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "SellInfoManagement.h"
#import "SellInfo.h"
#import "CommonDefines.h"
#import <FMDB/FMDB.h>

@implementation SellInfoManagement {
    FMDatabase *_db;
}

+ (instancetype)shareInstance {
    static SellInfoManagement *sellInfoManagement = nil;
    
    once_only(^{
        sellInfoManagement = [[self alloc] init];
    });
    
    return sellInfoManagement;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *stringPath = DATABASE_PATH;
        _db = [FMDatabase databaseWithPath:stringPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            // The database file does not exist in the documents directory, so copy it from the main bundle now.
            NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"daigou.db"];
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:stringPath error:&error];
            
            // Check if any error occurred during copying and display it.
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }
    return self;
}

- (SellInfo *)getSellInfo {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from seller"];
    SellInfo *sellInfo = nil;
    if (rs.next) {
        sellInfo = [self setValueForSellInfo:rs];
    }
    [_db close];
    return sellInfo;
}

- (BOOL)checkIfSellExists:(SellInfo *)sellInfo {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from seller where sid =(?)",[NSNumber numberWithInteger:sellInfo.sid]];
    if (rs.next) {
        return YES;
    } return NO;
}

- (BOOL)addSellInfo:(SellInfo *)sellInfo{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into seller (storename,slogon,name,ename,email,phonenum,idnum,address,postcode,bankinfo,region,syncDate) values (?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[sellInfo sellToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)updateSellInfo:(SellInfo *)sellInfo{
    BOOL exists = [self checkIfSellExists:sellInfo];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[sellInfo sellToArray]];
        [updateData addObject:@(sellInfo.sid)];
        result= [_db executeUpdate:@"update seller set storename=?,slogon=?name=?,ename=?,email=?,phonenum=?,idnum=?,address=?,postcode=?,bankinfo=?,region=?,syncDate=? where sid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
        }
    } else {
        result = [self addSellInfo:sellInfo];
    }
    [_db close];
    return result;
}

- (SellInfo *)setValueForSellInfo:(FMResultSet *)rs{
    SellInfo *sellInfo = [[SellInfo alloc]init];
    sellInfo.sid = (NSInteger)[rs intForColumn:@"sid"];
    sellInfo.storename = [rs stringForColumn:@"storename"];
    sellInfo.slogon = [rs stringForColumn:@"slogon"];
    sellInfo.name = [rs stringForColumn:@"name"];
    sellInfo.ename = [rs stringForColumn:@"ename"];
    sellInfo.email = [rs stringForColumn:@"email"];
    sellInfo.phonenum = [rs  stringForColumn:@"phonenum"];
    sellInfo.idnum = [rs stringForColumn:@"idnum"];
    sellInfo.address = [rs stringForColumn:@"address"];
    sellInfo.postcode = [rs stringForColumn:@"postcode"];
    sellInfo.bankinfo = [rs stringForColumn:@"bankinfo"];
    sellInfo.region = (NSInteger)[rs intForColumn:@"region"];
    sellInfo.syncDate = [rs doubleForColumn:@"syncDate"];
    return sellInfo;
}
@end
