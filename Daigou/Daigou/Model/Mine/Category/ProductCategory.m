//
//  Category.m
//  Daigou
//
//  Created by jin on 10/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProductCategory.h"

@implementation ProductCategory

- (NSArray *)categoryToArray {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:self.name?self.name : [NSNull null]];
    [result addObject:self.image?self.image : [NSNull null]];
    [result addObject:@(self.syncDate)?@(self.syncDate) :[NSNull null]];
    return result;
}
@end
