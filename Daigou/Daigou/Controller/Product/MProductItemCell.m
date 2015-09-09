//
//  MProductItemCell.m
//  Daigou
//
//  Created by jin on 29/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MProductItemCell.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"

@interface MProductItemCell()
@property(nonatomic, strong)UIImageView *productImageView;
@property(nonatomic, strong)UIView *titleBackView;
@property(nonatomic, strong)UILabel *titleLbl;
@end

@implementation MProductItemCell



- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setProduct:(Product *)product {
    _product = product;
    CGSize textFieldSize = [self initSizeWithText:product.name withSize:CGSizeMake(self.contentView.frame.size.width-20, MAXFLOAT)  withFont:PRODUCTTITLEFONT];
    if (textFieldSize.height > (kWindowWidth/3 +10)) {
        textFieldSize = CGSizeMake(textFieldSize.width, (kWindowWidth/3 +10));
    }
    _productImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default"]];
    [self.contentView addSubview:_productImageView];
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.equalTo(_productImageView.mas_width);
    }];
    _titleBackView = [[UIView alloc] init];
    [_titleBackView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3f]];
    [self.contentView addSubview:_titleBackView];
    [_titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_productImageView.mas_bottom);
        make.height.equalTo(@(textFieldSize.height));
        make.left.equalTo(_productImageView.mas_left);
        make.right.equalTo(_productImageView.mas_right);
    }];
    
    _titleLbl = [[UILabel alloc]init];
    _titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLbl.numberOfLines = 0;
    [_titleLbl setText:product.name ];
    
    [_titleLbl setTextAlignment:NSTextAlignmentCenter];
    _titleLbl.font = PRODUCTTITLEFONT;
    [_titleLbl setTextColor:[UIColor whiteColor]];
    [_titleLbl sizeToFit];
    [_titleBackView addSubview:_titleLbl];
    CGFloat lblOffX = (self.contentView.frame.size.width-20 - textFieldSize.width)/2;
    _titleLbl.frame = CGRectMake(lblOffX, 0, textFieldSize.width, textFieldSize.height);
    
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@2);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];

}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
   
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
@end
