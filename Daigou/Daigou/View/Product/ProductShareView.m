//
//  ProductShareView.m
//  Daigou
//
//  Created by jin on 2/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import "ProductShareView.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "Brand.h"
#import "BrandManagement.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OProductItem.h"


@interface ProductShareView()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, strong) UIView *contentView;
@end


@implementation ProductShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeCustom;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 380));
        }];
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setProduct:(Product *)product {
    _product = product;
    _contentView = [[UIView alloc] init];
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-70);
    }];
    
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = MONEYSYMFONT;
    titleLbl.textColor = TITLECOLOR;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    [titleLbl setText:@"商品信息"];
    [_contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).with.offset(10);
        make.right.equalTo(_contentView).with.offset(-5);
        make.left.equalTo(_contentView).with.offset(5);
        make.height.equalTo(@22);
    }];
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).with.offset(5);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    
    NSString *URLString =  [IMAGEURL stringByAppendingString:[NSString stringWithFormat:@"%@.png", product.uid]];
    UIImageView *prodImage = [[UIImageView alloc] init];
    [prodImage sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"default"]];
    [_contentView addSubview:prodImage];
    [prodImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(div1.mas_bottom).with.offset(15);
        make.left.equalTo(self).with.offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    
    UILabel *brandTitle = [[UILabel alloc] init];
    brandTitle.font = MONEYSYMFONT;
    brandTitle.textColor = TITLECOLOR;
    brandTitle.textAlignment = NSTextAlignmentLeft;
    brandTitle.lineBreakMode = NSLineBreakByWordWrapping;
    brandTitle.numberOfLines = 0;
    [brandTitle setText:product.name];
    CGSize brandTitleSize = [self initSizeWithText:product.name withSize:CGSizeMake(self.frame.size.width-20, MAXFLOAT) withFont:MONEYSYMFONT];
    [_contentView addSubview:brandTitle];
    [brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prodImage.mas_top).with.offset(-10);
        make.right.equalTo(self).with.offset(-15);
        make.left.equalTo(prodImage.mas_right).with.offset(10);
        make.height.equalTo(@(brandTitleSize.height+20));
    }];
    
    NSString *sellPrice = [NSString stringWithFormat:@"出售价格¥: %.2f \n",product.sellprice];
    NSString *brandName = [self getBrandById:product.brandid];
    NSString *brandString = [NSString stringWithFormat:@"品牌: %@ \n", brandName];
    NSString *function = [NSString stringWithFormat:@"功效: %@ \n", product.function?product.function : @""];
    NSString *storage = [NSString stringWithFormat:@"用法说明: %@ \n", product.usage?product.usage : @""];
    NSString *caution = [NSString stringWithFormat:@"注意事项: %@ \n", product.caution?product.caution : @""];
    
    NSString *contentString = [NSString stringWithFormat:@"%@%@%@%@%@",sellPrice, brandString, function, storage, caution];
    
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.font = [UIFont systemFontOfSize:13.0f];
    contentLbl.textColor = TITLECOLOR;
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
    contentLbl.numberOfLines = 0;
    [contentLbl setText:contentString];
    CGSize contentLblSize = [self initSizeWithText:contentString withSize:CGSizeMake(self.frame.size.width-20, MAXFLOAT) withFont:MONEYSYMFONT];
    [_contentView addSubview:contentLbl];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brandTitle.mas_bottom);
        make.right.equalTo(brandTitle.mas_right);
        make.left.equalTo(brandTitle.mas_left);
        make.height.equalTo(@(contentLblSize.height));
    }];
    
 
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLbl.mas_bottom).with.offset(20);
    }];
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [self addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(div2.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(5);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    UILabel *daigouLbl = [[UILabel alloc] init];
    daigouLbl.font = [UIFont systemFontOfSize:10.0f];
    daigouLbl.textColor = ORIANGECOLOR;
    daigouLbl.textAlignment = NSTextAlignmentLeft;
    daigouLbl.lineBreakMode = NSLineBreakByWordWrapping;
    daigouLbl.numberOfLines = 0;
    [daigouLbl setText:@"代购宝，代购利器"];
    [self addSubview:daigouLbl];
    [daigouLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-5);
        make.left.equalTo(iconImageView.mas_right).with.offset(10);
        make.bottom.equalTo(iconImageView.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_shareButton setTitle:@"分享商品信息" forState:UIControlStateNormal];
    [_shareButton setBackgroundColor:LIGHTGRAYCOLOR];
    [_shareButton.layer setCornerRadius:0.8];
    [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [_shareButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-5);
        make.bottom.equalTo(self).with.offset(-10);
    }];
    
    
    
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}


- (NSString *)getBrandById:(NSInteger)brandId {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    Brand *brand = [brandManagement getBrandById:brandId];
    return brand.name;
}

- (void)shareProduct {
    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_scrollView.contentSize);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [_delegate didShareProduct:image product:_product];
    [self hide];
}


@end
