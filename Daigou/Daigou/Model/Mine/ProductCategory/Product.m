//
//  Product.m
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "Product.h"

@implementation Product

- (NSArray *)productToArray {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@(self.categoryid)];
    [result addObject:self.name?self.name : @""];
    [result addObject:self.model?self.model : @""];
    [result addObject:@(self.brandid)];
    
    [result addObject:self.barcode?self.barcode : @""];
    [result addObject:self.quickid?self.quickid : @""];
    [result addObject:self.picture?self.picture : @""];
    [result addObject:@(self.rrp)?@(self.rrp) :@(0.0f)];
    
    [result addObject:@(self.purchaseprice)?@(self.purchaseprice) : @(0.0f)];
    [result addObject:@(self.costprice)?@(self.costprice) : @(0.0f)];
    [result addObject:@(self.lowestprice)?@(self.lowestprice) : @(0.0f)];
    [result addObject:@(self.agentprice)?@(self.agentprice) : @(0.0f)];
    
    [result addObject:@(self.saleprice)?@(self.saleprice) : @(0.0f)];
    [result addObject:@(self.sellprice)?@(self.sellprice) : @(0.0f)];
    [result addObject:@(self.wight)?@(self.wight) : @(0.0f)];
    [result addObject:self.prodDescription?self.prodDescription : @""];
    
    [result addObject:@(self.want)?@(self.want) :@(0.0f)];
    [result addObject:self.avaibility?self.avaibility : @""];
    [result addObject:self.function?self.function : @""];
    [result addObject:self.sellpoint?self.sellpoint : @""];
    
    [result addObject:self.note?self.note : @""];
    [result addObject:self.ename?self.ename : @""];

    return result;
}
@end
