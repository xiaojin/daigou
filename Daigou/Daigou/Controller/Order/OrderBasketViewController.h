//
//  OrderBasketViewController.h
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
//现有购物篮，在购物篮里面可以修改商品的属性，可以改变商品的数量，
//购物篮 右上方有个修改按钮 或者添加按钮，可以挑选商品。
#import <UIKit/UIKit.h>
@class OrderItem;
@interface OrderBasketViewController : UIViewController

- (instancetype)initwithOrderItem :(OrderItem *)orderitem;
@end
