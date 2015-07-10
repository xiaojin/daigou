#define NewsTitleFont [UIFont systemFontOfSize:15.0f]
#define NewsTextFont [UIFont systemFontOfSize:10.0f]
#define PicWith 100
#define PicHeight 80
#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductItemFrame : NSObject
@property (nonatomic, assign, readonly) CGRect titleFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGRect pictureFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
- (instancetype)initFrameWithProduct:(Product *)product withViewFrame:(CGRect) rect;
- (Product*)getProduct;
@end
