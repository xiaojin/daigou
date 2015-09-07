//
//  ProductCategoryManagement.m
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProductCategoryManagement.h"
#import "ProductCategory.h"
#import "CommonDefines.h"
#import <FMDB/FMDB.h>

@implementation ProductCategoryManagement{
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
    static ProductCategoryManagement *categoryManagement = nil;
    
    once_only(^{
        categoryManagement = [[self alloc] init];
    });
    
    return categoryManagement;
}

- (NSArray *)getCategory {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from category"];
    NSMutableArray *categoryArray = [NSMutableArray array];
    while (rs.next) {
        ProductCategory *category = [[ProductCategory alloc]init];
        category.cateid = (NSInteger)[rs intForColumn:@"cateid"];
        category.name = [rs stringForColumn:@"name"];
        category.image = [rs stringForColumn:@"image"];
        category.syncDate = [rs doubleForColumn:@"syncDate"];
        [categoryArray addObject:category];
    }
    [_db close];
    return categoryArray;
}

- (BOOL)checkIfCategoryExists:(ProductCategory *)category {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from category where cateid =(?)",[NSNumber numberWithInteger:category.cateid]];
    if (rs.next) {
        return YES;
    } return NO;
}

- (BOOL)addCategoryInfo:(ProductCategory *)category{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into category (name,image,syncDate) values (?,?,?)" withArgumentsInArray:[category categoryToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)updateCategory:(ProductCategory *)category {
    
    BOOL exists = [self checkIfCategoryExists:category];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[category categoryToArray]];
        [updateData addObject:@(category.cateid)];
        result= [_db executeUpdate:@"update category set name=?,image=? where cateid = (?)" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
            [_db close];
        }
    } else {
        result = [self addCategoryInfo:category];
    }
    [_db close];
    return result;
    
}

- (ProductCategory *)getCategoryById:(NSInteger)categoryId {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from category where cateid = (?)", @(categoryId)];
    ProductCategory *category = [[ProductCategory alloc]init];
    if (rs.next) {
        category.cateid = (NSInteger)[rs intForColumn:@"cateid"];
        category.name = [rs stringForColumn:@"name"];
        category.image = [rs stringForColumn:@"image"];
        category.syncDate = [rs doubleForColumn:@"syncDate"];
    }
    [_db close];
    return category;
}
@end
