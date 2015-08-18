//
//  OrderItemView.m
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItemView.h"
#import "CommonDefines.h"
#import "MCustInfoViewController.h"
#import "UITextField+UITextFieldAccessory.h"

#define CUSTOMINFOTITLEWIDTH 90.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGRIGHT 10.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 16.0f

@interface OrderItemView()<UITextFieldDelegate>
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *value;

@end


@implementation OrderItemView


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}


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
    self.detailInfo.delegate = self;
    [self.contentView addSubview:self.detailInfo];
    self.titleName.text = _title;
    self.detailInfo.text = _value;
}

- (void)updateCellWithTitle:(NSString*)titleName detailInformation:(NSString*)detailInfo{
    self.titleName.text = @"";
    self.detailInfo.text = @"";
    self.title =titleName;
    self.value = detailInfo;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   //TODO  MCustInfoViewController
    return YES;
}
@end
