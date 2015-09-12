//
//  OrderItemBenifitCell.m
//  Daigou
//
//  Created by jin on 18/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderItemBenifitCell.h"
#import "CommonDefines.h"
#import "UITextField+UITextFieldAccessory.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "JVFloatLabeledTextField.h"

#define DiscountFONT  [UIFont systemFontOfSize:14.0f]
#define FLOADTINGFONTSIZE 14.0f
#define LEFTSIDEPADDING 10
#define kTabICONSIZE 26.0f
#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]
@interface OrderItemBenifitCell ()<UITextFieldDelegate>
@property(nonatomic, strong)UIView *subView;
@property(nonatomic, strong)UITextField *productInfoField;
@property(nonatomic, strong)UITextField *customInfoField;
@property(nonatomic, strong)UIButton *payStatus;
//小计
@property(nonatomic, strong)UITextField *subTotalField;
//优惠
@property(nonatomic, strong)UITextField *discountField;
//总计
@property(nonatomic, strong)UITextField *totalPriceField;
//其他成本
@property(nonatomic, strong)UITextField *otherPriceFiled;
//利润
@property(nonatomic, strong)UITextField *benefitPriceFiled;
//备注
@property(nonatomic, strong)UITextField *notePriceFiled;
//采购成本
@property(nonatomic, strong)UITextField *purchasePriceFiled;
@end

@implementation OrderItemBenifitCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _subView = [[UIView alloc]init];
    [self.contentView addSubview:_subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UILabel *customInfo = [[UILabel alloc]init];
    customInfo.font = DiscountFONT;
    customInfo.textColor = TITLECOLOR;
    customInfo.textAlignment = NSTextAlignmentLeft;
    [customInfo setText:@"客户"];
    [self.subView addSubview:customInfo];
    [customInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subView).with.offset(10);
        make.left.equalTo(self.subView).with.offset(10);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    _customInfoField = [[UITextField alloc] initHasAccessory];
    [_customInfoField setFont:DiscountFONT];
    [_customInfoField setTextColor:TITLECOLOR];
    _customInfoField.textAlignment = NSTextAlignmentLeft;
    _customInfoField.delegate = self;
    [_customInfoField setPlaceholder:@"客户姓名"];
    [_customInfoField setText:_customInfo.name];
    _customInfoField.delegate = self;
    _customInfoField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:_customInfoField];
    [_customInfoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customInfo.mas_bottom).with.offset(LEFTSIDEPADDING);
        make.left.equalTo(customInfo.mas_left);
        make.right.equalTo(customInfo.mas_right).with.offset(-80);
        make.height.equalTo(@30);
    }];

    
    
    UIView *customInfoFieldUnderLine  = [[UIView alloc] init];
    [customInfoFieldUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:customInfoFieldUnderLine];
    [customInfoFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customInfoField.mas_bottom);
        make.left.equalTo(_customInfoField.mas_left);
        make.right.equalTo(_customInfoField.mas_right);
        make.height.equalTo(@1);
    }];
    
    _payStatus = [[UIButton alloc] init];
    [_payStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self updatePaymentStatus];
    [self.subView addSubview:_payStatus];
    [_payStatus addTarget:self action:@selector(updatePaymentStatus) forControlEvents:UIControlEventTouchUpInside];
    [_payStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(customInfoFieldUnderLine.mas_top).with.offset(-5);
        make.left.equalTo(_customInfoField.mas_right).with.offset(5);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
//****
    UILabel *productInfo = [[UILabel alloc]init];
    productInfo.font = DiscountFONT;
    productInfo.textColor = TITLECOLOR;
    productInfo.textAlignment = NSTextAlignmentLeft;
    [productInfo setText:@"货品清单"];
    [self.subView addSubview:productInfo];
    [productInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customInfoFieldUnderLine.mas_top).with.offset(10);
        make.left.equalTo(self.subView).with.offset(10);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    _productInfoField = [[UITextField alloc]initHasAccessory];
    [_productInfoField setFont:DiscountFONT];
    [_productInfoField setTextColor:TITLECOLOR];
    _productInfoField.textAlignment = NSTextAlignmentLeft;
    _productInfoField.delegate = self;
    [_productInfoField setPlaceholder:@"商品清单"];
    [_productInfoField setText:_productDesc];
    _productInfoField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:_productInfoField];
    [_productInfoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productInfo.mas_bottom).with.offset(LEFTSIDEPADDING);
        make.left.equalTo(productInfo.mas_left);
        make.right.equalTo(productInfo.mas_right);
        make.height.equalTo(@30);
    }];
    
    UIView *productInfoFieldUnderLine  = [[UIView alloc] init];
    [productInfoFieldUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:productInfoFieldUnderLine];
    [productInfoFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productInfoField.mas_bottom);
        make.left.equalTo(_productInfoField.mas_left);
        make.right.equalTo(_productInfoField.mas_right);
        make.height.equalTo(@1);
    }];
    
    
