//
//  MSellInfoViewController.m
//  Daigou
//
//  Created by jin on 9/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MSellInfoViewController.h"
#import "SellInfo.h"
#import "SellInfoManagement.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "JVFloatLabeledTextField.h"
#import "UITextField+UITextFieldAccessory.h"
#import "ErrorHelper.h"


@interface MSellInfoViewController ()<UITextFieldDelegate, UIScrollViewDelegate>{
    CGSize keyboardSize;
}
@property (nonatomic, strong)SellInfo *sellInfo;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *nameField;
@property(nonatomic, strong)JVFloatLabeledTextField *storeNameField;
@property(nonatomic, strong)JVFloatLabeledTextField *slogonField;
@property(nonatomic, strong)JVFloatLabeledTextField *addressField;
@property(nonatomic, strong)JVFloatLabeledTextField *emailField;
@property(nonatomic, strong)JVFloatLabeledTextField *postcodeField;
@property(nonatomic, strong)JVFloatLabeledTextField *phonenumField;
@property(nonatomic, strong)JVFloatLabeledTextField *idnumField;
@property(nonatomic, strong)JVFloatLabeledTextField *bankinfoField;
@end

@implementation MSellInfoViewController

- (instancetype)init {
    if(self = [super init]) {
        [self getSellInfo];
    }
    return self;
}

- (void)getSellInfo {
    SellInfoManagement *sellInfoMangement = [SellInfoManagement shareInstance];
    _sellInfo =[sellInfoMangement getSellInfo];
    
}

- (void)setNavigationView {
    self.title = @"卖家信息";
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSellInfo)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
}

