//
//  CustomInfoManagement.h
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CustomInfo;

@interface CustomInfoManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getCustomInfo;
- (BOOL)deleteCustomInfoByID:(NSInteger)idnum;
- (BOOL)saveCustomInfo:(CustomInfo *)custom;
@end
