//
//  Brand.m
//  Daigou
//
//  Created by jin on 10/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "Brand.h"

@implementation Brand

- (NSArray *)brandToArray {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:self.name?self.name : @""];
    [result addObject:self.image?self.image : @""];
    return result;
}
@end