//***********
    
    UILabel *subTotalLbl = [[UILabel alloc]init];
    subTotalLbl.font = DiscountFONT;
    subTotalLbl.textColor = TITLECOLOR;
    subTotalLbl.textAlignment = NSTextAlignmentLeft;
    [subTotalLbl setText:@"小计"];
    [self.subView addSubview:subTotalLbl];
    [subTotalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productInfoFieldUnderLine.mas_bottom).with.offset(10);
        make.left.equalTo(self.subView).with.offset(LEFTSIDEPADDING);
        make.right.equalTo(self.subView.mas_centerX).with.offset(-5);
        make.height.equalTo(@10);
    }];
    
    _subTotalField = [[UITextField alloc]initHasAccessory];
    [_subTotalField setFont:DiscountFONT];
    [_subTotalField setTextColor:LIGHTGRAYCOLOR];
    _subTotalField.textAlignment = NSTextAlignmentLeft;
    _subTotalField.delegate = self;
    [_subTotalField setPlaceholder:@"0.0"];
    _subTotalField.keyboardType = UIKeyboardTypeDecimalPad;
    _subTotalField.enabled = NO;
    [self.subView addSubview:_subTotalField];
    [_subTotalField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTotalLbl.mas_bottom).with.offset(LEFTSIDEPADDING);
        make.left.equalTo(subTotalLbl.mas_left);
        make.right.equalTo(subTotalLbl.mas_right).with.offset(-15);
        make.height.equalTo(@30);
    }];
    UILabel *moneyCharacter = [[UILabel alloc]init];
    moneyCharacter.font = DiscountFONT;
    moneyCharacter.textColor = TITLECOLOR;
    moneyCharacter.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter setText:@"¥"];
    [self.subView addSubview:moneyCharacter];
    [moneyCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTotalField.mas_top);
        make.right.equalTo(subTotalLbl.mas_right);
        make.left.equalTo(_subTotalField.mas_right);
        make.height.equalTo(_subTotalField.mas_height);
    }];
    
    UIView *subTotalFieldUnderLine  = [[UIView alloc] init];
    [subTotalFieldUnderLine setBackgroundColor:LIGHTGRAYCOLOR];
    [self.subView addSubview:subTotalFieldUnderLine];
    [subTotalFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTotalField.mas_bottom);
        make.left.equalTo(_subTotalField.mas_left);
        make.right.equalTo(subTotalLbl.mas_right);
        make.height.equalTo(@1);
    }];
    
    UILabel *discountLbl = [[UILabel alloc]init];
    discountLbl.font = DiscountFONT;
    discountLbl.textColor = TITLECOLOR;
    discountLbl.textAlignment = NSTextAlignmentLeft;
    [discountLbl setText:@"优惠"];
    [self.subView addSubview:discountLbl];
    [discountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTotalLbl.mas_top);
        make.left.equalTo(self.subView.mas_centerX).with.offset(5);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    _discountField = [[UITextField alloc]initHasAccessory];
    [_discountField setFont:DiscountFONT];
    [_discountField setTextColor:LIGHTGRAYCOLOR];
    _discountField.textAlignment = NSTextAlignmentLeft;
    _discountField.delegate = self;
    [_discountField setPlaceholder:@"0.0"];
    _discountField.keyboardType = UIKeyboardTypeDecimalPad;
    _discountField.enabled = NO;
    [self.subView addSubview:_discountField];
    [_discountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountLbl.mas_bottom).with.offset(10);
        make.left.equalTo(discountLbl.mas_left);
        make.right.equalTo(discountLbl.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UILabel *moneyCharacter2 = [[UILabel alloc]init];
    moneyCharacter2.font = DiscountFONT;
    moneyCharacter2.textColor = TITLECOLOR;
    moneyCharacter2.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter2 setText:@"¥"];
    [self.subView addSubview:moneyCharacter2];
    [moneyCharacter2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_discountField.mas_top);
        make.right.equalTo(discountLbl.mas_right);
        make.left.equalTo(_discountField.mas_right);
        make.height.equalTo(_discountField.mas_height);
    }];
    
    UIView *disCountFieldUnderLine  = [[UIView alloc] init];
    [disCountFieldUnderLine setBackgroundColor:LIGHTGRAYCOLOR];
    [self.subView addSubview:disCountFieldUnderLine];
    [disCountFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_discountField.mas_bottom);
        make.left.equalTo(_discountField.mas_left);
        make.right.equalTo(discountLbl.mas_right);
        make.height.equalTo(@1);
    }];
    
