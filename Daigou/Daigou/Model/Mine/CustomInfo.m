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
  [result addObject:self.name];
  [result addObject:self.email];
  [result addObject:self.idnum];
  [result addObject:[NSNumber numberWithInteger:self.agent]];
  [result addObject:self.address];
  [result addObject:self.address1];
  [result addObject:self.address2];
  [result addObject:self.address3];
  [result addObject:self.photofront];
  [result addObject:self.photoback];
  [result addObject:self.expressAvaible];
  [result addObject:self.note];
  [result addObject:self.ename];
  return result;
}
@end
