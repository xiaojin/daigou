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
    CustomInfo *customInfo = [[CustomInfo alloc]init];
    customInfo.cid = (NSInteger)[rs intForColumn:@"cid"];
    customInfo.name = [rs stringForColumn:@"name"];
    customInfo.email = [rs stringForColumn:@"email"];
    customInfo.idnum = [rs stringForColumn:@"idnum"];
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
    [customArray addObject:customInfo];
  }
    [_db close];
  return customArray;
}

- (BOOL)checkIfCustomExists:(CustomInfo *)custom {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
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
  BOOL result = [_db executeUpdate:@"INSERT INTO Client VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[custom cutomToArray]];
  return result;
}

- (BOOL)updateCustomInfo:(CustomInfo *)custom{
    BOOL exists = [self checkIfCustomExists:custom];
    BOOL result;
    if (exists) {
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[custom cutomToArray]];
        [updateData addObject:[NSNumber numberWithInteger:custom.cid]];
         result= [_db executeUpdate:@"update client set (?,?,?,?,?,?,?,?,?,?,?,?,?) where cid = (?)" withArgumentsInArray:updateData];
    } else {
        result = [self addCustomInfo:custom];
    }
    [_db close];
    return result;
}
@end
