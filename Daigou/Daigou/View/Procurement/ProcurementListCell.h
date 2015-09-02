//
//  ProcurementListCell.h
//  Daigou
//
//  Created by jin on 31/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OProductItem.h"

@interface ProcurementListCell : UITableViewCell
@property(nonatomic, strong)OProductItem *procurementItem;
- (instancetype) initWithOrderStatus:(ProductOrderStatus)status withIndex:(NSInteger)index;
@end
