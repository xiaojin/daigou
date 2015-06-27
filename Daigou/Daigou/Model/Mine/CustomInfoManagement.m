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
    _db = [[FMDatabase alloc]initWithPath:stringPath];
  }
  return self;
}

- (NSArray *)getCustomInfo {
  FMResultSet *rs = [_db executeQuery:@"SELECT * FROM Client"];
  NSMutableArray *customArray = [NSMutableArray array];
  while (rs.next) {
    CustomInfo *customInfo = [[CustomInfo alloc]init];
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
  return customArray;
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
  NSMutableArray *updateData = [NSMutableArray arrayWithArray:[custom cutomToArray]];
  [updateData addObject:custom.name];
  BOOL result = [_db executeUpdate:@"UPDATE Client SET (?,?,?,?,?,?,?,?,?,?,?,?,?) WHERE name LIKES '%?%'" withArgumentsInArray:updateData];
  return result;
}
@end
