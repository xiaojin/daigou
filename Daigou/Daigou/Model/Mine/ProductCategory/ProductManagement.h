//
//  ProductManagement.h
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@class Brand;
@class ProductCategory;
@interface ProductManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getProduct;
- (Product *)getProductById:(NSInteger)prodcutId;
- (NSArray *)getProductByBrand:(Brand *)brand;
- (NSArray *)getProductByCategory:(ProductCategory *)productCategory;
- (BOOL)deleteProduct:(Product *)product;
- (BOOL)updateProduct:(Product *)product;
@end
