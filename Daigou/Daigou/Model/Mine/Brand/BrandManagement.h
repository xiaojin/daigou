//
//  BrandManagement.h
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Brand;
@interface BrandManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getBrand;
- (BOOL)updateBrand:(Brand *)brand;
- (Brand *)getBrandById:(NSInteger)brandId;
@end
