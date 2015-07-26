//
//  OrderBasketCellFrame.h
//  Daigou
//
//  Created by jin on 26/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
#define ProductTitleFont [UIFont systemFontOfSize:15.0f]
#define ProductTextFont [UIFont systemFontOfSize:10.0f]
#define PicWith 100
#define PicHeight 80
#define editButtonWidth 40
#define editButtonHeight 40
#define plusWH 35
#define countLblWidth 50
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OProductItem.h"
@class Product;
@interface OrderBasketCellFrame : NSObject
@property (nonatomic, assign, readonly) CGRect titleFrame;
@property (nonatomic, assign, readonly) CGRect pictureFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign, readonly) CGRect editButtonFrame;
@property (nonatomic, assign, readonly) CGRect plusBtnFrame;
@property (nonatomic, assign, readonly) CGRect countLblFrame;
@property (nonatomic, assign, readonly) CGRect minusLblFrame;


- (instancetype)initFrameWithOrderProduct:(OProductItem *)oProduct withViewFrame:(CGRect) rect;

- (Product *)getProduct;

- (OProductItem *)getOrderProductItem;
@end
