//
//  CustomInfo.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "CustomInfo.h"
#import "NSString+StringToPinYing.h"

@implementation CustomInfo


- (NSArray *)cutomToArray {
    if ((self.ename == nil || [self.ename isEqualToString:@""]) && self.name !=nil && ![self.name isEqualToString:@""]) {
        self.ename = [self.name transformToPinyin];
    }
  NSArray *result = @[self.name?self.name :[NSNull null],
                      self.email?self.email :[NSNull null],
                      self.phonenum?self.phonenum:[NSNull null],
                      self.wechat?self.wechat:[NSNull null],
                      (self.idnum==nil || [self.idnum isEqualToString:@""])?[NSNull null] : self.idnum,
                      self.postcode?self.postcode : [NSNull null],
                      @(self.agent)?@(self.agent):[NSNull null],
                      self.address?self.address :[NSNull null],
                      self.address1?self.address1 :[NSNull null],
                      self.address2?self.address2 :[NSNull null],
                      self.address3?self.address3 :[NSNull null],
                      self.photofront?self.photofront :[NSNull null],
                      self.photoback?self.photoback :[NSNull null],
                      self.expressAvaible?self.expressAvaible :[NSNull null],
                      self.note?self.note :[NSNull null],
                      self.ename?self.ename :[NSNull null],
                      @(self.syncDate)? @(self.syncDate):[NSNull null]];
  return result;
}
@end
