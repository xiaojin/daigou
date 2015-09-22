//
//  ProcurementEditView.m
//  Daigou
//
//  Created by jin on 22/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProcurementEditView.h"
#import <Masonry/Masonry.h>
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "CommonDefines.h"
#import "JVFloatLabeledTextField.h"
#import "ProductManagement.h"
#import "Product.h"

@interface ProcurementEditView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong)JVFloatLabeledTextField *qualityField;
@property (nonatomic, strong)JVFloatLabeledTextField *priceField;
@property (nonatomic, strong)JVFloatLabeledTextField *totalPriceField;
@property (nonatomic, strong)UILabel *productTitle;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) OProductItem *productItem;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ProcurementEditView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustom;
        self.withKeyboard = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 50);
            make.height.mas_equalTo(216+50);
        }];
        
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 50, 0));
        }];
        _productTitle = [[UILabel alloc] init];
        [_productTitle setTextColor:TITLECOLOR];
        _productTitle.font = [UIFont systemFontOfSize:13.0f];
        [_productTitle setTextAlignment:NSTextAlignmentLeft];
        [_productTitle setText:@"我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友我们试好朋友"];
        [_productTitle setNumberOfLines:2];
        [view addSubview:_productTitle];
        [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(10);
            make.left.equalTo(view).with.offset(10);
            make.right.equalTo(view).with.offset(-10);
            make.height.mas_equalTo(@45);
        }];
        
        UIColor *floatingLabelColor = THEMECOLOR;
        UIColor *fontColor = FONTCOLOR;
        _qualityField = [[JVFloatLabeledTextField alloc]init];
        _qualityField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _qualityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"数量"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
        _qualityField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _qualityField.floatingLabelTextColor = floatingLabelColor;
        _qualityField.text = @"";
        _qualityField.keyboardType = UIKeyboardTypeNumberPad;
        _qualityField.delegate = self;
        [view addSubview:_qualityField];
        [_qualityField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_productTitle.mas_bottom).with.offset(kJVFieldMarginTop);
            make.left.equalTo(_productTitle.mas_left);
            make.right.equalTo(_productTitle.mas_right);
            make.height.equalTo(@44);
        }];
        _qualityField.keepBaseline = YES;
        
        UIView *div = [UIView new];
        div.backgroundColor = LINECOLOR;
        [view addSubview:div];
        [div mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualityField.mas_bottom);
            make.left.equalTo(_qualityField.mas_left);
            make.right.equalTo(_qualityField.mas_right);
            make.height.equalTo(@(kLINEHEIGHT));
        }];
        
        
        _priceField = [[JVFloatLabeledTextField alloc]init];
        _priceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _priceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"采购价格"
                                                                            attributes:@{NSForegroundColorAttributeName: fontColor}];
        _priceField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _priceField.floatingLabelTextColor = floatingLabelColor;
        _priceField.keyboardType = UIKeyboardTypeDecimalPad;
        _priceField.delegate = self;
        //[_receiverField setText:_product.name];
        [view addSubview:_priceField];
        [_priceField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualityField.mas_bottom).with.offset(10);
            make.left.equalTo(_qualityField.mas_left);
            make.right.equalTo(view.mas_centerX).with.offset(-30);
            make.height.equalTo(@44);
        }];
        _priceField.keepBaseline = YES;
        
        UILabel *dollarLable = [[UILabel alloc]init];
        dollarLable.font = MONEYSYMFONT;
        dollarLable.textColor = fontColor;
        dollarLable.textAlignment = NSTextAlignmentLeft;
        [dollarLable setText:@"$"];
        [view addSubview:dollarLable];
        [dollarLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_priceField.mas_bottom).with.offset(-5);
            make.width.equalTo(@10);
            make.left.equalTo(_priceField.mas_right);
            make.height.equalTo(@22);
        }];
        
        UIView *div1 = [UIView new];
        div1.backgroundColor = LINECOLOR;
        [view addSubview:div1];
        [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceField.mas_bottom);
            make.left.equalTo(_priceField.mas_left);
            make.right.equalTo(dollarLable.mas_right);
            make.height.equalTo(@(kLINEHEIGHT));
        }];
        
        _totalPriceField = [[JVFloatLabeledTextField alloc]init];
        _totalPriceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _totalPriceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"总价"
                                                                            attributes:@{NSForegroundColorAttributeName: fontColor}];
        _totalPriceField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _totalPriceField.floatingLabelTextColor = floatingLabelColor;
        _totalPriceField.keyboardType = UIKeyboardTypeDecimalPad;
        //[_receiverField setText:_product.name];
        [view addSubview:_totalPriceField];
        [_totalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualityField.mas_bottom).with.offset(10);
            make.left.equalTo(view.mas_centerX);
            make.right.equalTo(view).with.offset(-30);
            make.height.equalTo(@44);
        }];
        _totalPriceField.keepBaseline = YES;
        
        UILabel *dollarLable2 = [[UILabel alloc]init];
        dollarLable2.font = MONEYSYMFONT;
        dollarLable2.textColor = fontColor;
        dollarLable2.textAlignment = NSTextAlignmentLeft;
        [dollarLable2 setText:@"$"];
        [view addSubview:dollarLable2];
        [dollarLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_totalPriceField.mas_bottom).with.offset(-5);
            make.width.equalTo(@10);
            make.left.equalTo(_totalPriceField.mas_right);
            make.height.equalTo(@22);
        }];
        
        UIView *div2 = [UIView new];
        div2.backgroundColor = LINECOLOR;
        [view addSubview:div2];
        [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_totalPriceField.mas_bottom);
            make.left.equalTo(_totalPriceField.mas_left);
            make.right.equalTo(dollarLable2.mas_right);
            make.height.equalTo(@(kLINEHEIGHT));
        }];
        
        
        
    
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.bottom.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"采购" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];

    }
    
    return self;
}

- (void)setProductItemDict:(NSDictionary *)productItemDict {
    _productItemDict = productItemDict;
    _count = [[productItemDict objectForKey:@"count"] intValue];
    _productItem = (OProductItem *)[productItemDict objectForKey:@"oproductitem"];
    _productTitle.text = [NSString stringWithFormat:@"%@ 参考价格:$%.2f",[self getTitleName],[self getRefPrice]];
    _qualityField.text =[NSString stringWithFormat:@"%ld",[self getProductCount]];
    _priceField.text = [NSString stringWithFormat:@"%.2f",_productItem.price];
    _totalPriceField.text = [NSString stringWithFormat:@"%.2f",(_productItem.price * _count)];
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


- (void)actionHide
{
    [self resignFirstResponder];
    [self hide];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger myCount = [_qualityField.text intValue];
    float myPrice = [_priceField.text floatValue];
    _totalPriceField.text = [NSString stringWithFormat:@"%.2f",(myPrice * myCount)];
}

@end
