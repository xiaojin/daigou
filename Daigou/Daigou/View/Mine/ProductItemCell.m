#import "ProductItemCell.h"
#import "Product.h"
@interface ProductItemCell()
@property(nonatomic, retain)IBOutlet UILabel *lblTitle;
@property(nonatomic, retain)IBOutlet UILabel *lblText;
@property(nonatomic, retain)IBOutlet UIImageView *imagePic;
@end

@implementation ProductItemCell

+ (instancetype) NewsWithCell:(UITableView *)tableview;
{
    static NSString *identity =@"product";
    ProductItemCell * cell = [tableview dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[ProductItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lblTitle = [[UILabel alloc]init];
        [lblTitle setFont:NewsTitleFont];
        [lblTitle setTextColor:[UIColor colorWithRed:36.0f/255.0f green:51.0f/255.0f blue:108.0f/255.0f alpha:1.0f]];
        [lblTitle setNumberOfLines:0];
        [self addSubview:lblTitle];
        self.lblTitle = lblTitle;

        UILabel *lblText = [[UILabel alloc]init];
        [lblText setFont:NewsTextFont];
        [lblText setNumberOfLines:0];
        [self addSubview:lblText];
        self.lblText = lblText;
        
        UIImageView *imagePic = [[UIImageView alloc] init];
        [self addSubview:imagePic];
        self.imagePic = imagePic;
        
    }
    return  self;
}

- (void)setProductFrame:(ProductItemFrame *)productFrame
{
    _productFrame = productFrame;
    [self updateFrame];
    [self updateData];
}

- (void)updateFrame
{
    _imagePic.frame = _productFrame.pictureFrame;
    _lblTitle.frame = _productFrame.titleFrame;
    _lblText.frame = _productFrame.textFrame;
}

- (void)updateData
{
    Product *product =  [_productFrame getProduct];
    _imagePic.image = [UIImage imageNamed:@"default.jpg"];
    [_lblTitle setText:[product name]];
    [_lblText setText:[product prodDescription]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
