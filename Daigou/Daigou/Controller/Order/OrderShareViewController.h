//
//  OrderShareViewController.h
//  Daigou
//
//  Created by jin on 10/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface OrderShareViewController : UIViewController
@property(nonatomic, strong) OrderItem *orderItem;
@property(nonatomic, strong) NSDictionary *prodList;
@end
