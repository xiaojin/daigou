//
//  NSError+OperationCancelled.m
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "NSError+OperationCancelled.h"

@implementation NSError (OperationCancelled)
+ (NSError *)cancelledOperation {
    return [NSError errorWithDomain:@"DAIGOU" code:kOperationCancelled userInfo:nil];
}

- (BOOL)isCancelledOperation {
    return [[self domain] isEqualToString:@"DAIGOU"] && [self code] == kOperationCancelled;
}

- (BOOL)isOffline {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorNotConnectedToInternet;
}

@end
