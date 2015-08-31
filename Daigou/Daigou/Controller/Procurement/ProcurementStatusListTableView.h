//
//  ProcurementStatusListTableView.h
//  Daigou
//
//  Created by jin on 30/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OProductItem.h"

@interface ProcurementStatusListTableView : UITableView
@property(nonatomic, assign)ProcurementStatus status;
@property(nonatomic, strong)NSArray *procurementProductList;
@end
