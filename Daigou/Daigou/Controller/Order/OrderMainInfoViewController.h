//
//  OAddNewOrderViewController.h
//  Daigou
//
//  Created by jin on 14/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem, CustomInfo;
@interface OrderMainInfoViewController : UIViewController
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *customInfo;
- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client;
@end
