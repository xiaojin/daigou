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

@interface OrderMainInfoViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *detailArray;
@property(nonatomic, strong)NSArray *products;
@property(nonatomic, strong)NSDictionary *productGroup;
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
    
    [self fetchOrderProducts];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveOrderInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"填写订单";
    [self addTableVIew];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initValueForCell];
    [self.editTableView reloadData];
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

- (void)saveOrderInfo {


}

- (void)fetchOrderProducts {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    if (self.orderItem.oid == 0) {
        self.products = [NSArray array];
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
    OrderItemBenifitCell *orderCell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    for (UIView *view in orderCell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    if (orderCell == nil) {
        orderCell = [[OrderItemBenifitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        orderCell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
    }
    orderCell.customInfo = self.customInfo;
    orderCell.orderItem = self.orderItem;
    orderCell.productDesc = [self setProdcutDesc];
    orderCell.EditPriceActionBlock = ^(NSInteger number, CGRect frame) {
        if (number == 11) {
            [self handCustomCellTap];
        } else if (number == 12) {
            [self handleProductCellTap];
        } else {
            [self beginEditNumber:indexPath withFrame:frame];
        }
    };

    return  orderCell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 460.0f;
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
    [self.navigationController pushViewController:customInfo animated:YES];
}

- (void)handleProductCellTap {
    [(OrderDetailViewController *)self.parentViewController scrollToStaus:1];
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

@end
