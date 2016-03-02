//
//  OAddNewOrderViewController.m
//  Daigou
//
//  Created by jin on 14/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderMainInfoViewController.h"
#import "OrderItemView.h"
#import "MCustInfoViewController.h"
#import "OrderBasketViewController.h"
#import "OrderItem.h"
#import "CustomInfo.h"
#import "OrderItemManagement.h"
#import "OProductItem.h"
#import "UIPickerViewCell.h"
#import "CommonDefines.h"
#import "OrderDetailViewController.h"
#import "OrderItemBenifitCell.h"
#import "OProductItem.h"

#define ORDERTAGBASE 6000
#define kStatusPickerCellHeight 164

@interface OrderMainInfoViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate,FullScreenDisplayDelegate,MCustInfoViewControllerDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *detailArray;
@property(nonatomic, strong)NSArray *products;
@property(nonatomic, strong)NSDictionary *productGroup;
@property(nonatomic, strong)NSDictionary *benefitDict;
@property(nonatomic, strong)OrderItemBenifitCell *orderCell;
@end


@implementation OrderMainInfoViewController
NSString *const oAddNewOrderCellIdentify = @"oAddNewOrderCellIdentify";
- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client
{
    if (self = [super init]) {
        self.customInfo = client;
        self.orderItem = orderItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.customInfo == nil) {
        self.customInfo = [[CustomInfo alloc]init];
    }
    if (self.orderItem == nil) {
        self.orderItem = [[OrderItem alloc]init];
        self.orderItem.creatDate = [[NSDate date] timeIntervalSince1970];
    }
    [self addTableVIew];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshMainInfo];
}

- (void)refreshMainInfo {
    [self fetchOrderProducts];
    [self initValueForCell];
    [self.editTableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



- (void)addTableVIew {
    self.editTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.editTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.editTableView.delegate = self;
    self.editTableView.dataSource = self;
    self.editTableView.allowsSelection = NO;
    
    [self.view addSubview:self.editTableView];
    self.editTableView.contentInset = UIEdgeInsetsMake(0, 0, 140.0f, 0);
}


- (void)fetchOrderProducts {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    if (self.orderItem.oid == 0) {
        self.products = [NSArray array];
        self.products = [itemManagement getOrderProductsByOrderId:self.orderItem.oid];
    } else {
        self.products = [itemManagement getOrderProductsByOrderId:self.orderItem.oid];
    }
}


- (NSString *)setProdcutDesc {
    if ([self.products count] == 0) {
        return nil;
    } else {
        NSString *epxression = [NSString stringWithFormat:@"一共有%lu个商品",(unsigned long)[self.products count]];
        return epxression;
    }
}
// TODO 小记，总计，youhui
- (void) initValueForCell{
    __block float totalValue = 0.0;
    float discountValue = _orderItem.discount;
    float finalValue = 0.0;
    __block float purchaseValue= 0.0f;
    float otherValue=_orderItem.othercost;
    float benefitValue= 0.0f;
    if (_orderCell!=nil) {
        discountValue = [_orderCell discountValue];
        otherValue = [_orderCell otherValue];
    }
    
    for (OProductItem *prodItem in self.products) {
        totalValue = totalValue + prodItem.sellprice;
        purchaseValue = purchaseValue + prodItem.price;
    }
    finalValue = totalValue - discountValue;
    benefitValue = finalValue - purchaseValue * EXCHANGERATE - otherValue*EXCHANGERATE;
    NSDictionary *benefitDict = @{@"totalvalue":@(totalValue),@"discountvalue":@(discountValue),@"finalvalue":@(finalValue),@"purchasevalue":@(purchaseValue),@"othervalue":@(otherValue),@"benefitvalue":@(benefitValue)};
    _benefitDict = benefitDict;
    //finalValue = orderitem.totalvalue, totalvalue = orderitem.subtotal
}

#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self editTableView] contentInset];
        edgeInsets.bottom = 140.0f;
        [[self editTableView] setContentInset:edgeInsets];
        edgeInsets = [[self editTableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self editTableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey ] CGRectValue].size;
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + 100.0f);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self setOrderTextInputView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (OrderItemBenifitCell *) setOrderTextInputView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _orderCell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    for (UIView *view in _orderCell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    if (_orderCell == nil) {
        _orderCell = [[OrderItemBenifitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        _orderCell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
    }
    _orderCell.customInfo = self.customInfo;
    _orderCell.orderItem = self.orderItem;
    _orderCell.productDesc = [self setProdcutDesc];
    _orderCell.benefitData = _benefitDict;
    _orderCell.fullScreenDisplayDelegate = self;
    __weak typeof(self) weakSelf = self;
    _orderCell.EditPriceActionBlock = ^(NSInteger number, CGRect frame) {
        if (number == 11) {
            [weakSelf handCustomCellTap];
        } else if (number == 12) {
            [weakSelf handleProductCellTap];
        } else {
            [weakSelf beginEditNumber:indexPath withFrame:frame];
        }
    };

    return  _orderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 560.0f;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - handlerCellTap
- (void)clickEditingField:(OrderItemView *)orderItemView {
    NSInteger index = orderItemView.tag - ORDERTAGBASE;
    if (index/3 == 0) {
        if ((3-index) == 3) {
            [self handCustomCellTap];
        } else if ((3-index) ==2) {
            [self handleProductCellTap];
        }
    } else {
        
    }
   
}

- (void)handCustomCellTap {
    MCustInfoViewController *customInfo = [[MCustInfoViewController alloc]init];
    customInfo.customDelegate = self;
    [self.navigationController pushViewController:customInfo animated:YES];
}

- (void)handleProductCellTap {
    [(OrderDetailViewController *)self.parentViewController scrollToStaus:1];
}
#pragma mark - MCustomInfoViewControllerDelegate
- (void)didSelectCustomInfo:(CustomInfo *)customInfo {
    _customInfo = customInfo;
}

#pragma mark - OrderPriceDelegate

- (void)beginEditNumber:(NSIndexPath *)cellIndex  withFrame:(CGRect)frame{
    CGFloat kbHeight = keyboardSize.height;
    if (keyboardSize.height == 0) {
        kbHeight = 402.f;
    }
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = [[self editTableView] contentInset];
        edgeInsets.bottom = kbHeight;
        [[self editTableView] setContentInset:edgeInsets];
        edgeInsets = [[self editTableView] scrollIndicatorInsets];
        edgeInsets.bottom = kbHeight;
        [[self editTableView] setScrollIndicatorInsets:edgeInsets];
        [self.editTableView scrollRectToVisible:frame animated:YES];
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - FullScreenDelegate

- (void)showControllerFullScreen:(UIViewController *)viewController{
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark -SaveMainInfo

- (void)saveMainInfo {
    [_orderCell  saveMainInfo];
    _orderItem.subtotal = _orderCell.orderItem.subtotal;
    _orderItem.discount = _orderCell.orderItem.discount;
    _orderItem.totoal = _orderCell.orderItem.totoal;
    _orderItem.othercost =_orderCell.orderItem.othercost;
    _orderItem.profit = _orderCell.orderItem.profit;
    _orderItem.note = _orderCell.orderItem.note;
}

@end
