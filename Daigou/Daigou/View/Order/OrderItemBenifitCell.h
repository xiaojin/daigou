//
//  OrderItemBenifitCell.h
//  Daigou
//
//  Created by jin on 18/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInfo.h"
#import "OrderItem.h"
@protocol FullScreenDisplayDelegate <NSObject>
@optional
//This delegate is mainly designed for iphone , as user would be navigated to a new controller for editing inforamtion;
- (void)showControllerFullScreen:(UIViewController *)viewController;
@end

@interface OrderItemBenifitCell : UITableViewCell
@property (nonatomic, copy) void (^EditPriceActionBlock)(NSInteger number,CGRect frame);
@property (nonatomic, strong) CustomInfo *customInfo;
@property (nonatomic, strong) OrderItem *orderItem;
@property (nonatomic, strong) NSString *productDesc;
@property (nonatomic ,strong) NSDictionary *benefitData;
@property(nonatomic, weak) id <FullScreenDisplayDelegate> fullScreenDisplayDelegate;

@end
