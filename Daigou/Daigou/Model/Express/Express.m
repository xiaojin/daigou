//
//  Express.m
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "Express.h"

@implementation Express
- (NSArray *)expressToArray {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:self.name?self.name : [NSNull null]];
    [result addObject:self.note?self.note : [NSNull null]];
    [result addObject:self.website?self.website : [NSNull null]];
    [result addObject:self.proxy?self.proxy : [NSNull null]];
    [result addObject:self.image?self.image : [NSNull null]];
    [result addObject:@(self.price)?@(self.price) : [NSNull null]];
    [result addObject:@(self.syncDate)?@(self.syncDate):[NSNull null]];
    return result;
}

@end
