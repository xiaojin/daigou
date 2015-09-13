//
//  Photo.m
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "Photo.h"
#import "DirectoryUtil.h"

@implementation Photo
- (instancetype)init {
    return [self initWithUrl:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.imageUrl = url;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image photoId:(NSString *)photoId {
    if (self = [super init]) {
        _image = image;
        _photoId = photoId;
        _imageUrl = photoId;

    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithImage:image scaled:YES];
}

- (instancetype)initWithImage:(UIImage *)image scaled:(BOOL)scaled {
    self = [self initWithImage:image photoId:[[NSUUID UUID] UUIDString]];
    [self writeImage:scaled?[self getScaledImage:image]:image];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return self = [self initWithImage:[aDecoder decodeObjectForKey:@"image"] photoId:[aDecoder decodeObjectForKey:@"photoId"]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[Photo alloc] initWithImage:_image.copy photoId:_photoId.copy];
}
- (UIImage *)getScaledImage:(UIImage *)image {
    UIImage *scaledImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.25)];
    return scaledImage;
}

- (void)writeImage:(UIImage *)image {
    [self writeImage:image imageName:self.imageUrl compressionQuality:1.0];
}

- (UIImage*)readImage:(NSURL*)imageUrl
{
    return nil;
}

- (void)writeImage:(UIImage *)image imageName:(NSString *)imageName compressionQuality:(double)compressionQuality {
    NSData *thumbnailImageData = UIImageJPEGRepresentation(image, (CGFloat) compressionQuality);
    [thumbnailImageData writeToFile:[DirectoryUtil fileUrl:imageName].path atomically:YES];
}

- (instancetype)initWithPath:(NSString*)imagePath
{
    self = [self initWithURL:[NSURL URLWithString: imagePath]];
    self.image =  [UIImage imageWithContentsOfFile:[DirectoryUtil fileUrl:imagePath].path];
    return self;
    
}

- (instancetype)initWithURL:(NSURL *)url {
    // TODO: add test for this
    NSString *id = url.pathComponents.lastObject;
    return [[Photo alloc] initWithImage:nil photoId:id];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_photoId forKey:@"photoId"];
    [aCoder encodeObject:_image forKey:@"image"];
}

- (NSString *)URLPath:(NSString *)objectUrlPart {
    return [NSString stringWithFormat:@"%@%@", objectUrlPart, [self photoUrlPath]];
}

- (NSString *)photoUrlPath{
    return [NSString stringWithFormat:@"/photos/%@", _photoId];
}

- (NSURL *)URL:(NSURL *)objectUrlPart {
    return [objectUrlPart URLByAppendingPathComponent:[self photoUrlPath]];
}

@end
