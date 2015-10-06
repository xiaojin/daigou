//
//  AddNewProcurementViewController.m
//  Daigou
//
//  Created by jin on 5/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "AddNewProcurementViewController.h"
#import "CommonDefines.h"
#import "UITextField+UITextFieldAccessory.h"
#import "JVFloatLabeledTextField.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "UIScanViewController.h"
#import "OProductItem.h"
#import "Product.h"
#import "OrderItemManagement.h"
#import "ProductManagement.h"
#import "MProductsViewController.h"

@interface AddNewProcurementViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIScanViewControllerDelegate, MProductsViewControllerDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *productField;
@property(nonatomic, strong)JVFloatLabeledTextField *refPriceField;
@property(nonatomic, strong)JVFloatLabeledTextField *quantityField;
@property(nonatomic, strong)JVFloatLabeledTextField *noteField;
@property(nonatomic, strong)Product *addProduct;
@property(nonatomic, strong)UIButton *productScanButton;

@end

@implementation AddNewProcurementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    [self registNotification];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewProcurement)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.title = @"添加囤货商品";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
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
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + 100.0f);
}

- (void)makeView {
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
    _productField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _productField.delegate = self;
    _productField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _productField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商品"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _productField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _productField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_productField];
    [_productField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(5);
        make.width.equalTo(self.view).with.offset(-65);
        make.height.equalTo(@44);
    }];
    _productField.keepBaseline = YES;
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productField.mas_bottom);
        make.left.equalTo(_productField.mas_left);
        make.right.equalTo(_productField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _productScanButton = [[UIButton alloc]init];
    UIImage *scanBarImage = [IonIcons imageWithIcon:ion_qr_scanner iconColor:fontColor iconSize:40 imageSize:CGSizeMake(40, 40)];
    [_productScanButton setImage:scanBarImage forState:UIControlStateNormal];
    [_productScanButton addTarget:self action:@selector(handleScanBar:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_productScanButton];
    [_productScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productField.mas_right).with.offset(10);
        make.bottom.equalTo(_productField.mas_bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.height.equalTo(@40);
    }];
    
    _refPriceField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _refPriceField.delegate = self;
    _refPriceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _refPriceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"参考价格"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _refPriceField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _refPriceField.floatingLabelTextColor = floatingLabelColor;
    [_refPriceField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_contentView addSubview:_refPriceField];
    [_refPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productField.mas_bottom).with.offset(10);
        make.left.equalTo(_productField.mas_left);
        make.right.equalTo(self.view.mas_centerX).with.offset(-15);
        make.height.equalTo(@44);
    }];
    _refPriceField.keepBaseline = YES;
    
    UILabel *dollarLable1 = [[UILabel alloc]init];
    dollarLable1.font = MONEYSYMFONT;
    dollarLable1.textColor = fontColor;
    dollarLable1.textAlignment = NSTextAlignmentLeft;
    [dollarLable1 setText:@"$"];
    [_contentView addSubview:dollarLable1];
    [dollarLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_refPriceField.mas_bottom).with.offset(-5);
        make.right.equalTo(self.view.mas_centerX).with.offset(-5);
        make.left.equalTo(_refPriceField.mas_right);
        make.height.equalTo(@22);
    }];
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refPriceField.mas_bottom);
        make.left.equalTo(_refPriceField.mas_left);
        make.right.equalTo(dollarLable1.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _quantityField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _quantityField.delegate = self;
    _quantityField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _quantityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"数量"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _quantityField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _quantityField.floatingLabelTextColor = floatingLabelColor;
    [_quantityField setKeyboardType:UIKeyboardTypeNumberPad];
    [_contentView addSubview:_quantityField];
    [_quantityField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refPriceField.mas_top);
        make.left.equalTo(self.view.mas_centerX).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];
    _quantityField.keepBaseline = YES;
    
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_quantityField.mas_bottom);
        make.left.equalTo(_quantityField.mas_left);
        make.right.equalTo(_quantityField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _noteField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _noteField.tag = NEWPROCUREMENTTAG + 5;
    _noteField.delegate = self;
    _noteField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _noteField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备注"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _noteField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _noteField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_noteField];
    [_noteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_quantityField.mas_bottom).with.offset(10);
        make.left.equalTo(_productField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
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
        make.bottom.equalTo(div4.mas_bottom);
    }];
}

- (void)saveNewProcurement {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    OProductItem *productItem = [OProductItem new];
    productItem.statu = PRODUCT_PURCHASE;
    productItem.productid = _addProduct.pid;
    productItem.refprice = _addProduct.purchaseprice;
    productItem.price = _addProduct.purchaseprice;
    productItem.amount = 1;
    productItem.orderid = 0;
    NSInteger count = [_quantityField.text integerValue];
    NSMutableArray *products = [NSMutableArray array];
    if (count <= 0) {
        count = 1;
    }
    for (int i = 0; i < count; i++) {
        [products addObject:productItem];
    }
    [itemManagement insertOrderProductItems:products withNull:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchProductByBarCode:(NSString *)barcode {
    ProductManagement *productManagement = [[ProductManagement alloc] init];
    self.addProduct = [productManagement getProductByBarCode:barcode];
}

#pragma mark - MProductsViewControllerDelegate
- (void)didSelectProduct:(Product *)product {
    self.addProduct = product;
    [_productField setText:product.name];
    [_refPriceField setText:[NSString stringWithFormat:@"%.2f",product.purchaseprice]];
}


#pragma mark --scameBarcode

// 读二维码
- (void)handleScanBar:(id)sender {
    // 扫描二维码
    // 1. init ViewController
    UIScanViewController *VC = [[UIScanViewController alloc] init];
    VC.isQR = NO;
    // 2. configure ViewController
    VC.delegate = self;
    
    // 3. show ViewController
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)didFinishedReadingQR:(NSString *)string {
    [self searchProductByBarCode:string];
    NSString *productName = @"";
    if (self.addProduct != nil) {
        productName = [NSString stringWithFormat:@"%@",[self.addProduct name]];
    }
    [_productField setText:productName];
    NSLog(@"%@",string);
}

#pragma mark -- UITextFieldDeletgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _productField) {
        MProductsViewController *productsViewController = [[MProductsViewController alloc]init];
        productsViewController.hidesBottomBarWhenPushed = YES;
        productsViewController.delegate = self;
        [self.navigationController pushViewController:productsViewController animated:YES];
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
