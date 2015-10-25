//
//  HTTPPromiseRequestOperationManager.m
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "HTTPPromiseRequestOperationManager.h"
#import "CommonDefines.h"

@implementation HTTPPromiseRequestOperationManager{
}

+ (instancetype)shareManager {
    static HTTPPromiseRequestOperationManager *sharedMyManager = nil;
    
    once_only(^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self.operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)cancelOperations {
    [self.operationQueue cancelAllOperations];
}

- (void)addOperation:(HttpPromiseRequestOperation *)operation {
    [self.operationQueue addOperation:operation];
}


@end
