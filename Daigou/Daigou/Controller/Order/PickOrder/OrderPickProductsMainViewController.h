//
//  OrderPickProductsMainViewController.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem;
@protocol OrderPickProductsMainViewControllerDelegate <NSObject>
- (void)finishPickProducts;
@end

@interface OrderPickProductsMainViewController : UIViewController
- (instancetype)initWithOrderItem:(OrderItem*)ordeItem;
@property(nonatomic, strong)id<OrderPickProductsMainViewControllerDelegate> delegate;
@end
