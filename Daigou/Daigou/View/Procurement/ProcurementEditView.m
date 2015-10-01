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
#import "OrderItemManagement.h"
#import "OProductItem.h"

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
@property (nonatomic, strong) NSArray *UnorderProducts;
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
        [_productTitle setText:@"我们试试"];
        [_productTitle setNumberOfLines:2];
        [view addSubview:_productTitle];
        [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(10);
            make.left.equalTo(view).with.offset(20);
            make.right.equalTo(view).with.offset(-20);
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
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.bottom.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
        
        
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(finishPurchase)];
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


- (void)finishPurchase {
    [self selectExistingNeedtoBuyStockProducts];
    [self updateOrderProduct];
    [_delegate purchaseDidFinish];
    [self hideWithBlock:nil];
}

- (void)actionHide {
    [self resignFirstResponder];
    [self hide];
}

- (void)updateOrderProduct {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    NSArray *orderItems = [itemManagement getAllProductsItemsNeedtoPurchase:_productItem.productid];
    NSInteger updateCount =[_qualityField.text intValue];
    float productPrice = [_priceField.text floatValue];
    NSInteger needUpdateCount = updateCount > [orderItems count] ? [orderItems count] : updateCount;
    NSInteger insertStockProductCount = updateCount > [orderItems count] ? (updateCount -[orderItems count]) : 0;
    for (int i = 0; i < needUpdateCount; i++) {
        OProductItem *productItem =[OProductItem new];
        productItem = orderItems[i];
        productItem.price = productPrice;
        productItem.statu = PRODUCT_INSTOCK;
        [itemManagement updateProductItemWithProductItem:@[productItem] withNull:YES]; //其中只有订单的需求量
    }
    //same productid ,orderid is null, statu = 0
    
    if (insertStockProductCount > 0) {
        [self updateUnOrderProducts:insertStockProductCount withProduct:orderItems[0]];
    }


}

- (void)updateUnOrderProducts:(NSInteger)insertCount withProduct:(OProductItem*)item {
    //然后满足囤货需求的数量
    BOOL hasWantPurchaseList = false;
    NSDictionary *stockProduct = nil;
    for (NSDictionary *dict in _UnorderProducts) {
        OProductItem *productItem = [dict objectForKey:@"oproductitem"];
        if (productItem.productid == item.productid) {
            hasWantPurchaseList = true;
            stockProduct = dict;
            break;
        }
    }
    if (hasWantPurchaseList) {
        OProductItem *productItem = [stockProduct objectForKey:@"oproductitem"];
        NSInteger count = [[stockProduct objectForKey:@"count"] integerValue];
        NSInteger countUpdate = count > insertCount? insertCount : count;
        NSInteger needToCreate = count > insertCount? 0 : (insertCount-count);
        [self updateList:countUpdate withProduct:productItem];
        if (needToCreate >0) {
            [self insertList:needToCreate withProduct:item];
        }
    } else {
        [self insertList:insertCount withProduct:item];
    }
}

- (void)updateList:(NSInteger)updateCount withProduct:(OProductItem*)item{
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    float productPrice = [_priceField.text floatValue];
    NSArray *itemList = [itemManagement getUnOrderProducItemByStatus:PRODUCT_PURCHASE];
    if ([itemList count] >= updateCount) {
        for (int i = 0; i< updateCount; i++) {
            OProductItem *productItem = itemList[i];
            productItem.statu = PRODUCT_INSTOCK;
            productItem.price = productPrice;
            [itemManagement updateProductItemWithProductItem:@[productItem] withNull:YES];
        }
    }

}

- (void)insertList:(NSInteger)insertCount withProduct:(OProductItem*)item{
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    NSMutableArray *insertStockProductArray = [NSMutableArray array];
    float productPrice = [_priceField.text floatValue];
    for (int i = 0; i< insertCount; i++) {
        OProductItem *productItem =[OProductItem new];
        productItem.productid = [(OProductItem*)item productid];
        productItem.refprice = [(OProductItem*)item refprice];
        productItem.price = productPrice;
        productItem.sellprice = [(OProductItem*)item sellprice];
        productItem.amount = 1.0f;
        productItem.statu = PRODUCT_INSTOCK;
        [insertStockProductArray addObject:productItem];
    }
        [itemManagement insertOrderProductItems:insertStockProductArray withNull:YES];
}

//获取囤货清单列表
- (void)selectExistingNeedtoBuyStockProducts{
   _UnorderProducts = [[OrderItemManagement shareInstance] getprocurementProductItemsGroupByStatus:UnOrderProduct];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger myCount = [_qualityField.text intValue];
    float myPrice = [_priceField.text floatValue];
    _totalPriceField.text = [NSString stringWithFormat:@"%.2f",(myPrice * myCount)];
}

@end
