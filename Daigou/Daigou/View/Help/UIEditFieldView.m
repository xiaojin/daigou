//
//  UIEditFieldView.m
//  Daigou
//
//  Created by jin on 13/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import "UIEditFieldView.h"
#import "CommonDefines.h"
#import <Masonry/Masonry.h>
#import "UITextField+UITextFieldAccessory.h"
#import "JVFloatLabeledTextField.h"

#define DiscountFONT  [UIFont systemFontOfSize:14.0f]

@interface UIEditFieldView()
@property (nonatomic ,strong) id parentController;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSString *placeHolderString;
@end
@implementation UIEditFieldView

- (instancetype)initWithSize:(CGSize)frameSize withController:(id)controlller withPlaceHolder:(NSString *)placeHolder{
    self = [super init];
    if (self) {
        _parentController = controlller;
        _contentSize  = frameSize;
        _placeHolderString = placeHolder;
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setUp {
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    UIColor *fontColor = FONTCOLOR;
    _textField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _textField.delegate = _parentController;
    _textField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeHolderString
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _textField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.floatingLabelTextColor = floatingLabelColor;
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@(_contentSize.width-10));
        make.height.equalTo(@44);
    }];
    
    _textField.keepBaseline = YES;
    _dollarCharacter = _dollarCharacter != nil ? _dollarCharacter : @"";
    UILabel *moneyCharacter = [[UILabel alloc]init];
    moneyCharacter.font = DiscountFONT;
    moneyCharacter.textColor = TITLECOLOR;
    moneyCharacter.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter setText:_dollarCharacter];
    [self addSubview:moneyCharacter];
    
    [moneyCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_textField.mas_bottom).with.offset(-5);
        make.width.equalTo(@10);
        make.left.equalTo(_textField.mas_right);
        make.height.equalTo(@22);
    }];
    
    UIView *divUnderline = [UIView new];
    divUnderline.backgroundColor = LINECOLOR;
    [self addSubview:divUnderline];
    [divUnderline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(-kLINEHEIGHT);
        make.left.right.equalTo(self);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
}

@end
