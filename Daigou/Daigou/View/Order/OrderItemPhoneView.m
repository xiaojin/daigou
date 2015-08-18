//
//  OrderItemPhoneView.m
//  Daigou
//
//  Created by jin on 18/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItemPhoneView.h"
#import "UITextField+UITextFieldAccessory.h"
#import "CommonDefines.h"

#define CUSTOMINFOTITLEWIDTH 90.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGRIGHT 10.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 16.0f

@interface OrderItemPhoneView()<UITextFieldDelegate>
@end

@implementation OrderItemPhoneView
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleName = [[UILabel alloc]initWithFrame:CGRectMake(CONTENTPADDINGLEFT, 0, CUSTOMINFOTITLEWIDTH, CGRectGetHeight(self.contentView.frame))];
    self.titleName.font = [UIFont systemFontOfSize:FONTSIZE];
    self.titleName.textColor = TITLECOLOR;
    self.titleName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleName];
    
    CGFloat textFieldX = CGRectGetWidth(self.titleName.frame) + CONTENTPADDINGLEFT+ LEABELINPUTFIELDGAPPING;
    CGFloat textFieldwith = CGRectGetWidth(self.contentView.frame) - textFieldX- CONTENTPADDINGRIGHT;
    self.detailInfo = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX , 0, textFieldwith, CGRectGetHeight(self.contentView.frame))];
    [self.detailInfo addAccessoryView];
    [self.detailInfo setFont:[UIFont systemFontOfSize:FONTSIZE]];
    [self.detailInfo setTextColor:TITLECOLOR];
    self.detailInfo.textAlignment = NSTextAlignmentLeft;
    [self.detailInfo setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.detailInfo reloadInputViews];
    self.detailInfo.delegate = self;
    [self.contentView addSubview:self.detailInfo];
}
@end