// ****************************************************************************
    
    UILabel *totalPriceLbl = [[UILabel alloc]init];
    totalPriceLbl.font = DiscountFONT;
    totalPriceLbl.textColor = TITLECOLOR;
    totalPriceLbl.textAlignment = NSTextAlignmentLeft;
    [totalPriceLbl setText:@"总价"];
    [self.subView addSubview:totalPriceLbl];
    [totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTotalFieldUnderLine.mas_bottom).with.offset(10);
        make.left.equalTo(self.subView).with.offset(LEFTSIDEPADDING);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    _totalPriceField = [[UITextField alloc]initHasAccessory];
    [_totalPriceField setFont:DiscountFONT];
    [_totalPriceField setTextColor:TITLECOLOR];
    _totalPriceField.textAlignment = NSTextAlignmentLeft;
    _totalPriceField.delegate = self;
    [_totalPriceField setPlaceholder:@"0.0"];
    _totalPriceField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:_totalPriceField];
    [_totalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceLbl.mas_bottom).with.offset(10);
        make.left.equalTo(totalPriceLbl.mas_left);
        make.right.equalTo(totalPriceLbl.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UILabel *moneyCharacter3 = [[UILabel alloc]init];
    moneyCharacter3.font = DiscountFONT;
    moneyCharacter3.textColor = TITLECOLOR;
    moneyCharacter3.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter3 setText:@"¥"];
    [self.subView addSubview:moneyCharacter3];
    [moneyCharacter3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPriceField.mas_top);
        make.right.equalTo(totalPriceLbl.mas_right);
        make.left.equalTo(_totalPriceField.mas_right);
        make.height.equalTo(_totalPriceField.mas_height);
    }];
    
    UIView *totalPriceUnderLine  = [[UIView alloc] init];
    [totalPriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:totalPriceUnderLine];
    [totalPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPriceField.mas_bottom);
        make.left.equalTo(_totalPriceField.mas_left);
        make.right.equalTo(totalPriceLbl.mas_right);
        make.height.equalTo(@1);
    }];

