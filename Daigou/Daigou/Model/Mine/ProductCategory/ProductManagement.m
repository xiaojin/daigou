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
    FMResultSet *rs = [_db executeQuery:@"select * from client"];
    NSMutableArray *productArray = [NSMutableArray array];
    while (rs.next) {
//        Product *product = [[Product alloc]init];
//        customInfo.cid = (NSInteger)[rs intForColumn:@"cid"];
//        customInfo.name = [rs stringForColumn:@"name"];
//        customInfo.email = [rs stringForColumn:@"email"];
//        customInfo.idnum = [rs stringForColumn:@"idnum"];
//        customInfo.agent = (NSInteger)[rs intForColumn:@"agent"];
//        customInfo.address = [rs stringForColumn:@"address"];
//        customInfo.address1 = [rs stringForColumn:@"address1"];
//        customInfo.address2 = [rs stringForColumn:@"address2"];
//        customInfo.address3 = [rs stringForColumn:@"address3"];
//        customInfo.photofront = [rs stringForColumn:@"photofront"];
//        customInfo.photoback = [rs stringForColumn:@"photoback"];
//        customInfo.expressAvaible = [rs stringForColumn:@"expressAvaible"];
//        customInfo.note = [rs stringForColumn:@"note"];
//        customInfo.ename = [rs stringForColumn:@"ename"];
//        [customArray addObject:customInfo];
    }
    [_db close];
    return productArray;
}

- (BOOL)checkIfProductExists:(Product *)product {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from client where cid =(?)",[NSNumber numberWithInteger:product.pid]];
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
    BOOL result = [_db executeUpdate:@"insert into client (name,email,idnum,agent,address,address1,address2,address3,photofront,photoback,expressAvaible,note,ename) values (?,?,?,?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:[product productToArray]];
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
        result= [_db executeUpdate:@"update client set name=?,email=?,idnum=?,agent=?,address=?,address1=?,address2=?,address3=?,photofront=?,photoback=?,expressAvaible=?,note=?,ename=? where cid = ?" withArgumentsInArray:updateData];
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
