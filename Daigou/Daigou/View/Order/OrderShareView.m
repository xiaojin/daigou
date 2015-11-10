//
//  OrderShareView.m
//  Daigou
//
//  Created by jin on 9/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import "OrderShareView.h"
#import "CommonDefines.h"
#import <Masonry/Masonry.h>
#import "BrandManagement.h"
#import "Brand.h"
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "OProductItem.h"
#import "OrderItemManagement.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface OrderShareView () <UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, strong) UIView *contentView;

@end


@implementation OrderShareView


- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setOrderItem:(OrderItem *)orderItem {
    _orderItem = orderItem;
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
    
    NSString *customName = [self getCustomInfo:_orderItem.clientid];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = MONEYSYMFONT;
    titleLbl.textColor = TITLECOLOR;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    [titleLbl setText:customName];
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
    
    

}


- (NSString *)getBrandById:(NSInteger)brandId {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    Brand *brand = [brandManagement getBrandById:brandId];
    return brand.name;
}

- (NSString *)getCustomInfo:(NSInteger)clientId {
    CustomInfoManagement *customManagement = [CustomInfoManagement shareInstance];
    CustomInfo *customInfo = [customManagement getCustomInfoById:clientId];
    return customInfo.name;
}

- (void)getProductWithOrderId:(NSInteger)oid{
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    NSArray *productItems = [itemManagement getOrderProductsByOrderId:oid];
    
}

@end
