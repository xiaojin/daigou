//
//  ExpressManagement.h
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Express;
@interface ExpressManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getExpress;
- (BOOL)saveExpress:(Express *)express;
- (Express *)getExpressById:(NSInteger)expressId;
@end
