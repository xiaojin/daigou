//
//  OAddNewOrderViewController.h
//  Daigou
//
//  Created by jin on 14/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem, CustomInfo;
@interface OAddNewOrderViewController : UIViewController
- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client;
@end
