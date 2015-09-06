//
//  Express.h
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Express : NSObject
@property(nonatomic ,assign) NSInteger eid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *note;
@property(nonatomic, strong) NSString *website;
@property(nonatomic, strong) NSString *proxy;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, assign) double price;
@property(nonatomic, assign) double syncDate;
- (NSArray *)expressToArray;
@end
