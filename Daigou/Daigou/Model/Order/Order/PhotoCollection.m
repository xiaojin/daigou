//
//  PhotoCollection.m
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "PhotoCollection.h"
#import "Photo.h"
#define MAX_NUMBER_OF_PHOTOS 3

@implementation PhotoCollection{
    NSMutableArray *_photos;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _photos = ((NSArray *)[aDecoder decodeObjectForKey:@"photos"]).mutableCopy;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    PhotoCollection *photos = [PhotoCollection new];
    
    for (Photo *photo in _photos) {
        [photos add:photo.copy];
    }
    
    return photos;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_photos forKey:@"photos"];
}

- (void)add:(Photo *)photo {
    [_photos addObject:photo];
}

- (instancetype)init {
    if(self = [super init]){
        _photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)photos {
    return [NSArray arrayWithArray:_photos];
}

- (BOOL)capacityReached {
    return [_photos count] == MAX_NUMBER_OF_PHOTOS;
}

- (void)clear {
    [_photos removeAllObjects];
}


- (void)removePhoto:(Photo *)photo {
    [_photos removeObject:photo];
}
@end
