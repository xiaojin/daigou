//
//  OrderItem.m
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

- (NSArray *)orderToArray {
    NSArray *result = @[ @(self.clientid)?@(self.clientid) :0 ,
                         @(self.statu)?@(self.statu) :0 ,
                         @(self.expressid)?@(self.expressid) :0,
                         @(self.parentoid)?@(self.parentoid) :0,
                         self.address?self.address :@"",
                         @(self.totoal)?@(self.totoal) :0,
                         @(self.discount)?@(self.discount) :0,
                         @(self.delivery)?@(self.delivery) :0,
                         @(self.subtotal)?@(self.subtotal) :0,
                         @(self.profit)?@(self.profit) :0,
                         @(self.creatDate)?@(self.creatDate) :0,
                         @(self.shipDate)?@(self.shipDate) :0,
                         @(self.deliverDate)?@(self.deliverDate) :0,
                         @(self.payDate)?@(self.payDate) :0,
                         self.note?self.note :@"",
                         self.barcode?self.barcode :@""];
    return result;
}

@end
