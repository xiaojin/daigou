//
//  OrderBasketCell.h
//  Daigou
//
//  Created by jin on 18/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderBasketCellFrame;
#import "OProductItem.h"
@interface OrderBasketCell : UITableViewCell
@property (nonatomic, copy) void (^EditQuantiyActionBlock)(NSInteger number);
@property (nonatomic, strong) NSDictionary *productDict;
+ (instancetype) OrderWithCell:(UITableView *)tableview;
@end
