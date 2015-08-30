//
//  ProcurementItem.h
//  Daigou
//
//  Created by jin on 30/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    OrderProduct = 0,
    UnOrderProduct = 1
} ProcurementStatus;
@interface ProcurementItem : NSObject
@property(nonatomic, assign) ProcurementStatus pStatus;
@end
