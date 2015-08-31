//
//  ProcurementStatusListTableView.m
//  Daigou
//
//  Created by jin on 30/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProcurementStatusListTableView.h"
#import "OrderItemManagement.h"

@implementation ProcurementStatusListTableView

- (NSArray *)procurementProductList {
    NSArray *procurementList = [NSArray array];
    procurementList = [[OrderItemManagement shareInstance] getprocurementProductItemsByStatus:self.status];
    return procurementList;
}
@end
