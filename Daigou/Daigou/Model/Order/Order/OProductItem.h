//
//  OProductItem.h
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OProductItem : NSObject
@property(nonatomic,assign)NSInteger iid;
@property(nonatomic,assign)NSInteger productid;
@property(nonatomic, assign)float refprice;
@property(nonatomic, assign)float price;
@property(nonatomic, assign)float amount;
@property(nonatomic,assign)NSInteger orderid;
@property(nonatomic,assign)NSInteger orderdate;
@property(nonatomic,assign)NSInteger statu;
@property(nonatomic, copy)NSString *note;

- (NSArray *)orderProductToArray;
@end
