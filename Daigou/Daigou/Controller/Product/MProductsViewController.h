//
//  MProductsViewController.h
//  Daigou
//
//  Created by jin on 28/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@protocol MProductsViewControllerDelegate
@optional
- (void)didSelectProduct:(Product *)product;
@end
@interface MProductsViewController : UIViewController
@property(nonatomic, weak)id<MProductsViewControllerDelegate> delegate;
@end
