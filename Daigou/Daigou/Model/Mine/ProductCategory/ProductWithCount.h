//
//  ProductWithCount.h
//  Daigou
//
//  Created by jin on 1/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
@interface ProductWithCount : NSObject
@property(nonatomic, strong)Product *product;
@property(nonatomic, assign)NSInteger productNum;
@end
