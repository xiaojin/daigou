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
        [orderItemsArray addObject:[self setValueForItem:rs]];
    }
    [_db close];
    return orderItemsArray;
}

- (NSInteger)getLastInsertOrderId {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return 0 ;
    }
    FMResultSet *rs = [_db executeQuery:@"select oid from orderitem where oid = (select max(oid) from orderitem)"];
    NSInteger lastoid ;
    if (rs.next)  {
        lastoid = [rs intForColumn:@"oid"];
    }
    [_db close];
    return lastoid;

}

- (NSArray*)getOrderItemsByOrderStatus:(OrderStatus)status {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem where statu = (?)",@(status)];
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        [orderItemsArray addObject:[self setValueForItem:rs]];
    }
    [_db close];
    return orderItemsArray;

}

- (NSArray *)getOrderItemsByExpress:(Express *)express {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = nil;
    rs = [_db executeQuery:@"select * from orderitem where expressid = (?)",@(express.eid)];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    while (rs.next) {
        [itemsArray addObject:[self setValueForItem:rs]];
    }
    [_db close];
    return itemsArray;
}

- (OrderItem *)setValueForItem:(FMResultSet *)rs {
    OrderItem *orderItem = [[OrderItem alloc]init];
    orderItem.oid = (NSInteger)[rs intForColumn:@"oid"];
    orderItem.clientid = (NSInteger)[rs intForColumn:@"clientid"];
    orderItem.statu = (OrderStatus) [rs intForColumn:@"statu"];
    orderItem.expressid = (NSInteger) [rs intForColumn:@"expressid"];
    orderItem.parentoid = (NSInteger)[rs intForColumn:@"parentoid"];
    orderItem.freeShip = (NSInteger) [rs intForColumn:@"free_ship"];
    orderItem.address = [rs stringForColumn:@"address"];
    orderItem.reviever = [rs stringForColumn:@"reviever"];
    orderItem.phonenumber = [rs stringForColumn:@"phonenumber"];
    orderItem.postcode = [rs stringForColumn:@"postcode"];
    orderItem.totoal = (float)[rs doubleForColumn:@"total"];
    orderItem.discount = [rs doubleForColumn:@"discount"];
    orderItem.delivery = [rs doubleForColumn:@"delivery"];
    orderItem.subtotal = [rs doubleForColumn:@"subtotal"];
    orderItem.profit = [rs doubleForColumn:@"profit"];
    orderItem.othercost = [rs doubleForColumn:@"othercost"];
    orderItem.creatDate = [rs doubleForColumn:@"createDate"];
    orderItem.shipDate = [rs doubleForColumn:@"shipDate"];
    orderItem.deliverDate = [rs doubleForColumn:@"deliverDate"];
    orderItem.payDate = [rs doubleForColumn:@"payDate"];
    orderItem.note = [rs stringForColumn:@"note"];
    orderItem.barcode = [rs stringForColumn:@"barcode"];
    orderItem.idnum = [rs stringForColumn:@"idnum"];
    orderItem.proxy = [rs intForColumn:@"proxy"];
    orderItem.noteImage = [rs stringForColumn:@"noteImage"];
    orderItem.syncDate = [rs doubleForColumn:@"syncDate"];
    return orderItem;
}

- (BOOL)checkIfOrderItmExists:(OrderItem *)ordeItem {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem where oid =(?)",@(ordeItem.oid)];
    if (rs.next) {
        return YES;
    }
    return NO;
}

- (BOOL)addOrder:(OrderItem *)orderItem{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into orderitem (clientid,statu,expressid,parentoid,free_ship,address,reviever,phonenumber,postcode,total,discount,delivery,subtotal,profit,othercost,createDate,shipDate,deliverDate,payDate,note,barcode,idnum,proxy,noteImage,syncDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[orderItem orderToArray]];
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
        result= [_db executeUpdate:@"update orderitem set clientid=?,statu=?,expressid=?,parentoid=?,free_ship=?,address=?,reviever=?,phonenumber=?,postcode=?,total=?,discount=?,delivery=?,subtotal=?,profit=?,othercost=?,createDate=?,shipDate=?,deliverDate=?,payDate=? ,note=?,barcode = ?,idnum =?,proxy=?,noteImage=?,syncDate=?  where oid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
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
        [orderProductsArray addObject:[self setValueForOrderItem:rs]];
    }
    [_db close];
    return orderProductsArray;
}

- (BOOL)updateOrderProduct:(NSArray *)products withOrderid:(NSInteger)orderid  {
    
    BOOL result;
    result = [_db executeUpdate:@"delete from item where orderid = (?)",@(orderid)];
    [_db commit];
    if (result) {
        for (OProductItem *productItem in products) {
              [_db executeUpdate:@"insert into item (productid,refprice,price,sellprice,amount,orderid,orderdate,statu,note,proxy,syncDate) values (?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[productItem orderProductToArray]];
        }
    } else {
        NSLog(@"Delete product item error");
    }
    [_db commit];
    [_db close];
    return result;
    
}

- (NSArray *)getprocurementProductItemsByStatus:(ProductOrderStatus)procurementStatus {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = nil;
    if (procurementStatus == OrderProduct) {
        rs = [_db executeQuery:@"select * from item where orderid is not NULL and statu = 0"];
    } else {
        rs = [_db executeQuery:@"select * from item where orderid is NULL and statu = 0"];
    }

    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        [orderItemsArray addObject:[self setValueForOrderItem:rs]];
    }
    [_db close];
    return orderItemsArray;

}


