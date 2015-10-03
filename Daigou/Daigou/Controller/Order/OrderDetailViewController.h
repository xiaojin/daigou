//
//  OrderDetailViewController.h
//  Daigou
//
//  Created by jin on 15/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
@class CustomInfo;
@protocol OrderDetailViewControllerDelegate <NSObject>

@optional
- (void)willScrollToPage:(NSInteger)pageIndex;
@end

@interface OrderDetailViewController : UIViewController
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *customInfo;
@property(nonatomic, weak)id<OrderDetailViewControllerDelegate> delegate;
- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client;
- (void)scrollToStaus:(NSInteger)index;
- (void)updateButtonToStatus:(OrderStatus)status;
@end
