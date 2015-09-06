//
//  Product.h
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property(nonatomic,assign)NSInteger pid;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,assign)NSInteger categoryid;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *model;
@property(nonatomic,assign)NSInteger brandid;
@property(nonatomic,copy)NSString *barcode;
@property(nonatomic,copy)NSString *quickid;
@property(nonatomic,copy)NSString *picture;
@property(nonatomic,assign)NSInteger onshelf;
@property(nonatomic,assign)float rrp;
@property(nonatomic,assign)float purchaseprice;
@property(nonatomic,assign)float costprice;
@property(nonatomic,assign)float lowestprice;
@property(nonatomic,assign)float agentprice;
@property(nonatomic,assign)float saleprice;
@property(nonatomic,assign)float sellprice;
@property(nonatomic,assign)float wight;
@property(nonatomic,copy)NSString *prodDescription;
@property(nonatomic,assign)NSInteger want;
@property(nonatomic,copy)NSString *avaibility;
@property(nonatomic,copy)NSString *function;
@property(nonatomic,copy)NSString *storage;
@property(nonatomic,copy)NSString *usage;
@property(nonatomic,copy)NSString *caution;
@property(nonatomic,copy)NSString *ingredient;
@property(nonatomic,assign)double syncDate;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *ename;

- (NSArray *)productToArray;

@end
