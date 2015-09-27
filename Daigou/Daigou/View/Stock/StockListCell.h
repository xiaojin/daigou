//
//  StockListCell.h
//  Daigou
//
//  Created by jin on 2/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OProductItem.h"

@interface StockListCell : UITableViewCell
@property(nonatomic, strong)NSDictionary *procurementItem;
- (instancetype) initWithIndex:(NSInteger)index;

@end
