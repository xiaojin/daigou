//
//  OrderItemBenifitCell.h
//  Daigou
//
//  Created by jin on 18/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemBenifitCell : UITableViewCell
@property (nonatomic, copy) void (^EditPriceActionBlock)(NSInteger number);
@end
