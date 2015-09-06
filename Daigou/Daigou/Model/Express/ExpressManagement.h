//
//  ExpressManagement.h
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getExpress;
@end
