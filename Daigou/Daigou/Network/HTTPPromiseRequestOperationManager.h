//
//  HTTPPromiseRequestOperationManager.h
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "HttpPromiseRequestOperation.h"


@interface HTTPPromiseRequestOperationManager : AFHTTPRequestOperationManager
+ (instancetype)shareManager;
- (void)addOperation:(HttpPromiseRequestOperation *)operation;
- (void)cancelOperations;
@end