- (NSArray *)getstockProductItems {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item where statu = (?)",@(PRODUCT_INSTOCK)];
    
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        [orderItemsArray addObject:[self setValueForOrderItem:rs]];
    }
    [_db close];
    return orderItemsArray;
}

- (NSArray *)getOrderItemsGroupbyProductidByOrderId:(NSInteger)orderid {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select *,count(*) as count from item where orderid = (?) group by productid",@(orderid)];
    NSMutableArray *groupOrderItemsArray = [NSMutableArray array];
    while (rs.next) {
        OProductItem *productItem = [self setValueForOrderItem:rs];
        NSInteger productCount = (NSInteger) [rs intForColumn:@"count"];
        NSDictionary *orderGroupDict = @{@"oproductitem":productItem,
                                         @"count":@(productCount)};
        [groupOrderItemsArray addObject:orderGroupDict];
    }
    [_db close];
    return groupOrderItemsArray;
}

- (OProductItem *)setValueForOrderItem:(FMResultSet *)rs {
    OProductItem *productItem = [[OProductItem alloc]init];
    productItem.iid = (NSInteger)[rs intForColumn:@"iid"];
    productItem.productid = (NSInteger)[rs intForColumn:@"productid"];
    productItem.refprice = (OrderStatus) [rs doubleForColumn:@"refprice"];
    productItem.price = (float) [rs doubleForColumn:@"price"];
    productItem.sellprice = (float) [rs doubleForColumn:@"sellprice"];
    productItem.amount = (float)[rs doubleForColumn:@"amount"];
    productItem.orderid = [rs intForColumn:@"orderid"];
    productItem.orderdate = (float)[rs intForColumn:@"orderdate"];
    productItem.statu = [rs intForColumn:@"statu"];
    productItem.note = [rs stringForColumn:@"note"];
    productItem.proxy = [rs intForColumn:@"proxy"];
    productItem.syncDate = [rs doubleForColumn:@"syncDate"];
    return productItem;
}

- (NSArray *)getOrderProductItems:(OProductItem *)orderProduct {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item where orderid = (?) and productid = (?)",@(orderProduct.orderid),@(orderProduct.productid)];
    
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        [orderItemsArray addObject:[self setValueForOrderItem:rs]];
    }
    [_db close];
    return orderItemsArray;
}

- (BOOL)updateOrderProductItemWithProductItem:(OProductItem *)product {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result;
    result = [_db executeUpdate:@"update item set sellprice = (?),orderdate=(?) where orderid = (?) and productid = (?)",@(product.sellprice),@(product.orderdate),@(product.orderid),@(product.productid)];
    [_db close];
    return result;
}

- (void)insertOrderProductItems:(NSArray *)products {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    for (int i=0; i<[products count]; i++) {
        OProductItem *orderProductItem = [products objectAtIndex:i];
        [_db executeUpdate:@"insert into item (productid,refprice,price,sellprice,amount,orderid,orderdate,statu,note,proxy,syncDate) values (?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[orderProductItem orderProductToArray]];
    }
    [_db close];
}

- (void)removeOrderProductItems:(NSArray *)orderProducts {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    for (int i=0; i<[orderProducts count]; i++) {
        OProductItem *orderProductItem = [orderProducts objectAtIndex:i];
        [_db executeUpdate:@"delete from item where iid = (?)",@(orderProductItem.iid)];
    }
}
- (BOOL)updateOrderItemPhotos:(NSString *)photsURL withOrderItem:(OrderItem *)orderItem{
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result;
    result = [_db executeUpdate:@"update orderitem set noteImage = (?) where oid = (?)",photsURL,@(orderItem.oid)];
    [_db close];
    return result;
}

- (NSString *)getOrderItemPhotosWithOrderItem:(OrderItem *)orderItem{
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    NSString *photosUrls = @"";
    FMResultSet *rs = [_db executeQuery:@"select noteImage from orderitem where oid = (?)",@(orderItem.oid)];
    if (rs.next) {
        photosUrls = [rs stringForColumn:@"noteImage"];
    }
    [_db close];
    return photosUrls;
}

- (BOOL)updateTemperOrderItemsWithOrderId:(NSInteger)oid {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result;
    result = [_db executeUpdate:@"update item set orderid = (?) where orderid = 0",@(oid)];
    [_db close];
    return result;
}

- (BOOL)deleteTemperOrderItems {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result;
    result = [_db executeUpdate:@"delete from item where orderid = 0"];
    [_db close];
    return result;
}
@end
