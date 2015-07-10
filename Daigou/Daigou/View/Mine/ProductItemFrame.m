#import "ProductItemFrame.h"
#import "Product.h"
@interface ProductItemFrame()
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, strong) Product *product;

@end

@implementation ProductItemFrame

- (instancetype)initFrameWithProduct:(Product *)product withViewFrame:(CGRect) rect
{
    self = [super init];
    if (self) {
        self.viewFrame = rect;
        self.product = product;
    }
    return self;
}

- (Product *)getProduct{
    return _product;
}

- (void) setProduct:(Product *)product
{
        CGFloat padding = 10;
        CGFloat paddingTop = 5;
        CGSize frameSize = self.viewFrame.size;
        
        CGSize titleSize = [self initSizeWithText:self.product.name withSize:CGSizeMake((frameSize.width - 2*padding), MAXFLOAT) withFont:NewsTitleFont];
        CGFloat nameW = titleSize.width;
        CGFloat nameH = titleSize.height;
        CGFloat pointX = padding;
        CGFloat pointY = paddingTop;
        
        _titleFrame = CGRectMake(pointX, pointY, nameW, nameH);
        
        CGSize textSize = [self initSizeWithText:self.product.description withSize:CGSizeMake((frameSize.width - 3*padding-PicWith), MAXFLOAT) withFont:NewsTextFont];
        CGFloat textW = textSize.width;
        CGFloat textH = textSize.height;
        CGFloat textPointX = padding;
        CGFloat textPointY = CGRectGetMaxY(_titleFrame)+ paddingTop;
        _textFrame = CGRectMake(textPointX, textPointY, textW, textH);
        
        
        CGFloat picPointX = frameSize.width-padding-PicWith;
        CGFloat picPointY = CGRectGetMaxY(_titleFrame);
        _pictureFrame = CGRectMake(picPointX, picPointY, PicWith, PicHeight);
        if (CGRectGetMaxY(_textFrame) > CGRectGetMaxY(_pictureFrame)) {
            _cellHeight = CGRectGetMaxY(_textFrame) +20;
        } else {
            _cellHeight = CGRectGetMaxY(_pictureFrame) +20;
        }
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
