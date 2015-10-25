//
//  NSError+OperationCancelled.h
//  Daigou
//
//  Created by jin on 12/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kOperationCancelled 1100
@interface NSError (OperationCancelled)
+ (NSError *)cancelledOperation;
- (BOOL)isCancelledOperation;
- (BOOL)isOffline;
@end