- (void)addContentView {
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _contentView = [[UIView alloc]init];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    UIColor *fontColor = FONTCOLOR;
    _nameField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"名字"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _nameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameField.floatingLabelTextColor = floatingLabelColor;
    _nameField.text = _sellInfo.name;
    [_contentView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(10.0f);
        make.width.equalTo(self.view).with.offset(-10.0f);
        make.height.equalTo(@44);
    }];
    _nameField.keepBaseline = YES;
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom);
        make.left.equalTo(_nameField.mas_left);
        make.right.equalTo(_nameField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _addressField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _addressField.delegate = self;
    _addressField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商家地址"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _addressField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _addressField.floatingLabelTextColor = floatingLabelColor;
    _addressField.text = _sellInfo.address;

    [_contentView addSubview:_addressField];
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
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
    
    _storeNameField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _storeNameField.delegate = self;
    _storeNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _storeNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商店姓名"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _storeNameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _storeNameField.floatingLabelTextColor = floatingLabelColor;
    _storeNameField.text = _sellInfo.storename;

    [_contentView addSubview:_storeNameField];
    [_storeNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _storeNameField.keepBaseline = YES;
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storeNameField.mas_bottom);
        make.left.equalTo(_storeNameField.mas_left);
        make.right.equalTo(_storeNameField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _slogonField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _slogonField.delegate = self;
    _slogonField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _slogonField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商店介绍"
                                                                            attributes:@{NSForegroundColorAttributeName: fontColor}];
    _slogonField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _slogonField.floatingLabelTextColor = floatingLabelColor;
    _slogonField.text = _sellInfo.slogon;

    [_contentView addSubview:_slogonField];
    [_slogonField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storeNameField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _slogonField.keepBaseline = YES;
    
    UIView *div4 = [UIView new];
    div4.backgroundColor = LINECOLOR;
    [_contentView addSubview:div4];
    [div4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slogonField.mas_bottom);
        make.left.equalTo(_slogonField.mas_left);
        make.right.equalTo(_slogonField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _emailField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _emailField.delegate = self;
    _emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮箱"
                                                                         attributes:@{NSForegroundColorAttributeName: fontColor}];
    _emailField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _emailField.floatingLabelTextColor = floatingLabelColor;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.text = _sellInfo.email;

    [_contentView addSubview:_emailField];
    [_emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slogonField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _emailField.keepBaseline = YES;
    
    UIView *div5 = [UIView new];
    div5.backgroundColor = LINECOLOR;
    [_contentView addSubview:div5];
    [div5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailField.mas_bottom);
        make.left.equalTo(_emailField.mas_left);
        make.right.equalTo(_emailField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _postcodeField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _postcodeField.delegate = self;
    _postcodeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _postcodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮政编码"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _postcodeField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _postcodeField.floatingLabelTextColor = floatingLabelColor;
    _postcodeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _postcodeField.text = _sellInfo.postcode;

    [_contentView addSubview:_postcodeField];
    [_postcodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _postcodeField.keepBaseline = YES;
    
    UIView *div6 = [UIView new];
    div6.backgroundColor = LINECOLOR;
    [_contentView addSubview:div6];
    [div6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postcodeField.mas_bottom);
        make.left.equalTo(_postcodeField.mas_left);
        make.right.equalTo(_postcodeField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _phonenumField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _phonenumField.delegate = self;
    _phonenumField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _phonenumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"联系电话"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _phonenumField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _phonenumField.floatingLabelTextColor = floatingLabelColor;
    _phonenumField.keyboardType = UIKeyboardTypePhonePad;
    _phonenumField.text = _sellInfo.phonenum;

    [_contentView addSubview:_phonenumField];
    [_phonenumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postcodeField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _phonenumField.keepBaseline = YES;
    
    UIView *div7 = [UIView new];
    div7.backgroundColor = LINECOLOR;
    [_contentView addSubview:div7];
    [div7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phonenumField.mas_bottom);
        make.left.equalTo(_phonenumField.mas_left);
        make.right.equalTo(_phonenumField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _idnumField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _idnumField.delegate = self;
    _idnumField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _idnumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"身份证号"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _idnumField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _idnumField.floatingLabelTextColor = floatingLabelColor;
    _idnumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _idnumField.text = _sellInfo.idnum;

    [_contentView addSubview:_idnumField];
    [_idnumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phonenumField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _idnumField.keepBaseline = YES;
    
    UIView *div8 = [UIView new];
    div8.backgroundColor = LINECOLOR;
    [_contentView addSubview:div8];
    [div8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idnumField.mas_bottom);
        make.left.equalTo(_idnumField.mas_left);
        make.right.equalTo(_idnumField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _bankinfoField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _bankinfoField.delegate = self;
    _bankinfoField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _bankinfoField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"银行信息"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _bankinfoField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _bankinfoField.floatingLabelTextColor = floatingLabelColor;
    _bankinfoField.text = _sellInfo.bankinfo;

    [_contentView addSubview:_bankinfoField];
    [_bankinfoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idnumField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(_nameField.mas_width);
        make.height.equalTo(@44);
    }];
    _bankinfoField.keepBaseline = YES;
    
    UIView *div9 = [UIView new];
    div9.backgroundColor = LINECOLOR;
    [_contentView addSubview:div9];
    [div9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankinfoField.mas_bottom);
        make.left.equalTo(_bankinfoField.mas_left);
        make.right.equalTo(_bankinfoField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(div9.mas_bottom).with.offset(10);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationView];
    [self addContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SaveCustomInfo
- (void)saveSellInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    if (_sellInfo == nil) {
        _sellInfo = [[SellInfo alloc] init];
    }
    _sellInfo.name = _nameField.text;
    if ([_sellInfo.name isEqualToString:@""] || _sellInfo.name == nil) {
        [ErrorHelper showErrorAlertWithTitle:@"卖家信息" message:@"卖家信息不能为空"];
        return;
    }
    
    SellInfoManagement *sellInfoManagement = [SellInfoManagement shareInstance];
    _sellInfo.name = _nameField.text;
    _sellInfo.address = _addressField.text;
    _sellInfo.storename = _storeNameField.text;
    _sellInfo.slogon = _slogonField.text;
    _sellInfo.email = _emailField.text;
    _sellInfo.postcode = _postcodeField.text;
    _sellInfo.phonenum = _phonenumField.text;
    _sellInfo.idnum = _idnumField.text;
    _sellInfo.bankinfo = _bankinfoField.text;
    double dateTime = [[NSDate date] timeIntervalSince1970];
    _sellInfo.syncDate = dateTime;
    BOOL result = [sellInfoManagement updateSellInfo:_sellInfo];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
