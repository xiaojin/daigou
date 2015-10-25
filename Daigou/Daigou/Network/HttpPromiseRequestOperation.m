//
//  HttpPromiseRequestOperation.m
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "HttpPromiseRequestOperation.h"
#import "HTTPPromiseRequestOperationManager.h"

@implementation HttpPromiseRequestOperation

+ (instancetype)operationWithRequest:(NSURLRequest *)request {
    return [[self alloc] initWithRequest:request];
}

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    NSMutableURLRequest *req = [urlRequest mutableCopy];
    
    if (!AFNetworkReachabilityManager.sharedManager.reachable) {
        // if we're offline, prefer to use stale data over failing the request
        NSLog(@"Offline and marking request to use stale data if necessary");
        //req.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    if (self = [super initWithRequest:req]) {
        
    }
    
    
    return self;
}

- (RXPromise *)startPromise {
    RXPromise *promise = [[RXPromise alloc] init];
    [self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        
        [promise resolveWithResult:responseObject];
        
    } failure:^(AFHTTPRequestOperation *op, NSError * error) {
        
        [promise rejectWithReason:error];
    }];
    
    [[HTTPPromiseRequestOperationManager shareManager] addOperation:self];
    return promise;
}

- (NSDictionary *)requestInfo {
    if(!_requestInfo){
        _requestInfo = @{};
    }
    
    return _requestInfo;
}

@end
