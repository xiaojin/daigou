//
//  OrderDockCell.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDockCell : UITableViewCell
@property(nonatomic, strong) NSString *categoryText;
@property(nonatomic, strong) UILabel *category;
@property(nonatomic, strong) UIView *ViewShow;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
