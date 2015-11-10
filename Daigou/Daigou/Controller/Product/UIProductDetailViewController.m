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
#import "Brand.h"
#import "ProductCategory.h"
#import "BrandManagement.h"
#import "ProductCategoryManagement.h"
#import "ProductManagement.h"
#import "UIProductInfoEditViewController.h"
#import "UIScanViewController.h"
#import "MCategoryTableView.h"
#import "MBrandTableView.h"
#import "UISelectContainerViewController.h"
#import "ProductShareView.h"
#import <MMPopupView/MMPopupView.h>
#import <ShareSDK/ShareSDK.h>

@interface UIProductDetailViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIScanViewControllerDelegate,UIProductInfoEditViewControllerDelegate,MCategoryTableViewDelegate, MBrandTableViewDelegate,UIAlertViewDelegate,ProductShareViewDelegate>{
    CGSize keyboardSize;
}
@property(nonatomic, strong)JVFloatLabeledTextField *productNameField;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIButton *missProduct;
@property(nonatomic, assign)BOOL missProductStatus;
@property(nonatomic, strong)JVFloatLabeledTextField *brandField;
@property(nonatomic, strong)JVFloatLabeledTextField *categoryField;
@property(nonatomic, strong)JVFloatLabeledTextField *modelField;
@property(nonatomic, strong)JVFloatLabeledTextField *purchaseField;

@property(nonatomic, strong)JVFloatLabeledTextField *sellField;

@property(nonatomic, strong)JVFloatLabeledTextField *agentField;

@property(nonatomic, strong)JVFloatLabeledTextField *barCodeField;
@property(nonatomic, strong)UIButton *barButton;

@property(nonatomic, strong)JVFloatLabeledTextField *wightField;
//检索码
@property(nonatomic, strong)JVFloatLabeledTextField *quickidField;
//功效
@property(nonatomic, strong)JVFloatLabeledTextField *functionField;
//用法说明
@property(nonatomic, strong)JVFloatLabeledTextField *usageField;

//存储说明
@property(nonatomic, strong)JVFloatLabeledTextField *storageField;
//注意事项
@property(nonatomic, strong)JVFloatLabeledTextField *cautionField;
//备注
@property(nonatomic, strong)JVFloatLabeledTextField *noteField;

@property(nonatomic, strong)Brand *brand;
@property(nonatomic, strong)ProductCategory *prodCategory;

@property(nonatomic, strong)UITextField *currentField;
@property(nonatomic, strong) UISelectContainerViewController *containerViewController;

@end

@implementation UIProductDetailViewController


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

- (void) shareProduct {

    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        NSLog(@"animation complete");
    };
    
    ProductShareView *sharedView = [[ProductShareView alloc]init];
    sharedView.product =_product;
    sharedView.delegate = self;
    [sharedView showWithBlock:completeBlock];

}

- (void)didShareProduct:(UIImage *)shareImage product:(Product *)productInfo {
    //创建弹出菜单容器
    
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"产品详情"
                                                image:[ShareSDK pngImageWithImage:shareImage]
                                                title:@"代购管家"
                                                  url:@"http://www.idgb.co/"
                                          description:productInfo.name
                                            mediaType:SSPublishContentMediaTypeImage];
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];

}

