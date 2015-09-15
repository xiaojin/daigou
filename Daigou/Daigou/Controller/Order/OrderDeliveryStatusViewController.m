//
//  OrderDeliveryStatusViewController.m
//  Daigou
//
//  Created by jin on 16/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderDeliveryStatusViewController.h"
#import "JVFloatLabeledTextField.h"
#import "UITextField+UITextFieldAccessory.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "UIScanViewController.h"
#import "MCustInfoViewController.h"
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "ExpressManagement.h"
#import "Express.h"
#import "OrderItem.h"

#define ORDERTAGBASE 80000;

@interface OrderDeliveryStatusViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIScanViewControllerDelegate,MCustInfoViewControllerDelegate>{
    CGSize keyboardSize;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *receiverField;
@property(nonatomic, strong)JVFloatLabeledTextField *addressField;
@property(nonatomic, strong)JVFloatLabeledTextField *contactField;
@property(nonatomic, strong)JVFloatLabeledTextField *idNumberField;
@property(nonatomic, strong)JVFloatLabeledTextField *postCodeField;
@property(nonatomic, strong)JVFloatLabeledTextField *deliveryPriceField;
@property(nonatomic, strong)JVFloatLabeledTextField *deliveryTrackCodeField;
@property(nonatomic, strong)JVFloatLabeledTextField *deliveryCompanyField;
@property(nonatomic, strong)UIButton *contactBtn;
@property(nonatomic, strong)UIButton *addressBtn;
@property(nonatomic, strong)UIButton *deliveryScanBtn;
@property(nonatomic, strong)Express *express;
@end

@implementation OrderDeliveryStatusViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getExpress];
    [self addContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)addContentView {
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _contentView = [[UIView alloc]init];
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    UIColor *fontColor = FONTCOLOR;
    
    _receiverField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _receiverField.delegate = self;
    _receiverField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _receiverField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"收件人姓名"
                                                                              attributes:@{NSForegroundColorAttributeName: fontColor}];
    _receiverField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _receiverField.floatingLabelTextColor = floatingLabelColor;
    [_receiverField setText:_receiverInfo.name];
    [_contentView addSubview:_receiverField];
    [_receiverField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(5);
        make.width.equalTo(_contentView).with.offset(-80);
        make.height.equalTo(@44);
    }];
    _receiverField.keepBaseline = YES;    
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiverField.mas_bottom);
        make.left.equalTo(_receiverField.mas_left);
        make.right.equalTo(_receiverField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _contactBtn = [[UIButton alloc]init];
    [_contactBtn setImage:[IonIcons imageWithIcon:ion_person iconColor:fontColor iconSize:40 imageSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [_contactBtn addTarget:self action:@selector(selectContactInfo) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_contactBtn];
    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_receiverField.mas_right);
        make.bottom.equalTo(div1.mas_bottom).with.offset(2);
        make.right.equalTo(_contentView);
        make.height.equalTo(@40);
    }];
    
    _addressField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _addressField.delegate = self;
    _addressField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"地址"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _addressField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _addressField.floatingLabelTextColor = floatingLabelColor;
    [_addressField setText:_orderItem.address];
    [_contentView addSubview:_addressField];
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiverField.mas_bottom).with.offset(10);
        make.left.equalTo(_receiverField.mas_left);
        make.width.equalTo(_contentView).with.offset(-80);
        make.height.equalTo(@44);
    }];
    _addressField.keepBaseline = YES;
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressField.mas_bottom);
        make.left.equalTo(_addressField.mas_left);
        make.right.equalTo(_addressField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _addressBtn = [[UIButton alloc]init];
    [_addressBtn setImage:[IonIcons imageWithIcon:ion_home iconColor:fontColor iconSize:40 imageSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [_addressBtn addTarget:self action:@selector(selectContactAddress) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_addressBtn];
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressField.mas_right);
        make.bottom.equalTo(div2.mas_bottom).with.offset(2);
        make.right.equalTo(_contentView);
        make.height.equalTo(@40);
    }];
    
    _contactField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _contactField.delegate = self;
    _contactField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _contactField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"联系电话"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _contactField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _contactField.floatingLabelTextColor = floatingLabelColor;
    [_contactField setText:_orderItem.phonenumber];
    _contactField.keyboardType = UIKeyboardTypePhonePad;
    [_contentView addSubview:_contactField];
    [_contactField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressField.mas_bottom).with.offset(10);
        make.left.equalTo(_receiverField.mas_left);
        make.width.equalTo(_contentView).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _contactField.keepBaseline = YES;

    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contactField.mas_bottom);
        make.left.equalTo(_contactField.mas_left);
        make.right.equalTo(_contactField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _idNumberField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _idNumberField.delegate = self;
    _idNumberField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _idNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"身份证号"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _idNumberField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _idNumberField.floatingLabelTextColor = floatingLabelColor;
    _idNumberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_idNumberField setText:_orderItem.idnum];
    [_contentView addSubview:_idNumberField];
    [_idNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contactField.mas_bottom).with.offset(10);
        make.left.equalTo(_receiverField.mas_left);
        make.width.equalTo(_contentView).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _idNumberField.keepBaseline = YES;

    
    UIView *div4 = [UIView new];
    div4.backgroundColor = LINECOLOR;
    [_contentView addSubview:div4];
    [div4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idNumberField.mas_bottom);
        make.left.equalTo(_idNumberField.mas_left);
        make.right.equalTo(_idNumberField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _postCodeField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _postCodeField.delegate = self;
    _postCodeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _postCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮政编码"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _postCodeField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _postCodeField.floatingLabelTextColor = floatingLabelColor;
    
    [_postCodeField setText:_orderItem.postcode];
    [_postCodeField setKeyboardType:UIKeyboardTypePhonePad];
    [_contentView addSubview:_postCodeField];
    [_postCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idNumberField.mas_bottom).with.offset(10);;
        make.left.equalTo(_receiverField.mas_left);
        make.right.equalTo(_contentView.mas_centerX);
        make.height.equalTo(@44);
    }];
    _postCodeField.keepBaseline = YES;


    UIView *div5 = [UIView new];
    div5.backgroundColor = LINECOLOR;
    [_contentView addSubview:div5];
    [div5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_bottom);
        make.left.equalTo(_postCodeField.mas_left);
        make.right.equalTo(_postCodeField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _deliveryPriceField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _deliveryPriceField.delegate = self;
    _deliveryPriceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _deliveryPriceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"快递价格"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _deliveryPriceField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _deliveryPriceField.floatingLabelTextColor = floatingLabelColor;
    [_deliveryPriceField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_deliveryPriceField setText:[NSString stringWithFormat:@"%.1f", _orderItem.delivery]];
    [_contentView addSubview:_deliveryPriceField];
    [_deliveryPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_top);
        make.left.equalTo(_contentView.mas_centerX).with.offset(5);
        make.right.equalTo(_contentView).with.offset(-85);;
        make.height.equalTo(@44);
    }];
    _deliveryPriceField.keepBaseline = YES;
    
    UILabel *dollarLable = [[UILabel alloc]init];
    dollarLable.font = MONEYSYMFONT;
    dollarLable.textColor = fontColor;
    dollarLable.textAlignment = NSTextAlignmentLeft;
    [dollarLable setText:@"$"];
    [_contentView addSubview:dollarLable];
    [dollarLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_deliveryPriceField.mas_bottom).with.offset(-5);
        make.width.equalTo(@10);
        make.left.equalTo(_deliveryPriceField.mas_right);
        make.height.equalTo(@22);
    }];
    
    UIView *div6 = [UIView new];
    div6.backgroundColor = LINECOLOR;
    [_contentView addSubview:div6];
    [div6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deliveryPriceField.mas_bottom);
        make.left.equalTo(_deliveryPriceField.mas_left);
        make.right.equalTo(dollarLable.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    UIButton *deliveryBtn = [[UIButton alloc]init];
    [deliveryBtn setImage:[IonIcons imageWithIcon:ion_edit iconColor:fontColor iconSize:35 imageSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    [deliveryBtn addTarget:self action:@selector(updateDeliveryPrice) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:deliveryBtn];
    [deliveryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dollarLable.mas_right);
        make.bottom.equalTo(div6.mas_bottom).with.offset(2);
        make.right.equalTo(_contentView.mas_right);
        make.height.equalTo(@40);
    }];
    
    _deliveryTrackCodeField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _deliveryTrackCodeField.delegate = self;
    _deliveryTrackCodeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _deliveryTrackCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"货运单号"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _deliveryTrackCodeField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _deliveryTrackCodeField.floatingLabelTextColor = floatingLabelColor;
    _deliveryTrackCodeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_deliveryTrackCodeField setText:_orderItem.barcode];
    [_contentView addSubview:_deliveryTrackCodeField];
    [_deliveryTrackCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_bottom).with.offset(10);
        make.left.equalTo(_receiverField.mas_left);
        make.width.equalTo(_contentView).with.offset(-80);
        make.height.equalTo(@44);
    }];
    _deliveryTrackCodeField.keepBaseline = YES;
    
    UIView *div7 = [UIView new];
    div7.backgroundColor = LINECOLOR;
    [_contentView addSubview:div7];
    [div7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deliveryTrackCodeField.mas_bottom);
        make.left.equalTo(_deliveryTrackCodeField.mas_left);
        make.right.equalTo(_deliveryTrackCodeField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _deliveryScanBtn = [[UIButton alloc]init];
    [_deliveryScanBtn setImage:[IonIcons imageWithIcon:ion_qr_scanner iconColor:fontColor iconSize:40 imageSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [_deliveryScanBtn addTarget:self action:@selector(scanDeliveryStaus) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_deliveryScanBtn];
    [_deliveryScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deliveryTrackCodeField.mas_right);
        make.bottom.equalTo(div7.mas_bottom).with.offset(2);
        make.right.equalTo(_contentView);
        make.height.equalTo(@40);
    }];
    
    
    
    _deliveryCompanyField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _deliveryCompanyField.delegate = self;
    _deliveryCompanyField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _deliveryCompanyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"快递公司"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _deliveryCompanyField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _deliveryCompanyField.floatingLabelTextColor = floatingLabelColor;
    [_deliveryCompanyField setText:_express.name];
    [_contentView addSubview:_deliveryCompanyField];
    [_deliveryCompanyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deliveryTrackCodeField.mas_bottom).with.offset(10);
        make.left.equalTo(_receiverField.mas_left);
        make.width.equalTo(_contentView).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _deliveryCompanyField.keepBaseline = YES;
    
    UIView *div8 = [UIView new];
    div8.backgroundColor = LINECOLOR;
    [_contentView addSubview:div8];
    [div8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deliveryCompanyField.mas_bottom);
        make.left.equalTo(_deliveryCompanyField.mas_left);
        make.right.equalTo(_deliveryCompanyField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(div8.mas_bottom).with.offset(15);
    }];
}


