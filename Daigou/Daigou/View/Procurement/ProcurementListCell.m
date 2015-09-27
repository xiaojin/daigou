//
//  ProcurementListCell.m
//  Daigou
//
//  Created by jin on 31/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProcurementListCell.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "ProductManagement.h"
#import "Product.h"

#define IMAGEVIEWSIZE 55.0f
#define CONTENTPADDINGLEFT 10.0f
#define FONTSIZE 12.0f
#define CONTENTPADDINGTOP 15.0f

@interface ProcurementListCell ()
@property (nonatomic, assign)NSInteger cellIndex;
@property(nonatomic, strong)  UILabel *noteInfo;
@property (nonatomic, assign) ProductOrderStatus procurementStatus;
@property (nonatomic, strong) UILabel *titleNameLbl;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) OProductItem *productItem;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ProcurementListCell
- (instancetype) initWithOrderStatus:(ProductOrderStatus)status withIndex:(NSInteger)index {
    self.cellIndex = index;
    self.procurementStatus = status;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"procurementListcellIdentity"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)setProcurementItem:(NSDictionary *)procurementItem {
    _procurementItem = procurementItem;
    _count = [[procurementItem objectForKey:@"count"] intValue];
    _productItem = (OProductItem *)[procurementItem objectForKey:@"oproductitem"];
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
    
    
    NSString *priceString = [NSString stringWithFormat:@"参考价格: $%.2f 数量 %ld", [self getRefPrice],(long)[self getProductCount]];
    UILabel *totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl.font = [UIFont systemFontOfSize:FONTSIZE];
    totalPriceLbl.textColor = RGB(89, 89, 89);
    totalPriceLbl.textAlignment = NSTextAlignmentLeft;
    [totalPriceLbl setText:priceString];
    [self.contentView addSubview:totalPriceLbl];
    [totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleNameLbl.mas_bottom).with.offset(10);
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
    [self getProductInfoById:_productItem.productid];
    return self.product.name;
}

- (float)getRefPrice {
    return _productItem.refprice;
}

- (NSInteger)getProductCount {
    return _count;
}

- (NSString *)getNote {
    return _productItem.note;
}

@end
