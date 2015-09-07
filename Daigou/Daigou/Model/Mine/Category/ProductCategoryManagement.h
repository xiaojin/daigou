//
//  ProductCategoryManagement.h
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductCategory;

@interface ProductCategoryManagement : NSObject

+ (instancetype)shareInstance;
- (NSArray *)getCategory;
- (BOOL)updateCategory:(ProductCategory *)category;
- (ProductCategory *)getCategoryById:(NSInteger)categoryId;
@end
