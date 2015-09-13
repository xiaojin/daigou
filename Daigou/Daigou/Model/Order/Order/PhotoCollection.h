//
//  PhotoCollection.h
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Photo;
@interface PhotoCollection : NSObject<NSCoding,NSCopying>
@property (nonatomic, readonly)NSArray *photo;
- (void)add:(Photo *)photo;
- (void)clear;
- (BOOL)capacityReached;
- (void)removePhoto:(Photo *)photo;
@end
