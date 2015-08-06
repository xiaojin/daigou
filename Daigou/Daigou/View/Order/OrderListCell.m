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
#define ICONSIZE 25.0f
#define IMAGEVIEWSIZE 35.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGTOP 10.0f
#define CONTENTPADDING 5.0f
#define CUSTOMINFOTITLEWIDTH 90.0f
#define CONTENTPADDINGLEFT 10.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 16.0f
@interface OrderListCell()
@property(nonatomic, strong)UILabel *titleName;
@property(nonatomic, strong)UILabel *detailInfo;
@property(nonatomic, strong)UIImageView *statusImageView;
@end

@implementation OrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIButton *statusButton = [[UIButton alloc]init];
    statusButton setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    self.statusImageView = [[UIImageView alloc]initWithImage:[self statusImage:self.orderItem.statu]];
    self.statusImageView.frame = CGRectMake(CONTENTPADDINGLEFT, CONTENTPADDINGTOP, IMAGEVIEWSIZE, IMAGEVIEWSIZE);
    [self.contentView addSubview:self.statusImageView];
    
    CGFloat titleOffX = CONTENTPADDINGLEFT + IMAGEVIEWSIZE + CONTENTPADDING;
    CGFloat titleWidth = CGRectGetWidth(self.contentView.frame) - titleOffX;
    self.titleName = [[UILabel alloc]initWithFrame:CGRectMake(titleOffX, CONTENTPADDINGTOP, titleWidth, 20.0f)];
    self.titleName.font = [UIFont systemFontOfSize:FONTSIZE];
    self.titleName.textColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:1.0f];
    self.titleName.textAlignment = NSTextAlignmentLeft;
    [self.titleName setText:[self getContantName]];
    [self.contentView addSubview:self.titleName];
    
    self.detailInfo = [[UILabel alloc]initWithFrame:CGRectMake(titleOffX , CGRectGetMaxY(self.titleName.frame), titleWidth, IMAGEVIEWSIZE - CGRectGetHeight(self.titleName.frame)-CONTENTPADDING)];
    self.detailInfo.font = [UIFont systemFontOfSize:FONTSIZE];
    self.detailInfo.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    self.detailInfo.textAlignment = NSTextAlignmentLeft;
    self.detailInfo.numberOfLines = 2;
    self.detailInfo.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.detailInfo setText:[self.orderItem note]];
    [self.contentView addSubview:self.detailInfo];
}
/**
 *红  PURCHASED
 *橙色 PACKAGE = 10,
 *黄色 DELIVERD = 20,
 *蓝色 SHIPPED = 30,
 *绿色 DONE = 40
 */
- (UIImage *)statusImage:(OrderStatus)orderStatus {
    UIColor *color = nil;
    switch (orderStatus) {
        case PURCHASED:
            color = [UIColor redColor];
            break;
        case PACKAGE:
            color = [UIColor orangeColor];
            break;
        case DELIVERD:
            color = [UIColor yellowColor];
            break;
        case SHIPPED:
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