// ****************************************************************************
    CGFloat threeLblWith = (self.frame.size.width - 40) / 3;
    UILabel *purchasePriceLbl = [[UILabel alloc]init];
    purchasePriceLbl.font = DiscountFONT;
    purchasePriceLbl.textColor = TITLECOLOR;
    purchasePriceLbl.textAlignment = NSTextAlignmentLeft;
    [purchasePriceLbl setText:@"采购成本"];
    [self.subView addSubview:purchasePriceLbl];
    [purchasePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceUnderLine.mas_bottom).with.offset(10);
        make.left.equalTo(self.subView).with.offset(LEFTSIDEPADDING);
        make.width.equalTo(@(threeLblWith));
        make.height.equalTo(@10);
    }];
    
    _purchasePriceFiled = [[UITextField alloc]initHasAccessory];
    [_purchasePriceFiled setFont:DiscountFONT];
    [_purchasePriceFiled setTextColor:LIGHTGRAYCOLOR];
    _purchasePriceFiled.textAlignment = NSTextAlignmentLeft;
    _purchasePriceFiled.delegate = self;
    [_purchasePriceFiled setPlaceholder:@"0.0"];
    _purchasePriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    _purchasePriceFiled.enabled = NO;
    [self.subView addSubview:_purchasePriceFiled];
    [_purchasePriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchasePriceLbl.mas_bottom).with.offset(10);
        make.left.equalTo(purchasePriceLbl.mas_left);
        make.right.equalTo(purchasePriceLbl.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UILabel *moneyCharacter4 = [[UILabel alloc]init];
    moneyCharacter4.font = DiscountFONT;
    moneyCharacter4.textColor = TITLECOLOR;
    moneyCharacter4.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter4 setText:@"$"];
    [self.subView addSubview:moneyCharacter4];
    [moneyCharacter4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchasePriceFiled.mas_top);
        make.right.equalTo(purchasePriceLbl.mas_right);
        make.left.equalTo(_purchasePriceFiled.mas_right);
        make.height.equalTo(_purchasePriceFiled.mas_height);
    }];
    
    UIView *purchasePriceUnderLine  = [[UIView alloc] init];
    [purchasePriceUnderLine setBackgroundColor:LIGHTGRAYCOLOR];
    [self.subView addSubview:purchasePriceUnderLine];
    [purchasePriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchasePriceFiled.mas_bottom);
        make.left.equalTo(_purchasePriceFiled.mas_left);
        make.right.equalTo(purchasePriceLbl.mas_right);
        make.height.equalTo(@1);
    }];
    //****************
    UILabel *otherPriceLbl = [[UILabel alloc]init];
    otherPriceLbl.font = DiscountFONT;
    otherPriceLbl.textColor = TITLECOLOR;
    otherPriceLbl.textAlignment = NSTextAlignmentLeft;
    [otherPriceLbl setText:@"其它成本"];
    [self.subView addSubview:otherPriceLbl];
    [otherPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchasePriceLbl.mas_top);
        make.left.equalTo(purchasePriceLbl.mas_right).with.offset(LEFTSIDEPADDING);
        make.width.equalTo(@(threeLblWith));
        make.height.equalTo(@10);
    }];
    
    _otherPriceFiled = [[UITextField alloc]initHasAccessory];
    [_otherPriceFiled setFont:DiscountFONT];
    [_otherPriceFiled setTextColor:TITLECOLOR];
    _otherPriceFiled.textAlignment = NSTextAlignmentLeft;
    _otherPriceFiled.delegate = self;
    [_otherPriceFiled setPlaceholder:@"0.0"];
    _otherPriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:_otherPriceFiled];
    [_otherPriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherPriceLbl.mas_bottom).with.offset(10);
        make.left.equalTo(otherPriceLbl.mas_left);
        make.right.equalTo(otherPriceLbl.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UILabel *moneyCharacter5 = [[UILabel alloc]init];
    moneyCharacter5.font = DiscountFONT;
    moneyCharacter5.textColor = TITLECOLOR;
    moneyCharacter5.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter5 setText:@"$"];
    [self.subView addSubview:moneyCharacter5];
    [moneyCharacter5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_otherPriceFiled.mas_top);
        make.right.equalTo(otherPriceLbl.mas_right);
        make.left.equalTo(_otherPriceFiled.mas_right);
        make.height.equalTo(_otherPriceFiled.mas_height);
    }];
    
    UIView *otherPriceUnderLine  = [[UIView alloc] init];
    [otherPriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:otherPriceUnderLine];
    [otherPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_otherPriceFiled.mas_bottom);
        make.left.equalTo(_otherPriceFiled.mas_left);
        make.right.equalTo(otherPriceLbl.mas_right);
        make.height.equalTo(@1);
    }];
    //****************
    UILabel *benefitPriceLbl = [[UILabel alloc]init];
    benefitPriceLbl.font = DiscountFONT;
    benefitPriceLbl.textColor = TITLECOLOR;
    benefitPriceLbl.textAlignment = NSTextAlignmentLeft;
    [benefitPriceLbl setText:@"利润"];
    [self.subView addSubview:benefitPriceLbl];
    [benefitPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchasePriceLbl.mas_top);
        make.left.equalTo(otherPriceLbl.mas_right).with.offset(LEFTSIDEPADDING);
        make.width.equalTo(@(threeLblWith));
        make.height.equalTo(@10);
    }];
    
    _benefitPriceFiled = [[UITextField alloc]initHasAccessory];
    [_benefitPriceFiled setFont:DiscountFONT];
    [_benefitPriceFiled setTextColor:LIGHTGRAYCOLOR];
    _benefitPriceFiled.textAlignment = NSTextAlignmentLeft;
    _benefitPriceFiled.delegate = self;
    [_benefitPriceFiled setPlaceholder:@"0.0"];
    _benefitPriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    _benefitPriceFiled.enabled = NO;
    [self.subView addSubview:_benefitPriceFiled];
    [_benefitPriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(benefitPriceLbl.mas_bottom).with.offset(10);
        make.left.equalTo(benefitPriceLbl.mas_left);
        make.right.equalTo(benefitPriceLbl.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UILabel *moneyCharacter6 = [[UILabel alloc]init];
    moneyCharacter6.font = DiscountFONT;
    moneyCharacter6.textColor = TITLECOLOR;
    moneyCharacter6.textAlignment = NSTextAlignmentLeft;
    [moneyCharacter6 setText:@"¥"];
    [self.subView addSubview:moneyCharacter6];
    [moneyCharacter6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_benefitPriceFiled.mas_top);
        make.right.equalTo(benefitPriceLbl.mas_right);
        make.left.equalTo(_benefitPriceFiled.mas_right);
        make.height.equalTo(_benefitPriceFiled.mas_height);
    }];
    
    UIView *benefitPriceUnderLine  = [[UIView alloc] init];
    [benefitPriceUnderLine setBackgroundColor:LIGHTGRAYCOLOR];
    [self.subView addSubview:benefitPriceUnderLine];
    [benefitPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_benefitPriceFiled.mas_bottom);
        make.left.equalTo(_benefitPriceFiled.mas_left);
        make.right.equalTo(benefitPriceLbl.mas_right);
        make.height.equalTo(@1);
    }];
    
    //*****************
    _notePriceFiled = [[UITextField alloc]initHasAccessory];
    [_notePriceFiled setFont:DiscountFONT];
    [_notePriceFiled setTextColor:TITLECOLOR];
    _notePriceFiled.textAlignment = NSTextAlignmentLeft;
    _notePriceFiled.delegate = self;
    [_notePriceFiled setPlaceholder:@"备注"];
    [self.subView addSubview:_notePriceFiled];
    [_notePriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(benefitPriceUnderLine.mas_bottom).with.offset(20);
        make.left.equalTo(self.subView).with.offset(10);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UIView *notePriceUnderLine  = [[UIView alloc] init];
    [notePriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:notePriceUnderLine];
    [notePriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_notePriceFiled.mas_bottom);
        make.left.equalTo(_notePriceFiled.mas_left);
        make.right.equalTo(_notePriceFiled.mas_right);
        make.height.equalTo(@1);
    }];
    //********************
    

    
    UIImage *cameraImage = [IonIcons imageWithIcon:ion_camera size:kTabICONSIZE color:[UIColor whiteColor]];
    UIButton *cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundColor:THEMECOLOR];
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40.0f)];
    [cameraButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0.0f)];
    [cameraButton setImage:cameraImage forState:UIControlStateNormal];
    [self.subView addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(takPhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notePriceUnderLine.mas_bottom).with.offset(10);
        make.left.equalTo(notePriceUnderLine.mas_left);
        make.width.equalTo(@((kWindowWidth-42)/2));
        make.height.equalTo(@44);
    }];
    
    UIView *buttonsLine = [[UIView alloc]init];
    [buttonsLine setBackgroundColor:[UIColor grayColor]];
    [self.subView addSubview:buttonsLine];
    [buttonsLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top).with.offset(6);
        make.bottom.equalTo(cameraButton.mas_bottom).with.offset(-6);
        make.left.equalTo(cameraButton.mas_right).with.offset(10);
        make.width.equalTo(@2);
    }];
    
    UIImage *pictureImage = [IonIcons imageWithIcon:ion_image size:kTabICONSIZE color:[UIColor whiteColor]];
    UIButton *picutreButton = [[UIButton alloc]init];
    [picutreButton setBackgroundColor:THEMECOLOR];

    [picutreButton setTitle:@"相册" forState:UIControlStateNormal];
    [picutreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [picutreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40.0f)];
    [picutreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0.0f)];
    [picutreButton setImage:pictureImage forState:UIControlStateNormal];
    [picutreButton addTarget:self action:@selector(takPhotoFromAlbum)forControlEvents:UIControlEventTouchUpInside];

    [self.subView addSubview:picutreButton];
    [picutreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top);
        make.left.equalTo(buttonsLine.mas_right).with.offset(10);
        make.bottom.equalTo(cameraButton.mas_bottom);
        make.right.equalTo(_notePriceFiled.mas_right);
    }];
    
    [self setValueForField];
}

