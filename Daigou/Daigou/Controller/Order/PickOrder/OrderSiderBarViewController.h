//
//  OrderSiderBarViewController.h
//  Daigou
//
//  Created by jin on 25/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBlurSidebar.h"
#import "Brand.h"

@protocol OrderSiderBarDelegate<NSObject>
@optional
- (void)itemDidSelect:(Brand *)brand;
@end

@interface OrderSiderBarViewController : LLBlurSidebar
@property(nonatomic, assign) BOOL hideHeaderView;
@property(nonatomic, assign) CGFloat tabHeight;
@property(nonatomic, assign) CGFloat navHeight;
@property(nonatomic, assign) id<OrderSiderBarDelegate> orderDelegate;
@end
