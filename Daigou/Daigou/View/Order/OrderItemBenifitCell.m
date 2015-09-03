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
#define DiscountFONT  [UIFont systemFontOfSize:14.0f]
#define LEFTSIDEPADDING 10
#define kTabICONSIZE 26.0f
#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]
@interface OrderItemBenifitCell ()<UITextFieldDelegate>
@property(nonatomic, strong)UIView *subView;
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
    UILabel *subTotalLbl = [[UILabel alloc]init];
    subTotalLbl.font = DiscountFONT;
    subTotalLbl.textColor = TITLECOLOR;
    subTotalLbl.textAlignment = NSTextAlignmentLeft;
    [subTotalLbl setText:@"小计"];
    [self.subView addSubview:subTotalLbl];
    [subTotalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subView).with.offset(10);
        make.left.equalTo(self.subView).with.offset(10);
        make.right.equalTo(self.subView.mas_centerX).with.offset(-5);
        make.height.equalTo(@10);
    }];

    
    
    UITextField *subTotalField = [[UITextField alloc]initHasAccessory];
    [subTotalField setFont:DiscountFONT];
    [subTotalField setTextColor:TITLECOLOR];
    subTotalField.textAlignment = NSTextAlignmentLeft;
    subTotalField.delegate = self;
    [subTotalField setPlaceholder:@"0.0"];
    subTotalField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:subTotalField];
    [subTotalField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(subTotalField.mas_top);
        make.right.equalTo(subTotalLbl.mas_right);
        make.left.equalTo(subTotalField.mas_right);
        make.height.equalTo(subTotalField.mas_height);
    }];
    
    UIView *subTotalFieldUnderLine  = [[UIView alloc] init];
    [subTotalFieldUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:subTotalFieldUnderLine];
    [subTotalFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTotalField.mas_bottom);
        make.left.equalTo(subTotalField.mas_left);
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
        make.top.equalTo(self.subView).with.offset(10);
        make.left.equalTo(self.subView.mas_centerX).with.offset(5);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@10);
    }];
    
    UITextField *discountField = [[UITextField alloc]initHasAccessory];
    [discountField setFont:DiscountFONT];
    [discountField setTextColor:TITLECOLOR];
    discountField.textAlignment = NSTextAlignmentLeft;
    discountField.delegate = self;
    [discountField setPlaceholder:@"0.0"];
    discountField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:discountField];
    [discountField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(discountField.mas_top);
        make.right.equalTo(discountLbl.mas_right);
        make.left.equalTo(discountField.mas_right);
        make.height.equalTo(discountField.mas_height);
    }];
    
    UIView *disCountFieldUnderLine  = [[UIView alloc] init];
    [disCountFieldUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:disCountFieldUnderLine];
    [disCountFieldUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountField.mas_bottom);
        make.left.equalTo(discountField.mas_left);
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
    
    UITextField *totalPriceField = [[UITextField alloc]initHasAccessory];
    [totalPriceField setFont:DiscountFONT];
    [totalPriceField setTextColor:TITLECOLOR];
    totalPriceField.textAlignment = NSTextAlignmentLeft;
    totalPriceField.delegate = self;
    [totalPriceField setPlaceholder:@"0.0"];
    totalPriceField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:totalPriceField];
    [totalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(totalPriceField.mas_top);
        make.right.equalTo(totalPriceLbl.mas_right);
        make.left.equalTo(totalPriceField.mas_right);
        make.height.equalTo(totalPriceField.mas_height);
    }];
    
    UIView *totalPriceUnderLine  = [[UIView alloc] init];
    [totalPriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:totalPriceUnderLine];
    [totalPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceField.mas_bottom);
        make.left.equalTo(totalPriceField.mas_left);
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
    
    UITextField *purchasePriceFiled = [[UITextField alloc]initHasAccessory];
    [purchasePriceFiled setFont:DiscountFONT];
    [purchasePriceFiled setTextColor:TITLECOLOR];
    purchasePriceFiled.textAlignment = NSTextAlignmentLeft;
    purchasePriceFiled.delegate = self;
    [purchasePriceFiled setPlaceholder:@"0.0"];
    purchasePriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:purchasePriceFiled];
    [purchasePriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(purchasePriceFiled.mas_top);
        make.right.equalTo(purchasePriceLbl.mas_right);
        make.left.equalTo(purchasePriceFiled.mas_right);
        make.height.equalTo(purchasePriceFiled.mas_height);
    }];
    
    UIView *purchasePriceUnderLine  = [[UIView alloc] init];
    [purchasePriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:purchasePriceUnderLine];
    [purchasePriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchasePriceFiled.mas_bottom);
        make.left.equalTo(purchasePriceFiled.mas_left);
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
    
    UITextField *otherPriceFiled = [[UITextField alloc]initHasAccessory];
    [otherPriceFiled setFont:DiscountFONT];
    [otherPriceFiled setTextColor:TITLECOLOR];
    otherPriceFiled.textAlignment = NSTextAlignmentLeft;
    otherPriceFiled.delegate = self;
    [otherPriceFiled setPlaceholder:@"0.0"];
    otherPriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:otherPriceFiled];
    [otherPriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(otherPriceFiled.mas_top);
        make.right.equalTo(otherPriceLbl.mas_right);
        make.left.equalTo(otherPriceFiled.mas_right);
        make.height.equalTo(otherPriceFiled.mas_height);
    }];
    
    UIView *otherPriceUnderLine  = [[UIView alloc] init];
    [otherPriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:otherPriceUnderLine];
    [otherPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherPriceFiled.mas_bottom);
        make.left.equalTo(otherPriceFiled.mas_left);
        make.right.equalTo(otherPriceLbl.mas_right);
        make.height.equalTo(@1);
    }];
    //****************
    UILabel *benefitPriceLbl = [[UILabel alloc]init];
    benefitPriceLbl.font = DiscountFONT;
    benefitPriceLbl.textColor = TITLECOLOR;
    benefitPriceLbl.textAlignment = NSTextAlignmentLeft;
    [benefitPriceLbl setText:@"其它成本"];
    [self.subView addSubview:benefitPriceLbl];
    [benefitPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purchasePriceLbl.mas_top);
        make.left.equalTo(otherPriceLbl.mas_right).with.offset(LEFTSIDEPADDING);
        make.width.equalTo(@(threeLblWith));
        make.height.equalTo(@10);
    }];
    
    UITextField *benefitPriceFiled = [[UITextField alloc]initHasAccessory];
    [benefitPriceFiled setFont:DiscountFONT];
    [benefitPriceFiled setTextColor:TITLECOLOR];
    benefitPriceFiled.textAlignment = NSTextAlignmentLeft;
    benefitPriceFiled.delegate = self;
    [benefitPriceFiled setPlaceholder:@"0.0"];
    benefitPriceFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self.subView addSubview:benefitPriceFiled];
    [benefitPriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(benefitPriceFiled.mas_top);
        make.right.equalTo(benefitPriceLbl.mas_right);
        make.left.equalTo(benefitPriceFiled.mas_right);
        make.height.equalTo(benefitPriceFiled.mas_height);
    }];
    
    UIView *benefitPriceUnderLine  = [[UIView alloc] init];
    [benefitPriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:benefitPriceUnderLine];
    [benefitPriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(benefitPriceFiled.mas_bottom);
        make.left.equalTo(benefitPriceFiled.mas_left);
        make.right.equalTo(benefitPriceLbl.mas_right);
        make.height.equalTo(@1);
    }];
    
    //*****************
    UITextField *notePriceFiled = [[UITextField alloc]initHasAccessory];
    [notePriceFiled setFont:DiscountFONT];
    [notePriceFiled setTextColor:TITLECOLOR];
    notePriceFiled.textAlignment = NSTextAlignmentLeft;
    notePriceFiled.delegate = self;
    [notePriceFiled setPlaceholder:@"备注"];
    [self.subView addSubview:notePriceFiled];
    [notePriceFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(benefitPriceUnderLine.mas_bottom).with.offset(20);
        make.left.equalTo(self.subView).with.offset(10);
        make.right.equalTo(self.subView).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    UIView *notePriceUnderLine  = [[UIView alloc] init];
    [notePriceUnderLine setBackgroundColor:GRAYCOLOR];
    [self.subView addSubview:notePriceUnderLine];
    [notePriceUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notePriceFiled.mas_bottom);
        make.left.equalTo(notePriceFiled.mas_left);
        make.right.equalTo(notePriceFiled.mas_right);
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
    [self.subView addSubview:picutreButton];
    [picutreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top);
        make.left.equalTo(buttonsLine.mas_right).with.offset(10);
        make.bottom.equalTo(cameraButton.mas_bottom);
        make.right.equalTo(notePriceFiled.mas_right);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _EditPriceActionBlock(12);
}


- (void)updateCellWithTitle:(NSString*)titleName detailInformation:(NSString*)detailInfo{
//    self.titleName.text = @"";
//    self.detailInfo.text = @"";
//    self.title =titleName;
//    self.value = detailInfo;
}

@end
