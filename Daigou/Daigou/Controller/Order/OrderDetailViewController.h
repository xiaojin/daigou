//
//  OrderDetailViewController.h
//  Daigou
//
//  Created by jin on 15/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem, CustomInfo;

@interface OrderDetailViewController : UIViewController
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *customInfo;
- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client;
- (void)scrollToStaus:(NSInteger)index;
@end
