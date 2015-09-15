//
//  ExpressManagement.m
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ExpressManagement.h"
#import "CommonDefines.h"
#import <FMDB/FMDB.h>
#import "Express.h"
@implementation ExpressManagement{
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
    static ExpressManagement *expressManagement = nil;
    
    once_only(^{
        expressManagement = [[self alloc] init];
    });
    
    return expressManagement;
}

- (NSArray *)getExpress {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from express"];
    NSMutableArray *expressArray = [NSMutableArray array];
    while (rs.next) {
        [expressArray addObject:[self handleDBResult:rs]];
    }
    [_db close];
    return expressArray;
}

- (Express *)getExpressById:(NSInteger)expressId; {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return nil ;
    }
    FMResultSet *rs = [_db executeQuery:@"select * from express where eid = (?)",@(expressId)];
    Express *express = [[Express alloc]init];
    if(rs.next) {
        express = [self handleDBResult:rs];
    }
    [_db close];
    return express;
}

- (Express *)handleDBResult:(FMResultSet *)rs {
    Express *express = [[Express alloc]init];
    express.eid = (NSInteger)[rs intForColumn:@"eid"];
    express.name = [rs stringForColumn:@"name"];
    express.note = [rs stringForColumn:@"image"];
    express.website = [rs stringForColumn:@"website"];
    express.proxy = [rs stringForColumn:@"proxy"];
    express.image = [rs stringForColumn:@"image"];
    express.price = [rs doubleForColumn:@"price"];
    express.syncDate = [rs doubleForColumn:@"syncDate"];
    return express;
}

- (BOOL)saveExpress:(Express *)express {
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO ;
    }
    [_db beginTransaction];
    BOOL result = [_db executeUpdate:@"insert into express (name,note,website,proxy,image,price,syncDate) values (?,?,?,?,?,?,?)" withArgumentsInArray:[express expressToArray]];
    if (result) {
        [_db commit];
        [_db close];
    }
    return result;
}


@end
