#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photo : NSObject<NSCoding, NSCopying>
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy, readonly) NSString *photoId;
@property (nonatomic, strong) UIImage *image;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithPath:(NSString*)imagePath;
- (instancetype)initWithImage:(UIImage *)image scaled:(BOOL)scaled;
- (NSString *)URLPath:(NSString *)objectUrlPart;
- (NSURL *)URL:(NSURL *)objectUrlPart;
@end
