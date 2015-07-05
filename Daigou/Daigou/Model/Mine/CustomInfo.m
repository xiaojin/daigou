//
//  CustomInfo.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "CustomInfo.h"

@implementation CustomInfo


- (NSArray *)cutomToArray {
  NSMutableArray *result = [NSMutableArray array];
    [result addObject:self.name?self.name :@""];
  [result addObject:self.email?self.email :@""];
  [result addObject:self.idnum?self.idnum :@""];
  [result addObject:[NSNumber numberWithInteger:self.agent]?[NSNumber numberWithInteger:self.agent] :0];
  [result addObject:self.address?self.address :@""];
  [result addObject:self.address1?self.address1 :@""];
  [result addObject:self.address2?self.address2 :@""];
  [result addObject:self.address3?self.address3 :@""];
  [result addObject:self.photofront?self.photofront :@""];
  [result addObject:self.photoback?self.photoback :@""];
  [result addObject:self.expressAvaible?self.expressAvaible :@""];
  [result addObject:self.note?self.note :@""];
  [result addObject:self.ename?self.ename :@""];
  return result;
}
@end