- (void)takPhotoFromCamera {

}

- (void)takPhotoFromAlbum {

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _productInfoField) {
        NSLog(@"goto CustomInfo");
        _EditPriceActionBlock(12, textField.frame);
        return NO;
    } else if (textField == _customInfoField) {
        NSLog(@"gotoProductInfo");
        _EditPriceActionBlock(11, textField.frame);
        return NO;
    } else {
        CGPoint originInSuperview = [self.contentView convertPoint:CGPointZero fromView:textField];
        textField.frame = CGRectMake(originInSuperview.x, originInSuperview.y, textField.frame.size.width, textField.frame.size.height);
         _EditPriceActionBlock(30, textField.frame);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _totalPriceField) {
        _discountField.text = [NSString stringWithFormat:@"%0.2f", [self calculateDicountValue]];
        _benefitPriceFiled.text = [NSString stringWithFormat:@"%0.2f",[self calculateBenefitValue]];
    } else if (textField == _otherPriceFiled) {
        _benefitPriceFiled.text = [NSString stringWithFormat:@"%0.2f",[self calculateBenefitValue]];
    }
}

- (float)calculateDicountValue {
    float benefitValue =[_subTotalField.text floatValue] -[_totalPriceField.text floatValue];
    if (benefitValue > 0) {
        return benefitValue;
    } else {
        return 0.0f;
    }
}

