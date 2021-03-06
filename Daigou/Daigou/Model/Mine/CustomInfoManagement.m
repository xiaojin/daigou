//
//  CustomInfoManagement.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "CustomInfoManagement.h"
#import "CustomInfo.h"
#import "CommonDefines.h"
#import <FMDB/FMDB.h>
#import "NSString+StringToPinYing.h"
@implementation CustomInfoManagement {
  FMDatabase *_db;
}

+ (instancetype)shareInstance {
  static CustomInfoManagement *customInfoManagement = nil;
  
  once_only(^{
    customInfoManagement = [[self alloc] init];
  });
  
  return customInfoManagement;
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

- (NSArray *)getCustomInfo {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
  FMResultSet *rs = [_db executeQuery:@"select * from client"];
  NSMutableArray *customArray = [NSMutableArray array];
  while (rs.next) {
      CustomInfo *customInfo = [self setValueForCustomInfo:rs];
      [customArray addObject:customInfo];
  }
    [_db close];
  return customArray;
}

- (CustomInfo *)getCustomInfoById:(NSInteger)cid {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from client where cid = (?) ", [NSNumber numberWithInteger:cid]];
    CustomInfo *customInfo = nil;
    if (rs.next) {
        customInfo = [self setValueForCustomInfo:rs];
    }
    [_db close];
    return customInfo;
}

- (CustomInfo *)setValueForCustomInfo:(FMResultSet *)rs{
    CustomInfo *customInfo = [[CustomInfo alloc]init];
    customInfo.cid = (NSInteger)[rs intForColumn:@"cid"];
    customInfo.name = [rs stringForColumn:@"name"];
    customInfo.email = [rs stringForColumn:@"email"];
    customInfo.phonenum = [rs  stringForColumn:@"phonenum"];
    customInfo.wechat = [rs stringForColumn:@"wechat"];
    customInfo.idnum = [rs stringForColumn:@"idnum"];
    customInfo.postcode = [rs stringForColumn:@"postcode"];
    customInfo.agent = (NSInteger)[rs intForColumn:@"agent"];
    customInfo.address = [rs stringForColumn:@"address"];
    customInfo.address1 = [rs stringForColumn:@"address1"];
    customInfo.address2 = [rs stringForColumn:@"address2"];
    customInfo.address3 = [rs stringForColumn:@"address3"];
    customInfo.photofront = [rs stringForColumn:@"photofront"];
    customInfo.photoback = [rs stringForColumn:@"photoback"];
    customInfo.expressAvaible = [rs stringForColumn:@"expressAvaible"];
    customInfo.note = [rs stringForColumn:@"note"];
    customInfo.ename = [rs stringForColumn:@"ename"];
    customInfo.syncDate = [rs doubleForColumn:@"syncDate"];
    if (customInfo.ename == nil || [customInfo.ename isEqualToString:@""]) {
        customInfo.ename = [customInfo.name transformToPinyin];
    }
    return customInfo;
}

- (BOOL)checkIfCustomExists:(CustomInfo *)custom {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from client where cid =(?)",[NSNumber numberWithInteger:custom.cid]];
    if (rs.next) {
        return YES;
    } return NO;
}

- (BOOL)deleteCustomInfoByID:(NSString *)name {
  BOOL result = [_db executeUpdate:@"DELETE * from Clinet WHERE name LIKES '%?%'",name];
  return result;
}

- (BOOL)addCustomInfo:(CustomInfo *)custom{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into client (name,email,phonenum,wechat,idnum,postcode,agent,address,address1,address2,address3,photofront,photoback,expressAvaible,note,ename,syncDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[custom cutomToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)insertCustomInfo:(CustomInfo *)custom {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result = [self addCustomInfo:custom];
    return result;
}

- (BOOL)updateCustomInfo:(CustomInfo *)custom{
    BOOL exists = [self checkIfCustomExists:custom];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[custom cutomToArray]];
        [updateData addObject:@(custom.cid)];
        result= [_db executeUpdate:@"update client set name=?,email=?,phonenum=?,wechat=?,idnum=?,postcode=?,agent=?,address=?,address1=?,address2=?,address3=?,photofront=?,photoback=?,expressAvaible=?,note=?,ename=?,syncDate=? where cid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
        }
    } else {
        result = [self addCustomInfo:custom];
    }
    [_db close];
    return result;
}
@end
