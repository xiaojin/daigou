//
//  OrderStausListTableView.h
//  Daigou
//
//  Created by jin on 8/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
@interface OrderStausListTableView : UITableView
@property (nonatomic, assign) OrderStatus status;
@property (nonatomic, copy) NSArray *orderList;
@end