- (void)selectContactInfo {
    MCustInfoViewController *customInfoViewController = [[MCustInfoViewController alloc]init];
    customInfoViewController.customDelegate = self;
    [self.navigationController pushViewController:customInfoViewController animated:YES];
}

- (void)getExpress {
    ExpressManagement *expressManagement = [ExpressManagement shareInstance];
    _express = [expressManagement getExpressById:_orderItem.expressid];
}

- (void)selectContactAddress {
    NSLog(@"Button pressed");
}

- (void)updateDeliveryPrice {
    NSLog(@"Button pressed");
}

- (void)navigateTDeliveryCompanyManagerment {
    NSLog(@"Navigation to Delivery Management");
}

#pragma mark - MCustomInfoViewControllerDelegate
- (void)didSelectCustomInfo:(CustomInfo *)customInfo {
    _receiverInfo = customInfo;
    _receiverField.text = customInfo.name;
}

#pragma mark -scaneBarCode
- (void)scanDeliveryStaus {
    UIScanViewController *VC = [[UIScanViewController alloc] init];
    VC.isQR = NO;
    VC.delegate = self;
    [self presentViewController:VC animated:YES completion:nil];
}


- (void)didFinishedReadingQR:(NSString *)string {
    [_deliveryTrackCodeField setText:string];
    NSLog(@"%@",string);
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _deliveryCompanyField){
        [self navigateTDeliveryCompanyManagerment];
        return NO;
    } else {
        CGFloat kbHeight = keyboardSize.height;
        if (keyboardSize.height == 0) {
            kbHeight = 402.f;
        }
        [UIView animateWithDuration:0.1 animations:^{
            UIEdgeInsets edgeInsets = [_scrollView contentInset];
            edgeInsets.bottom = kbHeight;
            [_scrollView setContentInset:edgeInsets];
            edgeInsets = [[self scrollView] scrollIndicatorInsets];
            edgeInsets.bottom = kbHeight;
            [_scrollView setScrollIndicatorInsets:edgeInsets];
            [_scrollView scrollRectToVisible:textField.frame animated:YES];
        }];
        return YES;
    }
}

#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    UIEdgeInsets edgeInsets = [_scrollView contentInset];
    edgeInsets.bottom = 140.0f;
    [_scrollView setContentInset:edgeInsets];
    edgeInsets = [_scrollView scrollIndicatorInsets];
    edgeInsets.bottom = 0;
    [_scrollView setScrollIndicatorInsets:edgeInsets];
    [_scrollView setContentInset:edgeInsets];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey ] CGRectValue].size;
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + 100.0f);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
@end
