//
//  CustomInfo.h
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
  NOTAGENT,
  ISAGENT
} AgentDesc ;

@interface CustomInfo : NSObject
@property(nonatomic,assign)NSInteger cid;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *email;

@property(nonatomic, strong)NSString *phonenum;
@property(nonatomic, strong)NSString *wechat;

@property(nonatomic, copy)NSString *idnum;

@property(nonatomic, strong)NSString *postcode;

@property(nonatomic, assign)NSInteger agent;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *address1;
@property(nonatomic, copy)NSString *address2;
@property(nonatomic, copy)NSString *address3;
@property(nonatomic, copy)NSString *photofront;
@property(nonatomic, copy)NSString *photoback;
@property(nonatomic, copy)NSString *expressAvaible;
@property(nonatomic, copy)NSString *note;
@property(nonatomic, copy)NSString *ename;

@property(nonatomic, assign)double syncDate;

- (NSArray *)cutomToArray;
@end