- (float)calculateBenefitValue {
    float otherPrice = [_otherPriceFiled.text floatValue]*EXCHANGERATE;
    float newBenefitPrice = ([_totalPriceField.text floatValue]-[_purchasePriceFiled.text floatValue]*EXCHANGERATE)-otherPrice;
    return newBenefitPrice;
}

- (void)updatePaymentStatus {
    if (_orderItem.payDate != 0) {
        [_payStatus setTitle:@"已付款" forState:UIControlStateNormal];
        [_payStatus setBackgroundColor:THEMECOLOR];
        _orderItem.payDate = 0;
    } else {
        [_payStatus setTitle:@"未付款" forState:UIControlStateNormal];
        [_payStatus setBackgroundColor:[UIColor lightGrayColor]];
        _orderItem.payDate = [NSDate timeIntervalSinceReferenceDate];
    }
}

- (void)setBenefitData:(NSDictionary *)benefitData {
    _benefitData = benefitData;
    [self setValueForField];
}

- (void)setValueForField {
    self.subTotalField.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"totalvalue"]];
    self.discountField.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"discountvalue"]];
    self.totalPriceField.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"finalvalue"]];
    self.purchasePriceFiled.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"purchasevalue"]];
    self.otherPriceFiled.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"othervalue"]];
    self.benefitPriceFiled.text = [NSString stringWithFormat:@"%@",[_benefitData objectForKey:@"benefitvalue"]];
}

- (void)updateCellWithTitle:(NSString*)titleName detailInformation:(NSString*)detailInfo{
//    self.titleName.text = @"";
//    self.detailInfo.text = @"";
//    self.title =titleName;
//    self.value = detailInfo;
}

@end
