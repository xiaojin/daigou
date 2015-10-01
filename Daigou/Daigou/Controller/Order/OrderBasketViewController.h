//
//  OrderBasketViewController.h
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
#import <UIKit/UIKit.h>
@class OrderItem;
@interface OrderBasketViewController : UIViewController
@property(nonatomic, strong)UITableView *tableView;
- (instancetype)initwithOrderItem :(OrderItem *)orderitem withGroupOrderProducts:(NSDictionary *)products;

- (void)saveBasketInfoWithOrderId:(NSInteger)oid;
@end
