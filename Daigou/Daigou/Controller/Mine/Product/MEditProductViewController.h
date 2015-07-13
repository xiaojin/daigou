//
//  MEditProductViewController.h
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@interface MEditProductViewController : UIViewController
- (instancetype)initWithProduct:(Product *)product;
@property(nonatomic, strong)NSArray *cellPlaceHolderValues;
@property(nonatomic, strong)NSArray *cellContentValues;
@end
