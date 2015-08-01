//
//  OrderBasketPickerCell.h
//  Daigou
//
//  Created by jin on 1/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductWithCount;
@interface OrderBasketPickerCell : UITableViewCell
@property (nonatomic, strong) ProductWithCount *productCount;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
