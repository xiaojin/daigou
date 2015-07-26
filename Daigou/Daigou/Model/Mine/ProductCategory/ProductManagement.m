//
//  ProductManagement.m
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProductManagement.h"
#import <FMDB/FMDB.h>
#import "Product.h"
#import "CommonDefines.h"
#import "Brand.h"
#import "ProductCategory.h"
@implementation ProductManagement{
    FMDatabase *_db;
}

+ (instancetype)shareInstance {
    static ProductManagement *productManagement = nil;
    
    once_only(^{
        productManagement = [[self alloc] init];
    });
    
    return productManagement;
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

- (NSArray *)getProduct {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from product"];
    NSMutableArray *productArray = [NSMutableArray array];
    while (rs.next) {
        [productArray addObject:[self setValueForProduct:rs]];
    }
    [_db close];
    return productArray;
}

- (Product *)getProductById:(NSInteger)prodcutId {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from product where pid = ? ", @(prodcutId)];
    Product *product = [Product new];
    if (rs.next) {
       product = [self setValueForProduct:rs];
    }
    [_db close];
    return product;
}

- (NSArray *)getProductByBrand:(Brand *)brand {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from product where brandid = ?" , @(brand.bid)];
    NSMutableArray *productArray = [NSMutableArray array];
    while (rs.next) {
        [productArray addObject:[self setValueForProduct:rs]];
    }
    [_db close];
    return productArray;
}

- (NSArray *)getProductByCategory:(ProductCategory *)productCategory {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from product where categoryid = ?" , @(productCategory.cateid)];
    NSMutableArray *productArray = [NSMutableArray array];
    while (rs.next) {
        [productArray addObject:[self setValueForProduct:rs]];
    }
    [_db close];
    return productArray;
    
}

- (Product *)setValueForProduct:(FMResultSet *)rs {
    Product *product = [[Product alloc]init];
    product.pid = (NSInteger)[rs intForColumn:@"pid"];
    product.name = [rs stringForColumn:@"name"];
    product.categoryid = (NSInteger)[rs intForColumn:@"categoryid"];
    product.model = [rs stringForColumn:@"model"];
    product.brandid = (NSInteger)[rs intForColumn:@"brandid"];
    product.barcode = [rs stringForColumn:@"barcode"];
    product.quickid = [rs stringForColumn:@"quickid"];
    product.picture = [rs stringForColumn:@"picture"];
    product.rrp = [rs doubleForColumn:@"rrp"];
    product.purchaseprice = [rs doubleForColumn:@"purchaseprice"];
    product.costprice = [rs doubleForColumn:@"costprice"];
    product.lowestprice = [rs doubleForColumn:@"lowestprice"];
    product.agentprice = [rs doubleForColumn:@"agentprice"];
    product.saleprice = [rs doubleForColumn:@"saleprice"];
    product.sellprice = [rs doubleForColumn:@"sellprice"];
    product.wight = [rs doubleForColumn:@"wight"];
    product.prodDescription = [rs stringForColumn:@"description"];
    product.want = [rs intForColumn:@"want"];
    product.avaibility = [rs stringForColumn:@"avaibility"];
    product.function = [rs stringForColumn:@"function"];
    product.sellpoint= [rs stringForColumn:@"sellpoint"];
    product.note= [rs stringForColumn:@"note"];
    product.ename= [rs stringForColumn:@"ename"];
    return product;
}



- (BOOL)checkIfProductExists:(Product *)product {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from product where pid =(?)",[NSNumber numberWithInteger:product.pid]];
    if (rs.next) {
        return YES;
    } return NO;
}

- (BOOL)deleteCustomInfoByID:(NSString *)name {
    BOOL result = [_db executeUpdate:@"DELETE * from Clinet WHERE name LIKES '%?%'",name];
    return result;
}

- (BOOL)addProduct:(Product *)product{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into product (categoryid,name,model,brandid,barcode,quickid,picture,rrp,purchaseprice,costprice,lowestprice,agentprice,saleprice,sellprice,wight,description,want,avaibility,function,sellpoint,note,ename) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[product productToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)updateProduct:(Product *)product{
    BOOL exists = [self checkIfProductExists:product];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[product productToArray]];
        [updateData addObject:@(product.pid)];
        result= [_db executeUpdate:@"update product set categoryid=?,name=?,model=?,brandid=?,barcode=?,quickid=?,picture=?,rrp=?,purchaseprice=?,costprice=?,lowestprice=?,agentprice=?,saleprice=?,sellprice=?,wight=?,description=?,want=?,avaibility=?,function=?,sellpoint=?,note=?,ename=?  where pid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
            [_db close];
        }
    } else {
        result = [self addProduct:product];
    }
    [_db close];
    return result;
}

- (BOOL)deleteProduct:(Product *)product{
    return YES;
}
@end