- (void)initNavigationBar {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finishProduct)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareProduct)];
    self.navigationItem.rightBarButtonItems = @[shareItem, doneItem];
    
    UIImage *backImage = [IonIcons imageWithIcon:ion_ios_arrow_left size:26 color:SYSTEMBLUE];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 33)];
    [backButton addTarget:self action:@selector(backFromDetail) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 0)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:SYSTEMBLUE forState:UIControlStateNormal];
    
     UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情页面";
    [self initNavigationBar];
    [self registNotification];
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
    
    
    //_scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);

    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    UIColor *fontColor = FONTCOLOR;
    _productNameField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _productNameField.delegate = self;
    _productNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _productNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"商品名称"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _productNameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _productNameField.floatingLabelTextColor = floatingLabelColor;
    [_productNameField setText:_product.name];
    [_contentView addSubview:_productNameField];
    [_productNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(5);
        make.width.equalTo(self.view).with.offset(-100);
        make.height.equalTo(@44);
    }];
    _productNameField.keepBaseline = YES;
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productNameField.mas_bottom);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(_productNameField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _missProduct = [[UIButton alloc]init];
    [_missProduct setTitle:@"缺货产品" forState:UIControlStateNormal];
    [_missProduct setTitleColor:fontColor forState:UIControlStateNormal];
    [_missProduct.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self handlerMissProductCheck];
   // [missProduct setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_missProduct setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0.0f)];
    [_missProduct addTarget:self action:@selector(handlerMissProductCheck) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_missProduct];
    [_missProduct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameField.mas_right);
        make.bottom.equalTo(div1.mas_bottom).with.offset(2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    
    _brandField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _brandField.delegate = self;
    _brandField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _brandField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"品牌"
                                                                              attributes:@{NSForegroundColorAttributeName: fontColor}];
    _brandField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _brandField.floatingLabelTextColor = floatingLabelColor;
    [_brandField setText:_brand.name];
    [_contentView addSubview:_brandField];
    [_brandField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productNameField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view.mas_centerX).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _brandField.keepBaseline = YES;
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_brandField.mas_bottom);
        make.left.equalTo(_brandField.mas_left);
        make.right.equalTo(_brandField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _categoryField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _categoryField.delegate = self;
    _categoryField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _categoryField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"产品分类"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _categoryField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _categoryField.floatingLabelTextColor = floatingLabelColor;
    [_categoryField setText:_prodCategory.name];
    [_contentView addSubview:_categoryField];
    [_categoryField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_brandField.mas_top);
        make.left.equalTo(self.view.mas_centerX).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _categoryField.keepBaseline = YES;
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_categoryField.mas_bottom);
        make.left.equalTo(_categoryField.mas_left);
        make.right.equalTo(_categoryField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _modelField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _modelField.delegate = self;
    _modelField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _modelField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"规格"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _modelField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _modelField.floatingLabelTextColor = floatingLabelColor;
    [_modelField setText:_product.model];
    [_contentView addSubview:_modelField];
    [_modelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_brandField.mas_bottom).with.offset(10);;
        make.left.equalTo(_brandField.mas_left);
        make.right.equalTo(self.view.mas_centerX).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _modelField.keepBaseline = YES;
    
    UIView *div4 = [UIView new];
    div4.backgroundColor = LINECOLOR;
    [_contentView addSubview:div4];
    [div4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modelField.mas_bottom);
        make.left.equalTo(_modelField.mas_left);
        make.right.equalTo(_modelField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _purchaseField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _purchaseField.delegate = self;
    _purchaseField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _purchaseField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"采购参考价"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _purchaseField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _purchaseField.floatingLabelTextColor = floatingLabelColor;
    [_purchaseField setText:[NSString stringWithFormat:@"%.1f", _product.purchaseprice]];
    [_purchaseField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_contentView addSubview:_purchaseField];
    [_purchaseField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modelField.mas_top);
        make.left.equalTo(self.view.mas_centerX).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];
    _purchaseField.keepBaseline = YES;
    UILabel *auLable1 = [[UILabel alloc]init];
    auLable1.font = MONEYSYMFONT;
    auLable1.textColor = fontColor;
    auLable1.textAlignment = NSTextAlignmentLeft;
    [auLable1 setText:@"$"];
    [_contentView addSubview:auLable1];
    [auLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_purchaseField.mas_bottom).with.offset(-5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.left.equalTo(_purchaseField.mas_right);
        make.height.equalTo(@22);
    }];
    
    
    UIView *div5 = [UIView new];
    div5.backgroundColor = LINECOLOR;
    [_contentView addSubview:div5];
    [div5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseField.mas_bottom);
        make.left.equalTo(_purchaseField.mas_left);
        make.right.equalTo(auLable1.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    
    _sellField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _sellField.delegate = self;
    _sellField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _sellField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"出售价格"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _sellField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _sellField.floatingLabelTextColor = floatingLabelColor;
    [_sellField setText:[NSString stringWithFormat:@"%.1f", _product.sellprice]];
    [_sellField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_contentView addSubview:_sellField];
    [_sellField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modelField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view.mas_centerX).with.offset(-15);
        make.height.equalTo(@44);
    }];
    _sellField.keepBaseline = YES;
    
    UILabel *rmbLable1 = [[UILabel alloc]init];
    rmbLable1.font = MONEYSYMFONT;
    rmbLable1.textColor = fontColor;
    rmbLable1.textAlignment = NSTextAlignmentLeft;
    [rmbLable1 setText:@"¥"];
    [_contentView addSubview:rmbLable1];
    [rmbLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_sellField.mas_bottom).with.offset(-5);
        make.right.equalTo(self.view.mas_centerX).with.offset(-5);
        make.left.equalTo(_sellField.mas_right);
        make.height.equalTo(@22);
    }];
    UIView *div6 = [UIView new];
    div6.backgroundColor = LINECOLOR;
    [_contentView addSubview:div6];
    [div6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sellField.mas_bottom);
        make.left.equalTo(_sellField.mas_left);
        make.right.equalTo(rmbLable1.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _agentField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _agentField.delegate = self;
    _agentField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _agentField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"代理价格"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _agentField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _agentField.floatingLabelTextColor = floatingLabelColor;
    [_agentField setText:[NSString stringWithFormat:@"%.1f", _product.agentprice]];
    [_agentField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_contentView addSubview:_agentField];
    [_agentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sellField.mas_top);
        make.left.equalTo(self.view.mas_centerX).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];
    _agentField.keepBaseline = YES;
    
    UILabel *rmbLable2 = [[UILabel alloc]init];
    rmbLable2.font = MONEYSYMFONT;
    rmbLable2.textColor = fontColor;
    rmbLable2.textAlignment = NSTextAlignmentLeft;
    [rmbLable2 setText:@"¥"];
    [_contentView addSubview:rmbLable2];
    [rmbLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_agentField.mas_bottom).with.offset(-5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.left.equalTo(_agentField.mas_right);
        make.height.equalTo(@22);
    }];
    
    UIView *div7 = [UIView new];
    div7.backgroundColor = LINECOLOR;
    [_contentView addSubview:div7];
    [div7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agentField.mas_bottom);
        make.left.equalTo(_agentField.mas_left);
        make.right.equalTo(rmbLable2.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _barCodeField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _barCodeField.delegate = self;
    _barCodeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _barCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"条码"
                                                                              attributes:@{NSForegroundColorAttributeName: fontColor}];
    _barCodeField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _barCodeField.floatingLabelTextColor = floatingLabelColor;
    [_agentField setText:_product.barcode];
    [_contentView addSubview:_barCodeField];
    [_barCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sellField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.width.equalTo(self.view).with.offset(-65);
        make.height.equalTo(@44);
    }];
    _barCodeField.keepBaseline = YES;
    
    UIView *div8 = [UIView new];
    div8.backgroundColor = LINECOLOR;
    [_contentView addSubview:div8];
    [div8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_barCodeField.mas_bottom);
        make.left.equalTo(_barCodeField.mas_left);
        make.right.equalTo(_barCodeField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _barButton = [[UIButton alloc]init];
    UIImage *scanBarImage = [IonIcons imageWithIcon:ion_qr_scanner iconColor:fontColor iconSize:40 imageSize:CGSizeMake(40, 40)];
    [_barButton setImage:scanBarImage forState:UIControlStateNormal];
    [_barButton addTarget:self action:@selector(handleScanBar:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_barButton];
    [_barButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_barCodeField.mas_right).with.offset(10);
        make.bottom.equalTo(_barCodeField.mas_bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.height.equalTo(@40);
    }];
    
    
    _wightField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _wightField.delegate = self;
    _wightField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _wightField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"重量(g)"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _wightField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _wightField.floatingLabelTextColor = floatingLabelColor;
    [_wightField setText:[NSString stringWithFormat:@"%.1f", _product.wight]];
    [_agentField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_contentView addSubview:_wightField];
    [_wightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_barCodeField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view.mas_centerX).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _wightField.keepBaseline = YES;
    
    UIView *div9 = [UIView new];
    div9.backgroundColor = LINECOLOR;
    [_contentView addSubview:div9];
    [div9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wightField.mas_bottom);
        make.left.equalTo(_wightField.mas_left);
        make.right.equalTo(_wightField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _quickidField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _quickidField.delegate = self;
    _quickidField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _quickidField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"检索码"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _quickidField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _quickidField.floatingLabelTextColor = floatingLabelColor;
    [_quickidField setText:_product.quickid];
    [_contentView addSubview:_quickidField];
    [_quickidField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wightField.mas_top);
        make.left.equalTo(self.view.mas_centerX).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _quickidField.keepBaseline = YES;
    

    UIView *div10 = [UIView new];
    div10.backgroundColor = LINECOLOR;
    [_contentView addSubview:div10];
    [div10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_quickidField.mas_bottom);
        make.left.equalTo(_quickidField.mas_left);
        make.right.equalTo(_quickidField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    
    _functionField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _functionField.tag = PRODUCTFINFOTAGBEGIN + 1;
    _functionField.delegate = self;
    _functionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _functionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"功效"
                                                                              attributes:@{NSForegroundColorAttributeName: fontColor}];
    _functionField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _functionField.floatingLabelTextColor = floatingLabelColor;
    [_functionField setText:_product.function];
    _functionField.delegate = self;
    [_contentView addSubview:_functionField];
    [_functionField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wightField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _functionField.keepBaseline = YES;
    
    UIView *div11 = [UIView new];
    div11.backgroundColor = LINECOLOR;
    [_contentView addSubview:div11];
    [div11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_functionField.mas_bottom);
        make.left.equalTo(_functionField.mas_left);
        make.right.equalTo(_functionField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _usageField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _usageField.tag = PRODUCTFINFOTAGBEGIN + 2;
    _usageField.delegate = self;
    _usageField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _usageField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用法说明"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _usageField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _usageField.floatingLabelTextColor = floatingLabelColor;
    [_usageField setText:_product.usage];
    [_contentView addSubview:_usageField];
    [_usageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_functionField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _usageField.keepBaseline = YES;
    
    UIView *div12 = [UIView new];
    div12.backgroundColor = LINECOLOR;
    [_contentView addSubview:div12];
    [div12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usageField.mas_bottom);
        make.left.equalTo(_usageField.mas_left);
        make.right.equalTo(_usageField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _storageField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _storageField.tag = PRODUCTFINFOTAGBEGIN + 3;
    _storageField.delegate = self;
    _storageField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _storageField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"存储说明"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _storageField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _storageField.floatingLabelTextColor = floatingLabelColor;
    [_storageField setText:_product.storage];
    [_contentView addSubview:_storageField];
    [_storageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usageField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _storageField.keepBaseline = YES;
    
    UIView *div13 = [UIView new];
    div13.backgroundColor = LINECOLOR;
    [_contentView addSubview:div13];
    [div13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storageField.mas_bottom);
        make.left.equalTo(_storageField.mas_left);
        make.right.equalTo(_storageField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    _cautionField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _cautionField.delegate = self;
    _cautionField.tag = PRODUCTFINFOTAGBEGIN + 4;
    _cautionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _cautionField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"注意事项"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _cautionField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _cautionField.floatingLabelTextColor = floatingLabelColor;
    [_cautionField setText:_product.caution];
    [_contentView addSubview:_cautionField];
    [_cautionField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storageField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _cautionField.keepBaseline = YES;
    
    UIView *div14 = [UIView new];
    div14.backgroundColor = LINECOLOR;
    [_contentView addSubview:div14];
    [div14 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cautionField.mas_bottom);
        make.left.equalTo(_cautionField.mas_left);
        make.right.equalTo(_cautionField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _noteField = [[JVFloatLabeledTextField alloc] initHasAccessory];
    _noteField.tag = PRODUCTFINFOTAGBEGIN + 5;
    _noteField.delegate = self;
    _noteField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _noteField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备注"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _noteField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _noteField.floatingLabelTextColor = floatingLabelColor;
    [_noteField setText:_product.note];
    [_contentView addSubview:_noteField];
    [_noteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cautionField.mas_bottom).with.offset(10);
        make.left.equalTo(_productNameField.mas_left);
        make.right.equalTo(self.view).with.offset(-5);
        make.height.equalTo(@44);
    }];
    _noteField.keepBaseline = YES;
    
    UIView *div15 = [UIView new];
    div15.backgroundColor = LINECOLOR;
    [_contentView addSubview:div15];
    [div15 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteField.mas_bottom);
        make.left.equalTo(_noteField.mas_left);
        make.right.equalTo(_noteField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];

//
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(div15.mas_bottom).with.offset(15);
    }];
        // Do any additional setup after loading the view.
}

- (void)handlerMissProductCheck {
    UIImage *checkedImage = [IonIcons imageWithIcon:ion_android_checkbox_outline iconColor:THEMECOLOR iconSize:22 imageSize:CGSizeMake(22, 22)];
    UIImage *uncheckedImage =[IonIcons imageWithIcon:ion_android_checkbox_outline_blank iconColor:FONTCOLOR iconSize:22 imageSize:CGSizeMake(22, 22)];
    if (_missProductStatus) {
        [_missProduct setImage:checkedImage forState:UIControlStateNormal];
        _missProductStatus = false;
    } else {
        [_missProduct setImage:uncheckedImage forState:UIControlStateNormal];
        _missProductStatus = true;
    }
}

- (void)setProduct:(Product *)product {
    _product = product;
    ProductCategoryManagement *prodCategoryManagement = [ProductCategoryManagement shareInstance];
    _prodCategory = [prodCategoryManagement getCategoryById:product.categoryid];
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    _brand = [brandManagement getBrandById:product.brandid];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _functionField || textField == _usageField || textField == _storageField || textField == _cautionField || textField == _noteField) {
        UIProductInfoEditViewController *infoEditViewController  = nil;
        JVFloatLabeledTextField *passedField;
        NSString *textContent = nil;
        if (textField == _functionField) {
            textContent = _functionField.text;
            passedField = _functionField;
        } else if (textField == _usageField){
            textContent = _usageField.text;
            passedField = _usageField;
        } else if (textField == _storageField){
            textContent = _storageField.text;
            passedField = _storageField;
        } else if (textField == _cautionField){
            textContent = _cautionField.text;
            passedField = _cautionField;
        } else if (textField == _noteField) {
            textContent = _noteField.text;
            passedField = _noteField;
        }
        infoEditViewController = [[UIProductInfoEditViewController alloc] initWithContent:textContent withTextFieldTag:passedField.tag];
        infoEditViewController.delegate = self;
        [self.navigationController pushViewController:infoEditViewController animated:YES];
        return NO;
    } else if (textField == _brandField || textField == _categoryField) {
        UIView *contenctView = nil;
        if (textField == _brandField) {
            MBrandTableView *brandTableView = [[MBrandTableView alloc]init];
            brandTableView.delegate = self;
            contenctView = brandTableView;
        } else if (textField == _categoryField) {
            MCategoryTableView *categoryTableView = [[MCategoryTableView alloc]init];
            categoryTableView.delegate = self;
            contenctView = categoryTableView;
        }
        _containerViewController = [[UISelectContainerViewController alloc]initWithSubView:contenctView];
        [self.navigationController pushViewController:_containerViewController animated:NO];
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



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *view in _contentView.subviews) {
        if (view.isFirstResponder) {
            [view resignFirstResponder];
        }
    }
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
    [_barCodeField setText:string];
    NSLog(@"%@",string);
}

#pragma mark --UIProductInfo
- (void)didFinishEditing:(NSString *)content  withTag:(NSInteger)tag{
    switch (tag-PRODUCTFINFOTAGBEGIN) {
        case 1:
            _functionField.text = content;
            break;
        case 2:
            _usageField.text = content;
            break;
        case 3:
            _storageField.text = content;
            break;
        case 4:
            _cautionField.text = content;
            break;
        case 5:
            _noteField.text = content;
            break;
    }
}


#pragma mark -- Product Saving handlre 
- (void)saveProduct {
    Product *product = _product;
    product.name = _productNameField.text;
    product.brandid = _brand.bid;
    product.categoryid = _prodCategory.cateid;
    product.model = _modelField.text;
    product.purchaseprice = [_purchaseField.text floatValue];
    product.sellprice = [_sellField.text floatValue];
    product.agentprice = [_agentField.text floatValue];
    product.barcode = _brandField.text;
    product.wight = [_wightField.text floatValue];
    product.quickid = _quickidField.text;
    product.function = _functionField.text;
    product.usage = _usageField.text;
    product.storage = _storageField.text;
    product.caution= _cautionField.text;
    product.note = _noteField.text;
    ProductManagement *productManagement = [ProductManagement shareInstance];
    [productManagement updateProduct:product];
}

- (void)finishProduct {
    if ([_productNameField.text isEqualToString:@""] ||[_brandField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"商品详情" message:@"请填写商品名称和商品品牌"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"好的", nil];
        alertView.tag = PRODUCTFINFOTAGBEGIN + 101;
        [alertView show];
    } else {
        [self saveProduct];
        [self.navigationController popViewControllerAnimated:YES];
    }
 
}

- (void)backFromDetail {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"商品详情" message:@"完成编辑"
                                                        delegate:self
                                               cancelButtonTitle:@"继续编辑"
                                               otherButtonTitles:@"放弃更改", nil];
    alertView.tag = PRODUCTFINFOTAGBEGIN + 100;
    [alertView show];
}
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag - PRODUCTFINFOTAGBEGIN)  == 100) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -- Category Delegate
- (void)categoryDidSelected:(ProductCategory *)category {
    _prodCategory = category;
    _categoryField.text = category.name;
    [_containerViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Brand Delegate 
- (void)brandDidSelected:(Brand *)brand {
    _brand = brand;
    _brandField.text = brand.name;
    [_containerViewController.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
