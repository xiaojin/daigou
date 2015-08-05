//
//  ProductWithCount.m
//  Daigou
//
//  Created by jin on 1/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProductWithCount.h"

@implementation ProductWithCount

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_product forKey:@"productobject"];
    [aCoder encodeInteger:_productNum forKey:@"productNum"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.product = [aDecoder decodeObjectForKey:@"productobject"];
        self.productNum = [aDecoder decodeIntForKey:@"productNum"];
    }
    return self;
}


@end
