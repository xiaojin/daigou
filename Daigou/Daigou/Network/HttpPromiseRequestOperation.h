//
//  HttpPromiseRequestOperation.h
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <RXPromise/RXPromise.h>
@class AFHTTPResponseSerializer;

@interface HttpPromiseRequestOperation : AFHTTPRequestOperation
@property (nonatomic, strong) NSDictionary *requestInfo;

+ (instancetype)operationWithRequest:(NSURLRequest *)request;
- (RXPromise *)startPromise;
- (instancetype) __unavailable init;
@end
