//
//  OrderItemClient.h
//  Daigou
//
//  Created by jin on 24/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderItem.h"
#import "OProductItem.h"
#import "CustomInfo.h"

@interface OrderItemClient : NSObject
@property(nonatomic, strong) OrderItem *orderItem;
@property(nonatomic, strong) OProductItem *productItem;
@property(nonatomic, strong) CustomInfo *customInfo;
@end
