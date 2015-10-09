//
//  SellInfoManagement.h
//  Daigou
//
//  Created by jin on 9/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SellInfo;
@interface SellInfoManagement : NSObject
+ (instancetype)shareInstance;
- (SellInfo *)getSellInfo;
- (BOOL)updateSellInfo:(SellInfo *)custom;
@end
