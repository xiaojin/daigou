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
@implementation CustomInfoManagement

+ (instancetype)shareInstance {
  static CustomInfoManagement *customInfoManagement = nil;
  
  once_only(^{
    customInfoManagement = [[self alloc] init];
  });
  
  return customInfoManagement;
}

- (instancetype)init {
  if (self = [super init]) {
    
  }
  return self;
}

- (NSArray *)getCustomInfo {
  return nil;
}

- (BOOL)deleteCustomInfoByID:(NSInteger)idnum {

  return false;
}

- (BOOL)saveCustomInfo:(CustomInfo *)custom{

  return false;
}
@end
