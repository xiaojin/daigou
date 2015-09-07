//
//  BrandManagement.m
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "BrandManagement.h"
#import "CommonDefines.h"
#import <FMDB/FMDB.h>
#import "Brand.h"
@implementation BrandManagement{
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
    static BrandManagement *brandManagement = nil;
    
    once_only(^{
        brandManagement = [[self alloc] init];
    });
    
    return brandManagement;
}

- (NSArray *)getBrand {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from brand"];
    NSMutableArray *brandArray = [NSMutableArray array];
    while (rs.next) {
        Brand *brandInfo = [[Brand alloc]init];
        brandInfo.bid = (NSInteger)[rs intForColumn:@"bid"];
        brandInfo.name = [rs stringForColumn:@"name"];
        brandInfo.image = [rs stringForColumn:@"image"];
        brandInfo.visible = [rs intForColumn:@"visible"];
        brandInfo.syncDate = [rs doubleForColumn:@"syncDate"];
        [brandArray addObject:brandInfo];
    }
    [_db close];
    return brandArray;
}

- (BOOL)checkIfBrandExists:(Brand *)brand {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from  brand where bid =(?)",[NSNumber numberWithInteger:brand.bid]];
    if (rs.next) {
        return YES;
    } return NO;
}

- (BOOL)addBrandInfo:(Brand *)brand{
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into brand (name,image,visible,syncDate) values (?,?,?,?)" withArgumentsInArray:[brand brandToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}

- (BOOL)updateBrand:(Brand *)brand {

    BOOL exists = [self checkIfBrandExists:brand];
    BOOL result;
    if (exists) {
        [_db beginTransaction];
        NSMutableArray *updateData = [NSMutableArray arrayWithArray:[brand brandToArray]];
        [updateData addObject:@(brand.bid)];
        result= [_db executeUpdate:@"update brand set name=?,image=?,visible=?,syncDate=? where bid = ?" withArgumentsInArray:updateData];
        if (result) {
            [_db commit];
            [_db close];
        }
    } else {
        result = [self addBrandInfo:brand];
    }
    [_db close];
    return result;

}

- (Brand *)getBrandById:(NSInteger)brandId {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from brand where bid = (?)",@(brandId)];
    Brand *brandInfo = [[Brand alloc]init];
    if (rs.next) {
        brandInfo.bid = (NSInteger)[rs intForColumn:@"bid"];
        brandInfo.name = [rs stringForColumn:@"name"];
        brandInfo.image = [rs stringForColumn:@"image"];
        brandInfo.visible = [rs intForColumn:@"visible"];
        brandInfo.syncDate = [rs doubleForColumn:@"syncDate"];
    }
    [_db close];
    return brandInfo;
    
}
@end
