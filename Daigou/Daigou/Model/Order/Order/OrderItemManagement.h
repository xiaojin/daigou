//
//  OrderItemManagement.h
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderItem,OProductItem;
@interface OrderItemManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getOrderItems;
- (BOOL)updateOrderItem:(OrderItem *)orderItem;
- (NSArray *)getOrderProductsByOrderId:(NSInteger)orderid;
- (BOOL)updateOrderProduct:(NSArray *)products withOrderid:(NSInteger)orderid;
@end
