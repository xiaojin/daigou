//
//  StockListCell.m
//  Daigou
//
//  Created by jin on 2/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "StockListCell.h"
#import "Product.h"
#import <Masonry/Masonry.h>
#import "ProductManagement.h"
#import "CommonDefines.h"

#define IMAGEVIEWSIZE 35.0f
#define CONTENTPADDINGLEFT 10.0f
#define FONTSIZE 12.0f
#define CONTENTPADDINGTOP 10.0f

@interface StockListCell()
@property (nonatomic, assign)NSInteger cellIndex;
@property(nonatomic, strong) UILabel *noteInfo;
@property (nonatomic, assign)ProductOrderStatus procurementStatus;
@property (nonatomic, strong) UILabel *titleNameLbl;
@property (nonatomic, strong) Product *product;
@end

@implementation StockListCell
- (instancetype) initWithIndex:(NSInteger)index {
    self.cellIndex = index;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"procurementListcellIdentity"];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeSubView];
}

- (void)makeSubView {
    UIImageView *productImage = [[UIImageView alloc]init];
    [productImage setImage:[UIImage imageNamed:@"default"]];
    [self.contentView addSubview:productImage];
    [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(CONTENTPADDINGLEFT);
        make.height.equalTo(@IMAGEVIEWSIZE);
        make.width.equalTo(@IMAGEVIEWSIZE);
    }];
    
    self.titleNameLbl = [[UILabel alloc]init];
    self.titleNameLbl.text = @"";
    self.titleNameLbl.font = [UIFont systemFontOfSize:FONTSIZE];
    self.titleNameLbl.textColor = RGB(89, 89, 89);
    self.titleNameLbl.textAlignment = NSTextAlignmentLeft;
    [self.titleNameLbl setText:[self getTitleName]];
    [self.contentView addSubview:self.titleNameLbl];
    [self.titleNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(CONTENTPADDINGTOP);
        make.left.equalTo(productImage.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(self.contentView).with.offset(-CONTENTPADDINGLEFT);
        make.height.equalTo(@15);
    }];
    
    
    NSString *priceString = [NSString stringWithFormat:@"参考价格: $%.2f 数量 %d", [self getRefPrice],[self getProductCount]];
    UILabel *totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl.font = [UIFont systemFontOfSize:FONTSIZE];
    totalPriceLbl.textColor = RGB(89, 89, 89);
    totalPriceLbl.textAlignment = NSTextAlignmentLeft;
    [totalPriceLbl setText:priceString];
    [self.contentView addSubview:totalPriceLbl];
    [totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleNameLbl.mas_bottom).with.offset(2);
        make.left.equalTo(productImage.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(self.contentView).with.offset(-CONTENTPADDINGLEFT);
        make.height.equalTo(@(15));
    }];
    
    self.noteInfo = [[UILabel alloc]init];
    self.noteInfo.text = @"";
    self.noteInfo.font = [UIFont systemFontOfSize:FONTSIZE];
    self.noteInfo.textColor = RGB(89, 89, 89);
    self.noteInfo.textAlignment = NSTextAlignmentLeft;
    self.noteInfo.numberOfLines = 2;
    self.noteInfo.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.noteInfo setText:[self getNote]];
    [self.contentView addSubview:self.noteInfo];
    [self.noteInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceLbl.mas_bottom).with.offset(2);
        make.left.equalTo(productImage.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(self.contentView).with.offset(-CONTENTPADDINGLEFT);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
}


- (void)getProductInfoById:(NSInteger)productId {
    self.product = [[ProductManagement shareInstance] getProductById:productId];
}


- (NSString *)getTitleName {
    [self getProductInfoById:self.procurementItem.productid];
    return self.product.name;
}

- (float)getRefPrice {
    return self.procurementItem.refprice;
}

- (int)getProductCount {
    return self.procurementItem.amount;
}

- (NSString *)getNote {
    return self.procurementItem.note;
}
@end
