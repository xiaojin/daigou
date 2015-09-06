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
    [result addObject:self.name?self.name : [NSNull null]];
    [result addObject:self.image?self.image : [NSNull null]];
    [result addObject:@(self.visible) != 0 ? @(self.visible) :[NSNull null]];
    [result addObject:@(self.syncDate) != 0 ? @(self.syncDate) : [NSNull null]];
    return result;
}
@end
