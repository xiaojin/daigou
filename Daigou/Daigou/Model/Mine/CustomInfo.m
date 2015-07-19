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
  NSArray *result = @[self.name?self.name :@"",
                      self.email?self.email :@"",
                      self.idnum?self.idnum :@"",
                      @(self.agent)?@(self.agent):0,
                      self.address?self.address :@"",
                      self.address1?self.address1 :@"",
                      self.address2?self.address2 :@"",
                      self.address3?self.address3 :@"",
                      self.photofront?self.photofront :@"",
                      self.photoback?self.photoback :@"",
                      self.expressAvaible?self.expressAvaible :@"",
                      self.note?self.note :@"",
                      self.ename?self.ename :@""];
  return result;
}
@end
