//
//  OrderTextInputView.h
//  Daigou
//
//  Created by jin on 17/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItemView.h"

@interface OrderTextInputView : OrderItemView
@property (nonatomic, copy) void (^EditPriceActionBlock)(NSInteger number);
@end
