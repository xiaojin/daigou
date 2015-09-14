//
//  MEditExpressViewController.m
//  Daigou
//
//  Created by jin on 13/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditExpressViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "JVFloatLabeledTextField.h"
#import "UITextField+UITextFieldAccessory.h"
#import "Express.h"
#import "ExpressManagement.h"
@interface MEditExpressViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    CGSize keyboardSize;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *nameField;
@property(nonatomic, strong)JVFloatLabeledTextField *priceField;
@property(nonatomic, strong)JVFloatLabeledTextField *websiteField;
@property(nonatomic, strong)JVFloatLabeledTextField *noteField;
@end

@implementation MEditExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationView];
    [self addContentView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _nameField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"名称"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _nameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(5);
        make.width.equalTo(self.view).with.offset(-20);
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
    
    _priceField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _priceField.delegate = self;
    _priceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _priceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"重量(kg)"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _priceField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _priceField.floatingLabelTextColor = floatingLabelColor;
    _priceField.keyboardType = UIKeyboardTypeDecimalPad;
    //[_receiverField setText:_product.name];
    [_contentView addSubview:_priceField];
    [_priceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).with.offset(10);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(self.view).with.offset(-30);
        make.height.equalTo(@44);
    }];
    _priceField.keepBaseline = YES;
    
    UILabel *dollarLable = [[UILabel alloc]init];
    dollarLable.font = MONEYSYMFONT;
    dollarLable.textColor = fontColor;
    dollarLable.textAlignment = NSTextAlignmentLeft;
    [dollarLable setText:@"$"];
    [_contentView addSubview:dollarLable];
    [dollarLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceField.mas_bottom).with.offset(-5);
        make.width.equalTo(@10);
        make.left.equalTo(_priceField.mas_right);
        make.height.equalTo(@22);
    }];
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceField.mas_bottom);
        make.left.equalTo(_priceField.mas_left);
        make.right.equalTo(dollarLable.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _websiteField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _websiteField.delegate = self;
    _websiteField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _websiteField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"网站"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _websiteField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _websiteField.floatingLabelTextColor = floatingLabelColor;
    _websiteField.keyboardType = UIKeyboardTypeURL;
    [_contentView addSubview:_websiteField];
    [_websiteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(5);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _websiteField.keepBaseline = YES;
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_websiteField.mas_bottom);
        make.left.equalTo(_websiteField.mas_left);
        make.right.equalTo(_websiteField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _noteField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _noteField.delegate = self;
    _noteField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _noteField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备注"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _noteField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _noteField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_noteField];
    [_noteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_websiteField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(5);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _noteField.keepBaseline = YES;
    
    UIView *div4 = [UIView new];
    div4.backgroundColor = LINECOLOR;
    [_contentView addSubview:div4];
    [div4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteField.mas_bottom);
        make.left.equalTo(_noteField.mas_left);
        make.right.equalTo(_noteField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(div4.mas_bottom).with.offset(15);
    }];
}

- (void)setNavigationView {
   self.title = @"新建快递";
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveExpress)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
}

- (void)saveExpress {
    ExpressManagement *expressManagement = [ExpressManagement shareInstance];
    Express *express = [[Express alloc]init];
    express.name = _nameField.text;
    express.website = _websiteField.text;
    express.price = [_priceField.text floatValue];
    express.syncDate = (double)[[NSDate date] timeIntervalSince1970];
    [expressManagement saveExpress:express];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
