//
//  OrderSearchViewController.h
//  Daigou
//
//  Created by jin on 7/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
#import "CustomInfo.h"

@protocol OrderSearchViewControllerDelegate
- (void)didSelectOrderItem:(OrderItem *)orderItem withCustom:(CustomInfo *)custom;
@end

@interface OrderSearchViewController : UIViewController
@property(nonatomic, weak)id<OrderSearchViewControllerDelegate> delegate;
@end
