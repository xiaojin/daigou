//
//  OrderDeliveryStatusViewController.h
//  Daigou
//
//  Created by jin on 16/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomInfo,OrderItem,Express;
@interface OrderDeliveryStatusViewController : UIViewController
@property(nonatomic, strong)CustomInfo *receiverInfo;
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, assign)float deliveryPrice;
@property(nonatomic, strong)NSString *deliverybarCode;
@property(nonatomic, strong)Express *express;

- (void)saveDeliveryStatus;
@end
