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
@property (nonatomic, copy) void (^TapEditBlock)(OrderStatus status,NSInteger index);
@property (nonatomic, copy) void (^TapStatusButtonBlock)(OrderStatus status,NSInteger index);
- (instancetype) initWithOrderStatus:(OrderStatus)status withIndex:(NSInteger)index;
@end
