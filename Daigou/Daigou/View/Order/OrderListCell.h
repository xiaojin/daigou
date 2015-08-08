//
//  OrderListCell.h
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
@class CustomInfo;
@interface OrderListCell : UITableViewCell
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *custom;
@property (nonatomic, copy) void (^TapEditBlock)();
@property (nonatomic, copy) void (^TapStatusButtonBlock)();
- (instancetype) initWithOrderStatus:(OrderStatus)status withIndex:(NSInteger)index;
@end
