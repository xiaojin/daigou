//
//  ProductShareView.h
//  Daigou
//
//  Created by jin on 2/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import <MMPopupView/MMPopupView.h>
@protocol ProductShareViewDelegate
- (void) didShareProduct:(UIImage *)shareImage product:(Product *)productInfo;
@end

@interface ProductShareView : MMPopupView
@property (nonatomic, strong) Product *product;
@property (nonatomic, weak) id<ProductShareViewDelegate> delegate;
@end
