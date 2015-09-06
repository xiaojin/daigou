//
//  OProductItem.h
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PRODUCT_PURCHASE = 0,
    PRODUCT_INSTOCK = 10,
    PRODUCT_SHIPPED = 20
} ItemStatus;


typedef enum {
    OrderProduct = 0,
    UnOrderProduct = 1
} ProductOrderStatus;

@interface OProductItem : NSObject
@property(nonatomic,assign)NSInteger iid;
@property(nonatomic,assign)NSInteger productid;
@property(nonatomic, assign)float refprice;
@property(nonatomic, assign)float price;
@property(nonatomic, assign)float sellprice;

@property(nonatomic, assign)float amount;
@property(nonatomic,assign)NSInteger orderid;
@property(nonatomic,assign)NSInteger orderdate;
@property(nonatomic,assign)ItemStatus statu;
@property(nonatomic, copy)NSString *note;
@property(nonatomic, assign)NSInteger proxy;
@property(nonatomic, assign)double syncDate;
@property(nonatomic, assign)ProductOrderStatus procurementStatus;

- (NSArray *)orderProductToArray;
@end
