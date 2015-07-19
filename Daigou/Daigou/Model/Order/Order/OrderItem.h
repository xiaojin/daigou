//
//  OrderItem.h
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PURCHASED = 0,
    PACKAGE = 10,
    DELIVERD = 20,
    SHIPPED = 30,
    DONE = 40
} OrderStatus;

@interface OrderItem : NSObject
@property(nonatomic,assign)NSInteger oid;
@property(nonatomic,assign)NSInteger clientid;
@property(nonatomic,assign)OrderStatus statu;
@property(nonatomic,assign)NSInteger expressid;
@property(nonatomic,assign)NSInteger parentoid;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, assign)float totoal;
@property(nonatomic, assign)float discount;
@property(nonatomic, assign)float delivery;
@property(nonatomic, assign)float subtotal;
@property(nonatomic, assign)float profit;
@property(nonatomic,assign)NSInteger creatDate;
@property(nonatomic,assign)NSInteger shipDate;
@property(nonatomic,assign)NSInteger deliverDate;
@property(nonatomic,assign)NSInteger payDate;
@property(nonatomic, copy)NSString *note;
@property(nonatomic, copy)NSString *barcode;

- (NSArray *)orderToArray;
@end
