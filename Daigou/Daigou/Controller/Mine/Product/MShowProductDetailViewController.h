//
//  MShowProductDetailViewController.h
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@interface MShowProductDetailViewController : UIViewController
@property(nonatomic, strong) Product *product;
- (instancetype)initWithProduct:(Product *)product;
@end
