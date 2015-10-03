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
    BOOL isCombined;
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

- (OrderItem *)getOrderItemByOrderId:(NSInteger)orderId {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from orderitem where oid = ?",orderId];
    OrderItem *orderItem = nil;
    if (rs.next) {
        orderItem = [self setValueForItem:rs];
    }
    [_db close];
    return orderItem;
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

- (OrderItem *)setValueForItem:(FMResultSet *)rs{
    OrderItem *orderItem = [[OrderItem alloc]init];
    orderItem.oid = (NSInteger)[rs intForColumn:@"oid"];
    orderItem.clientid = (NSInteger)[rs intForColumn:@"clientid"];
    orderItem.statu = isCombined ?(OrderStatus) [rs intForColumn:@"orderstatu"] : (OrderStatus) [rs intForColumn:@"statu"];
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
    orderItem.creatDate = [rs doubleForColumn:@"createdate"];
    orderItem.shipDate = [rs doubleForColumn:@"shipdate"];
    orderItem.deliverDate = [rs doubleForColumn:@"deliverdate"];
    orderItem.payDate = [rs doubleForColumn:@"paydate"];
    orderItem.note = isCombined ? [rs stringForColumn:@"ordernote"] : [rs stringForColumn:@"note"] ;
    orderItem.barcode = [rs stringForColumn:@"barcode"];
    orderItem.idnum = [rs stringForColumn:@"idnum"];
    orderItem.proxy = isCombined ? [rs intForColumn:@"orderproxy"] : [rs intForColumn:@"proxy"];
    orderItem.noteImage = [rs stringForColumn:@"noteimage"];
    orderItem.syncDate = isCombined ? [rs doubleForColumn:@"ordersyncdate"]:[rs doubleForColumn:@"syncdate"];
    return orderItem;
}


- (CustomInfo *)setValueForCustomInfo:(FMResultSet *)rs{
    CustomInfo *customInfo = [[CustomInfo alloc]init];
    customInfo.cid = (NSInteger)[rs intForColumn:@"cid"];
    customInfo.name = [rs stringForColumn:@"name"];
    customInfo.email = [rs stringForColumn:@"email"];
    customInfo.phonenum = [rs  stringForColumn:@"phonenum"];
    customInfo.wechat = [rs stringForColumn:@"wechat"];
    customInfo.idnum = isCombined ? [rs stringForColumn:@"clientidnum"]:[rs stringForColumn:@"idnum"];
    customInfo.postcode = isCombined ? [rs stringForColumn:@"clientpostcode"]:[rs stringForColumn:@"postcode"];
    customInfo.agent = (NSInteger)[rs intForColumn:@"agent"];
    customInfo.address = isCombined ? [rs stringForColumn:@"clientaddress"]:[rs stringForColumn:@"address"];
    customInfo.address1 = [rs stringForColumn:@"address1"];
    customInfo.address2 = [rs stringForColumn:@"address2"];
    customInfo.address3 = [rs stringForColumn:@"address3"];
    customInfo.photofront = [rs stringForColumn:@"photofront"];
    customInfo.photoback = [rs stringForColumn:@"photoback"];
    customInfo.expressAvaible = [rs stringForColumn:@"expressavaible"];
    customInfo.note = isCombined ? [rs stringForColumn:@"clientnote"]:[rs stringForColumn:@"note"];
    customInfo.ename = [rs stringForColumn:@"ename"];
    customInfo.syncDate = isCombined ? [rs doubleForColumn:@"clientsyncdate"]:[rs doubleForColumn:@"syncdate"];
    return customInfo;
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
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
  //  BOOL exists = [self checkIfOrderItmExists:orderItem];
    BOOL result;
    if (orderItem.oid != 0) {
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



- (NSArray*)getAllOrderProducts {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item"];
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



- (NSArray *)getprocurementProductItemsGroupByStatus:(ProductOrderStatus)procurementStatus {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = nil;
    if (procurementStatus == OrderProduct) {
        rs = [_db executeQuery:@"select *,count(*) as count from item where statu =0 and orderid is not null group by productid"];
    } else {
        //囤货清单列表
        rs = [_db executeQuery:@"select *,count(*) as count from item where statu =0 and orderid is null group by productid"];
    }
    
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        OProductItem *productItem = [self setValueForOrderItem:rs];
        NSInteger productCount = (NSInteger) [rs intForColumn:@"count"];
        NSDictionary *orderGroupDict = @{@"oproductitem":productItem,
                                         @"count":@(productCount)};
        [orderItemsArray addObject:orderGroupDict];
    }
    [_db close];
    return orderItemsArray;
}

- (NSArray *)getAllprocurementProductItemsWithOutGroup {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select iid,productid,refprice,price,sellprice,amount,orderid,orderdate,item.statu as statu,item.note as note,item.proxy as proxy,item.syncDate as syncDate,oid,clientid,orderitem.statu as orderStatu,expressid,parentoid,free_ship,orderitem.address as address,reviever,phonenumber,orderitem.postcode as postcode,total,discount,delivery,subtotal,profit,othercost,createDate,shipDate,deliverDate,payDate,orderitem.note as orderNote,barcode,orderitem.idnum as idnum,orderitem.proxy as orderProxy, noteImage, orderitem.syncDate as orderSyncDate, cid,name,ename,email,phonenum,wechat, client.idnum as clientIdnum, client.postcode as clientPostCode, agent,client.address as clientAddress,address1, address2,address3,photofront,photoback,expressAvaible, client.syncDate as clientSyncDate, client.note as clientNote from item ,orderitem, client where item.orderid = orderitem.oid and orderitem.clientid = client.cid and item.statu = 0 and item.orderid is not null"];

    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        isCombined = true;
        OProductItem *productItem = [self setValueForOrderItem:rs];
        OrderItem *orderItem = [self setValueForItem:rs];
        CustomInfo *customInfo = [self setValueForCustomInfo:rs];
        OrderItemClient *orderItemClient = [OrderItemClient new];
        orderItemClient.productItem = productItem;
        orderItemClient.orderItem = orderItem;
        orderItemClient.customInfo = customInfo;
        [orderItemsArray addObject:orderItemClient];
    }
    [_db close];
    isCombined = false;
    return orderItemsArray;
}


- (NSArray *)getstockProductItems {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select *,count(*) as count from item where statu = (?) and orderid is null group by productid",@(PRODUCT_INSTOCK)];
    
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        OProductItem *productItem = [self setValueForOrderItem:rs];
        NSInteger productCount = (NSInteger) [rs intForColumn:@"count"];
        NSDictionary *orderGroupDict = @{@"oproductitem":productItem,
                                         @"count":@(productCount)};
        [orderItemsArray addObject:orderGroupDict];
    }
    [_db close];
    return orderItemsArray;
}



- (NSArray *)getUnOrderProducItemByStatus:(ItemStatus)itemStatus {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item where orderid is null and statu = ?",@(itemStatus)];
    NSMutableArray *itemsArray = [NSMutableArray array];
    while (rs.next) {
        OProductItem *productItem = [self setValueForOrderItem:rs];
        [itemsArray addObject:productItem];
    }
    [_db close];
    return itemsArray;
}


- (BOOL)updateProductItemWithProductItem:(NSArray *)orderitems withNull:(BOOL) setNull{
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result = false;
    for (int i =0; i < [orderitems count]; i ++) {
        OProductItem* item = orderitems[i];
        id orderid;
        if (item.orderid == 0 && setNull) {
            orderid = [NSNull null];
        } else {
            orderid = @(item.orderid);
        }
        result = [_db executeUpdate:@"update item set productid = (?),refprice = (?),price = (?), sellprice = (?),amount = (?),orderid = (?),orderdate = (?),statu = (?),note = (?),proxy = (?),syncdate = (?) where iid = (?)",@(item.productid),@(item.refprice),@(item.price),@(item.sellprice),@(item.amount),orderid,@(item.orderdate),@(item.statu),item.note,@(item.proxy),@(item.syncDate),@(item.iid)];
    }
    [_db close];
    return result;
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
    productItem.syncDate = [rs doubleForColumn:@"syncdate"];
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

- (NSArray *)getAllProductsItemsNeedtoPurchase:(NSInteger)productid {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from item where statu = 0 and orderid is not null and productid = (?)",@(productid)];
    
    NSMutableArray *orderItemsArray = [NSMutableArray array];
    while (rs.next) {
        [orderItemsArray addObject:[self setValueForOrderItem:rs]];
    }
    [_db close];
    return orderItemsArray;
}


- (BOOL)updateProductItemToStock:(OProductItem *)product {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    BOOL result;
    result = [_db executeUpdate:@"update item set price = (?),statu = (?) where iid = (?)",@(product.price),@(product.statu),@(product.iid)];
    [_db close];
    return result;
}


- (void)insertOrderProductItems:(NSArray *)products withNull:(BOOL) setNull; {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    for (int i=0; i<[products count]; i++) {
        OProductItem *orderProductItem = [products objectAtIndex:i];
        if (setNull && orderProductItem.orderid == 0) {
        [_db executeUpdate:@"insert into item (productid,refprice,price,sellprice,amount,orderid,orderdate,statu,note,proxy,syncDate) values (?,?,?,?,?,?,?,?,?,?,?)",@(orderProductItem.productid),@(orderProductItem.refprice),@(orderProductItem.price),@(orderProductItem.sellprice),@(orderProductItem.amount),[NSNull null],@(orderProductItem.orderdate),@(orderProductItem.statu),orderProductItem.note,@(orderProductItem.proxy),@(orderProductItem.syncDate)];
        } else {
        [_db executeUpdate:@"insert into item (productid,refprice,price,sellprice,amount,orderid,orderdate,statu,note,proxy,syncDate) values (?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[orderProductItem orderProductToArray]];
        }

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
    [_db executeUpdate:@"update item set orderid = null where orderid = 0 and statu = ?", @(PRODUCT_INSTOCK)];
    result = [_db executeUpdate:@"delete from item where orderid = 0"];
    [_db close];
    return result;
}
@end
