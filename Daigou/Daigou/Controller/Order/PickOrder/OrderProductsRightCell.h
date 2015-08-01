//
//  OrderProductsRightCell.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@interface OrderProductsRightCell : UITableViewCell
@property (nonatomic, strong) Product *product;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex, NSInteger money, Product * product);
@end
