//
//  ProcurementEditView.h
//  Daigou
//
//  Created by jin on 22/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MMPopupView.h"
#import "OProductItem.h"
@protocol ProcurementEditViewDelegate
- (void)purchaseDidFinish;
@end

@interface ProcurementEditView : MMPopupView
@property (nonatomic, strong)NSDictionary *productItemDict;
@property (nonatomic, weak)id<ProcurementEditViewDelegate> delegate;
@property (nonatomic, assign) BOOL purchaseStockFirst;
@property (nonatomic, assign) NSInteger clickTag;
@end
