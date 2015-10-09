//
//  SellInfo.h
//  Daigou
//
//  Created by jin on 9/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellInfo : NSObject

@property(nonatomic,assign)NSInteger sid;
@property(nonatomic, copy)NSString *storename;
@property(nonatomic, copy)NSString *slogon;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *ename;
@property(nonatomic, copy)NSString *email;
@property(nonatomic, copy)NSString *phonenum;
@property(nonatomic, copy)NSString *idnum;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *postcode;
@property(nonatomic, copy)NSString *bankinfo;
@property(nonatomic, assign)NSInteger region;
@property(nonatomic, assign)double syncDate;


- (NSArray *)sellToArray;
@end
