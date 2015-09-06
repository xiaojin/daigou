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
    [result addObject:self.name?self.name : @""];
    [result addObject:self.note?self.note : @""];
    [result addObject:self.website];
    [result addObject:self.proxy];
    [result addObject:self.image];
    return result;
}

@end
