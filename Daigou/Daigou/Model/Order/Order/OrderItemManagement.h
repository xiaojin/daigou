//
//  OrderItemManagement.h
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"
#import "OProductItem.h"
#import "Express.h"
#import "OrderItemClient.h"

@interface OrderItemManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getOrderItems;
- (NSInteger)getLastInsertOrderId;
- (BOOL)updateOrderItem:(OrderItem *)orderItem;
- (NSArray *)getOrderProductsByOrderId:(NSInteger)orderid;
- (BOOL)updateOrderProduct:(NSArray *)products withOrderid:(NSInteger)orderid;
- (NSArray *)getOrderItemsByOrderStatus:(OrderStatus)status;
- (NSArray *)getAllProductsItemsNeedtoPurchase:(NSInteger)productid;
- (BOOL)updateProductItemToStock:(OProductItem *)product;
- (NSArray *)getOrderItemsByExpress:(Express *)express;
- (NSArray *)getprocurementProductItemsGroupByStatus:(ProductOrderStatus)procurementStatus;
- (NSArray *)getAllprocurementProductItemsWithOutGroup;
- (NSArray *)getstockProductItems;
- (NSArray *)getOrderItemsGroupbyProductidByOrderId:(NSInteger)orderid;
- (NSArray *)getUnOrderProducItemByStatus:(ItemStatus)itemStatus;
- (BOOL)updateProductItemWithProductItem:(OProductItem *)item;
- (BOOL)updateOrderProductItemWithProductItem:(OProductItem *)product;
- (void)insertOrderProductItems:(NSArray *)products;
- (void)removeOrderProductItems:(NSArray *)orderProducts;
- (NSArray *)getOrderProductItems:(OProductItem *)orderProduct;
- (BOOL)updateOrderItemPhotos:(NSString *)photsURL withOrderItem:(OrderItem *)orderItem;
- (NSString *)getOrderItemPhotosWithOrderItem:(OrderItem *)orderItem;
- (BOOL)updateTemperOrderItemsWithOrderId:(NSInteger)oid;
- (BOOL)deleteTemperOrderItems;
- (OrderItem *)getOrderItemByOrderId:(NSInteger)orderId;
@end
