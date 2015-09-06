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
    NSArray *result = @[ @(self.clientid)?@(self.clientid) :[NSNull null] ,
                         @(self.statu)?@(self.statu) :[NSNull null],
                         @(self.expressid)?@(self.expressid) :[NSNull null],
                         @(self.parentoid)?@(self.parentoid) :[NSNull null],
                         @(self.freeShip)?@(self.freeShip) :[NSNull null],
                         self.address?self.address :[NSNull null],
                         self.reviever?self.reviever :[NSNull null],
                         self.phonenumber?self.phonenumber :[NSNull null],
                         self.postcode?self.postcode :[NSNull null],
                         @(self.totoal)?@(self.totoal) :[NSNull null],
                         @(self.discount)?@(self.discount) :[NSNull null],
                         @(self.delivery)?@(self.delivery) :[NSNull null],
                         @(self.subtotal)?@(self.subtotal) :[NSNull null],
                         @(self.profit)?@(self.profit) :[NSNull null],
                         @(self.othercost)?@(self.othercost) :[NSNull null],
                         @(self.creatDate)?@(self.creatDate) :[NSNull null],
                         @(self.shipDate)?@(self.shipDate) :[NSNull null],
                         @(self.deliverDate)?@(self.deliverDate) :[NSNull null],
                         @(self.payDate)?@(self.payDate) :[NSNull null],
                         self.note?self.note :[NSNull null],
                         self.barcode?self.barcode :[NSNull null],
                         self.idnum?self.idnum :[NSNull null],
                         @(self.proxy)?@(self.proxy) :[NSNull null],
                         self.noteImage?self.noteImage :[NSNull null],
                         @(self.syncDate)?@(self.syncDate) :[NSNull null]];
    return result;
    
}

@end
