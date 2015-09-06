//
//  UIProductDetailViewController.m
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UIProductDetailViewController.h"
#import "JVFloatLabeledTextField.h"
#import "UITextField+UITextFieldAccessory.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"

const static CGFloat kJVFieldFontSize = 14.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;
const static CGFloat kJVFieldMarginTop = 10.0f;
const static CGFloat kJVFieldMarginLeft = 10.0f;

@interface UIProductDetailViewController ()
@property(nonatomic, strong)JVFloatLabeledTextField *productNameField;
@property(nonatomic, strong)UIScrollView *scrollView;
@end

@implementation UIProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);

    UIColor *floatingLabelColor = [UIColor brownColor];

    _productNameField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
    _productNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _productNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商品名称"
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _productNameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _productNameField.floatingLabelTextColor = floatingLabelColor;
    [_scrollView addSubview:_productNameField];
    [_productNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_scrollView).with.offset(10);
        make.width.equalTo(self.view).with.offset(-110);
        make.height.equalTo(@44);
    }];

    _productNameField.keepBaseline = YES;
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [_scrollView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productNameField.mas_bottom).with.offset(2);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(_productNameField.mas_right);
        make.height.equalTo(@2);
    }];
    
    UIButton *missProduct = [[UIButton alloc]init];
    [missProduct setTitle:@"缺货产品" forState:UIControlStateNormal];
    [missProduct setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [missProduct.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    UIImage *missProductImage = [IonIcons imageWithIcon:ion_android_checkbox_outline_blank iconColor:THEMECOLOR iconSize:22 imageSize:CGSizeMake(22, 22)];
   // [missProduct setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [missProduct setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0.0f)];
    [missProduct setImage:missProductImage forState:UIControlStateNormal];
    [_scrollView addSubview:missProduct];
    [missProduct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameField.mas_right).with.offset(2);
        make.bottom.equalTo(div1.mas_bottom).with.offset(2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    //_scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
