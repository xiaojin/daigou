//
//  OProductItem.m
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OProductItem.h"

@implementation OProductItem

- (NSArray *)orderProductToArray {
    NSArray *result = @[@(self.productid)?@(self.productid) :[NSNull null],
                        @(self.refprice)?@(self.refprice) :[NSNull null],
                        @(self.price)?@(self.price) :[NSNull null],
                        @(self.sellprice)?@(self.sellprice) :[NSNull null],
                        @(self.amount)?@(self.amount) :[NSNull null],
                        @(self.orderid)?@(self.orderid) :[NSNull null],
                        @(self.orderdate)?@(self.orderdate) :[NSNull null],
                        @(self.statu)?@(self.statu) :[NSNull null],
                        self.note?self.note :[NSNull null],
                        @(self.proxy)?@(self.proxy) :[NSNull null],
                        @(self.syncDate)?@(self.syncDate) :[NSNull null]];
    return result;
}


- (ProductOrderStatus) procurementStatus {
    if (self.orderid == 0) {
        return UnOrderProduct;
    } else
        return OrderProduct;
};

@end
