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
    CGFloat padding = 10;
    CGFloat paddingTop = 5;
    CGSize frameSize = self.viewFrame.size;
    
    CGSize titleSize = CGSizeMake(frameSize.width - 3*padding - editButtonWidth, editButtonHeight);
    CGFloat nameW = titleSize.width;
    CGFloat nameH = titleSize.height;
    CGFloat pointX = padding;
    CGFloat pointY = paddingTop;
    
    _titleFrame = CGRectMake(pointX, pointY, nameW, nameH);
    
    CGFloat editBtnW = editButtonWidth;
    CGFloat editBtnH = editButtonHeight;
    CGFloat editBtnPointX = padding + nameW + padding;
    CGFloat editBtnPointY = paddingTop;
    
    _editButtonFrame = CGRectMake(editBtnPointX, editBtnPointY, editBtnW, editBtnH);
    
    CGFloat minusW = plusWH;
    CGFloat minusH = plusWH;
    CGFloat minusPointX = padding;
    CGFloat minusPointY = (PicHeight - plusWH)/2 + paddingTop + paddingTop + nameH;
    _minusLblFrame = CGRectMake(minusPointX, minusPointY, minusW, minusH);
    
    CGFloat cLblW = countLblWidth;
    CGFloat cLblH = plusWH;
    CGFloat cLblPointX = padding + minusW +padding;
    CGFloat cLblPointY = minusPointY;
    _countLblFrame = CGRectMake(cLblPointX, cLblPointY, cLblW, cLblH);
    
    CGFloat plusW = plusWH;
    CGFloat plusH = plusWH;
    CGFloat plusPointX = cLblPointX + cLblW + padding;
    CGFloat plusPointY = minusPointY;
    _plusBtnFrame = CGRectMake(plusPointX, plusPointY, plusW, plusH);
    
    CGFloat picW = PicWith;
    CGFloat picH = PicHeight;
    CGFloat picPointX = frameSize.width - padding - picW - padding;
    CGFloat picPointY = minusPointY;
    _pictureFrame = CGRectMake(picPointX, picPointY, picW, picH);
    _cellHeight = CGRectGetMaxY(_pictureFrame) +20;
    
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
