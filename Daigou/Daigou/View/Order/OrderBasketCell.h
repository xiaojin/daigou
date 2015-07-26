//
//  OrderBasketCell.h
//  Daigou
//
//  Created by jin on 18/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderBasketCellFrame;
@interface OrderBasketCell : UITableViewCell
@property (nonatomic, strong) OrderBasketCellFrame *orderBasketCellFrame;

+ (instancetype) OrderWithCell:(UITableView *)tableview;

@end
