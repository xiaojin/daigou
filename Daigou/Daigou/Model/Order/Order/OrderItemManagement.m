//
//  OrderItemManagement.m
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItemManagement.h"
#import "CommonDefines.h"
#import "OrderItem.h"
#import "OProductItem.h"
#import <FMDB/FMDB.h>

@implementation OrderItemManagement{
    FMDatabase *_db;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *stringPath = DATABASE_PATH;
        _db = [FMDatabase databaseWithPath:stringPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            // The database file does not exist in the documents directory, so copy it from the main bundle now.
            NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"daigou.db"];
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:stringPath error:&error];
            
            // Check if any error occurred during copying and display it.
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }
    return self;
}

+ (instancetype)shareInstance {
    static OrderItemManagement *orderManagement = nil;
    
    once_only(^{
        orderManagement = [[self alloc] init];
    });
    
    return orderManagement;
}

- (NSArray *)getOrderItems {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem"];
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        OrderItem *orderItem = [[OrderItem alloc]init];
        orderItem.oid = (NSInteger)[rs intForColumn:@"oid"];
        orderItem.clientid = (NSInteger)[rs intForColumn:@"clientid"];
        orderItem.statu = (OrderStatus) [rs intForColumn:@"statu"];
        orderItem.expressid = (NSInteger) [rs intForColumn:@"expressid"];
        orderItem.parentoid = (NSInteger)[rs intForColumn:@"parentoid"];
        orderItem.address = [rs stringForColumn:@"address"];
        orderItem.totoal = (float)[rs doubleForColumn:@"total"];
        orderItem.discount = [rs doubleForColumn:@"discount"];
        orderItem.delivery = [rs doubleForColumn:@"delivery"];
        orderItem.subtotal = [rs doubleForColumn:@"subtotal"];
        orderItem.profit = [rs doubleForColumn:@"profit"];
        orderItem.creatDate = [rs intForColumn:@"createDate"];
        orderItem.shipDate = [rs intForColumn:@"shipDate"];
        orderItem.deliverDate = [rs intForColumn:@"deliverDate"];
        orderItem.payDate = [rs intForColumn:@"payDate"];
        orderItem.note = [rs stringForColumn:@"note"];
        orderItem.barcode = [rs stringForColumn:@"barcode"];
        [orderItemsArray addObject:orderItem];
    }
    [_db close];
    return orderItemsArray;
}

- (NSArray*)getOrderItemsByOrderStatus:(OrderStatus)status {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem where statu = (?)",@(status)];
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        OrderItem *orderItem = [[OrderItem alloc]init];
        orderItem.oid = (NSInteger)[rs intForColumn:@"oid"];
        orderItem.clientid = (NSInteger)[rs intForColumn:@"clientid"];
        orderItem.statu = (OrderStatus) [rs intForColumn:@"statu"];
        orderItem.expressid = (NSInteger) [rs intForColumn:@"expressid"];
        orderItem.parentoid = (NSInteger)[rs intForColumn:@"parentoid"];
        orderItem.address = [rs stringForColumn:@"address"];
        orderItem.totoal = (float)[rs doubleForColumn:@"total"];
        orderItem.discount = [rs doubleForColumn:@"discount"];
        orderItem.delivery = [rs doubleForColumn:@"delivery"];
        orderItem.subtotal = [rs doubleForColumn:@"subtotal"];
        orderItem.profit = [rs doubleForColumn:@"profit"];
        orderItem.creatDate = [rs intForColumn:@"createDate"];
        orderItem.shipDate = [rs intForColumn:@"shipDate"];
        orderItem.deliverDate = [rs intForColumn:@"deliverDate"];
        orderItem.payDate = [rs intForColumn:@"payDate"];
        orderItem.note = [rs stringForColumn:@"note"];
        orderItem.barcode = [rs stringForColumn:@"barcode"];
        [orderItemsArray addObject:orderItem];
    }
    [_db close];
    return orderItemsArray;

}

- (BOOL)checkIfOrderItmExists:(OrderItem *)ordeItem {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem where oid =(?)",@(ordeItem.oid)];
    if (rs.next) {
        return YES;
    }
    return NO;
}

- (BOOL)addOrder:(OrderItem *)orderItem{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into orderitem (clientid,statu,expressid,parentoid,address,total,discount,delivery,subtotal,profit,createDate,shipDate,deliverDate,payDate,note,barcode) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[orderItem orderToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)updateOrderItem:(OrderItem *)orderItem {
    BOOL exists = [self checkIfOrderItmExists:orderItem];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[orderItem orderToArray]];
        [updateData addObject:@(orderItem.oid)];
        result= [_db executeUpdate:@"update orderitem set clientid=?,statu=?,expressid=?,parentoid=?,address=?,total=?,discount=?,delivery=?,subtotal=?,profit=?,createDate=?,shipDate=?,deliverDate=?,payDate=? ,note=?,barcode = ?  where oid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
            [_db close];
        }
    } else {
        result = [self addOrder:orderItem];
    }
    [_db close];
    return result;

}

- (NSArray *)getOrderProductsByOrderId:(NSInteger)orderid {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item where orderid = (?) ",@(orderid)];
    NSMutableArray *orderProductsArray = [NSMutableArray array];
    while (rs.next) {
        OProductItem *orderProd = [[OProductItem alloc]init];
        orderProd.iid = (NSInteger)[rs intForColumn:@"iid"];
        orderProd.productid = (NSInteger)[rs intForColumn:@"productid"];
        orderProd.refprice = (OrderStatus) [rs doubleForColumn:@"refprice"];
        orderProd.price = (NSInteger) [rs doubleForColumn:@"price"];
        orderProd.amount = (NSInteger)[rs doubleForColumn:@"amount"];
        orderProd.orderid = [rs intForColumn:@"orderid"];
        orderProd.orderdate = (float)[rs intForColumn:@"orderdate"];
        orderProd.statu = [rs intForColumn:@"statu"];
        orderProd.note = [rs stringForColumn:@"note"];
        [orderProductsArray addObject:orderProd];
    }
    [_db close];
    return orderProductsArray;
}

- (BOOL)updateOrderProduct:(NSArray *)products withOrderid:(NSInteger)orderid  {
    
    BOOL result;
    result = [_db executeQuery:@"delete from item where orderid = (?)",@(orderid)];
    [_db commit];
    if (result) {
        for (OProductItem *productItem in products) {
              [_db executeUpdate:@"insert into item (productid,refprice,price,amount,orderid,orderdate,statu,note) values (?,?,?,?,?,?,?,?)" withArgumentsInArray:[productItem orderProductToArray]];
        }
    } else {
        NSLog(@"Delete product item error");
    }
    [_db commit];
    [_db close];
    return result;
    
}
    
@end
