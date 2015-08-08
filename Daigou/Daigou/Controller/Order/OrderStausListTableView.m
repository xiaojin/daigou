//
//  OrderStausListTableView.m
//  Daigou
//
//  Created by jin on 8/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderStausListTableView.h"
#import "OrderItemManagement.h"

@implementation OrderStausListTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray*)orderList {
    NSArray *orderList = [NSArray array];

    orderList = [[OrderItemManagement shareInstance] getOrderItemsByOrderStatus:self.status];
    
    return orderList;
}
@end
