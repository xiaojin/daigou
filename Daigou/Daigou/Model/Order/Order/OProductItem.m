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
    NSArray *result = @[@(self.productid)?@(self.productid) :0,
                        @(self.refprice)?@(self.refprice) :0,
                        @(self.price)?@(self.price) :0,
                        @(self.amount)?@(self.amount) :0,
                        @(self.orderid)?@(self.orderid) :0,
                        @(self.orderdate)?@(self.orderdate) :0,
                        @(self.statu)?@(self.statu) :0,
                        self.note?self.note :@""];
    return result;
}


- (ProductOrderStatus) procurementStatus {
    if (self.orderid == 0) {
        return UnOrderProduct;
    } else
        return OrderProduct;
};

@end
