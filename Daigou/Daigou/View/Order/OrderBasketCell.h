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
#import "OrderItem.h"
@interface OrderBasketCell : UITableViewCell
@property (nonatomic, strong) void (^EditQuantiyActionBlock)(NSInteger number);
@property (nonatomic, strong) void (^OrderProductItemsAllDeleted)();
@property (nonatomic, strong) void (^DoneButtonClicked)();
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *productList;
@property (nonatomic, strong) OrderItem *orderItem;
+ (instancetype) OrderWithCell:(UITableView *)tableview;
- (void) updateDoneButton ;
@end
