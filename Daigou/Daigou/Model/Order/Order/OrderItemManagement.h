//
//  OrderItemManagement.h
//  Daigou
//
//  Created by jin on 17/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getOrderItems;
@end
