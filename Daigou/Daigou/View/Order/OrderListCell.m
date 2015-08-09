//
//  OrderListCell.m
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderItem.h"
#import "CustomInfo.h"
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import <Masonry/Masonry.h>
#import "CommonDefines.h"

#define ICONSIZE 25.0f
#define IMAGEVIEWSIZE 35.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGTOP 10.0f
#define CONTENTPADDING 5.0f
#define CUSTOMINFOTITLEWIDTH 90.0f
#define CONTENTPADDINGLEFT 10.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 12.0f
@interface OrderListCell()
@property(nonatomic, strong) UILabel *titleName;
@property(nonatomic, strong) UILabel *detailInfo;
@property(nonatomic, strong) UIImageView *statusImageView;
@property(nonatomic, assign) OrderStatus orderStatus;
@property(nonatomic, assign) NSInteger cellIndex;
@end



@implementation OrderListCell

- (instancetype) initWithOrderStatus:(OrderStatus)status withIndex:(NSInteger)index{
    self.cellIndex = index;
    self.orderStatus = status;
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderlistcellIdentity"];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)makeSubView {
    UIButton *statusButton = [[UIButton alloc]init];
    [statusButton setBackgroundImage:[self statusImage:self.orderItem.statu] forState:UIControlStateNormal];
    [statusButton addTarget:self action:@selector(updateOrderStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:statusButton];
    [statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(CONTENTPADDINGLEFT);
        make.height.equalTo(@IMAGEVIEWSIZE);
        make.width.equalTo(@IMAGEVIEWSIZE);
    }];
    
    UIButton *editButton = [[UIButton alloc]init];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [editButton addTarget:self action:@selector(editOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-CONTENTPADDINGLEFT);
        make.bottom.equalTo(self.contentView).with.offset(CONTENTPADDINGTOP);
        make.width.equalTo(@60);
    }];
    
    self.titleName = [[UILabel alloc]init];
    self.titleName.text = @"";
    self.titleName.font = [UIFont systemFontOfSize:FONTSIZE];
    self.titleName.textColor = RGB(89, 89, 89);
    self.titleName.textAlignment = NSTextAlignmentLeft;
    [self.titleName setText:[self getContantName]];
    [self.contentView addSubview:self.titleName];
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(CONTENTPADDINGTOP);
        make.left.equalTo(statusButton.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(editButton).with.offset(-CONTENTPADDINGLEFT);
        make.height.equalTo(@15);
    }];
    
    NSString *priceString = @"总价: ¥123123 下单时间 1 分钟前";
    UILabel *totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl.font = [UIFont systemFontOfSize:FONTSIZE];
    totalPriceLbl.textColor = RGB(89, 89, 89);
    totalPriceLbl.textAlignment = NSTextAlignmentLeft;
    [totalPriceLbl setText:priceString];
    [self.contentView addSubview:totalPriceLbl];
    [totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleName.mas_bottom).with.offset(2);
        make.left.equalTo(statusButton.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(editButton).with.offset(-CONTENTPADDINGLEFT);
        make.height.equalTo(@(15));
    }];
    
    self.detailInfo = [[UILabel alloc]init];
    self.detailInfo.text = @"";
    self.detailInfo.font = [UIFont systemFontOfSize:FONTSIZE];
    self.detailInfo.textColor = RGB(89, 89, 89);
    self.detailInfo.textAlignment = NSTextAlignmentLeft;
    self.detailInfo.numberOfLines = 2;
    self.detailInfo.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.detailInfo setText:[self.orderItem note]];
    [self.contentView addSubview:self.detailInfo];
    [self.detailInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceLbl.mas_bottom).with.offset(2);
        make.left.equalTo(statusButton.mas_right).with.offset(CONTENTPADDINGLEFT);
        make.right.equalTo(editButton).with.offset(-CONTENTPADDINGLEFT);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeSubView];
}

- (void)updateOrderStatus {
    _TapStatusButtonBlock();
}

- (void)editOrder {
    _TapEditBlock();
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *红  PURCHASED
 *橙色 UNDISPATCH = 10,
 *黄色 DSHIPPED = 20,
 *蓝色 ELIVERD = 30,
 *绿色 DONE = 40
 */
- (UIImage *)statusImage:(OrderStatus)orderStatus {
    UIColor *color = nil;
    switch (orderStatus) {
        case PURCHASED:
            color = [UIColor redColor];
            break;
        case UNDISPATCH:
            color = [UIColor orangeColor];
            break;
        case SHIPPED:
            color = [UIColor yellowColor];
            break;
        case DELIVERD:
            color = [UIColor blueColor];
            break;
        case DONE:
            color = [UIColor greenColor];
            break;
    }
   return [IonIcons imageWithIcon:ion_ios_circle_filled iconColor:color iconSize:ICONSIZE imageSize:CGSizeMake(ICONSIZE, ICONSIZE)];
}

- (NSString *)getContantName {
    return self.custom.name;
}
@end
