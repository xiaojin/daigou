//
//  Category.h
//  Daigou
//
//  Created by jin on 10/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject
@property(nonatomic ,assign) NSInteger cateid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *image;
- (NSArray *)categoryToArray;
@end
