//
//  OrderListCell.h
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem, CustomInfo;
@interface OrderListCell : UITableViewCell
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *custom;
@end
