//
//  ProductManagement.h
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@interface ProductManagement : NSObject
+ (instancetype)shareInstance;
- (NSArray *)getProduct;
- (BOOL)deleteProduct:(Product *)product;
- (BOOL)updateProduct:(Product *)product;
@end
