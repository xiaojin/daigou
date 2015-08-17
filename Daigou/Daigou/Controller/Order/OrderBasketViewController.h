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
- (instancetype)initwithOrderItem :(OrderItem *)orderitem withProducts:(NSArray *)products;
- (void)refreshBasketContent;

@end
