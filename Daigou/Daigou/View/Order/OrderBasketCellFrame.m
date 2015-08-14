//
//  OrderBasketCellFrame.m
//  Daigou
//
//  Created by jin on 26/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderBasketCellFrame.h"
#import "Product.h"
#import "ProductManagement.h"

@interface OrderBasketCellFrame ()
@property(nonatomic, strong)OProductItem *productItem;
@property(nonatomic, assign)CGRect viewFrame;
@property(nonatomic, strong)Product *product;
@end

@implementation OrderBasketCellFrame
- (instancetype)initFrameWithOrderProduct:(OProductItem *)oProduct withViewFrame:(CGRect) rect{
    self = [super init];
    if (self) {
        self.viewFrame = rect;
        self.productItem = oProduct;
    }
    return self;
}


- (void) setProductItem:(OProductItem *)productItem {
    _productItem = productItem;
    [self getProductForOrderItem:_productItem.productid];    
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)getProductForOrderItem:(NSInteger)pid {
    ProductManagement *productManage = [ProductManagement shareInstance];
    self.product = [productManage getProductById:pid];
}

- (Product *)getProduct {
    return self.product;
}

- (OProductItem *)getOrderProductItem {
    return _productItem;
}

@end
