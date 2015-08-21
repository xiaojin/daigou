//
//  OAddNewOrderViewController.m
//  Daigou
//
//  Created by jin on 14/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OAddNewOrderViewController.h"
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

#define ORDERTAGBASE 6000
#define kStatusPickerCellHeight 164

@interface OAddNewOrderViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *detailArray;
@property(nonatomic, strong)NSArray *products;
@property(nonatomic, strong)UIPickerViewCell *pickViewCell;
@property(nonatomic, strong)NSArray *statusStringArray;
@property(assign) BOOL statusPickerIsShowing;
@end


@implementation OAddNewOrderViewController
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
    [self hideStatusPickerCell];
}

- (void)loadView
{
    [super loadView];
    self.statusStringArray = @[@"采购中",@"待发货",@"运输中",@"已收获",@"已完成"];
    
    
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
}


- (void)addTableVIew {
    self.editTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.editTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.editTableView.delegate = self;
    self.editTableView.dataSource = self;
    self.editTableView.allowsSelection = NO;
    
    [self.view addSubview:self.editTableView];
   // self.editTableView.contentInset = UIEdgeInsetsMake(0, 0, 140.0f, 0);
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
// TODO 小记，总计，youhui
- (void) initValueForCell{
    NSArray *firstSection = @[@"客户姓名",@"货品清单",@"订单状态",@"状态选择"];
    NSArray *detailFirstSection = nil;
    NSArray *detailSecSection  = nil;
    if (self.orderItem.oid != 0) {
        NSString *productList = [NSString stringWithFormat:@"一共有 %lu 件商品",(unsigned long)self.products.count];
        detailFirstSection = @[self.customInfo.name,productList,self.statusStringArray[self.orderItem.statu/10],@""];
        detailSecSection = @[@0];
    } else {
        detailFirstSection = @[@"",@0,@"采购中",@""];
        detailSecSection = @[@0];
    }
    NSArray *secSection = @[@"利润"];
    self.titleArray = @[firstSection, secSection];
    self.detailArray = @[detailFirstSection, detailSecSection];
}

#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self editTableView] contentInset];
        edgeInsets.bottom = 0;
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
    UITableViewCell *cell = nil;

    if(indexPath.section == 0 && indexPath.row == 3) {
        [self setStatusPickView:tableView cellForRowAtIndexPath:indexPath];
        cell = _pickViewCell;
    } else {
        if (indexPath.section == 0) {
            cell = [self setOrderItemView:tableView cellForRowAtIndexPath:indexPath];
        } else {
            cell = [self setOrderTextInputView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    return cell;
}


- (void) setStatusPickView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _pickViewCell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (_pickViewCell == nil) {
        _pickViewCell = [[UIPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
    }
    _pickViewCell.pickView.dataSource = self;
    _pickViewCell.pickView.delegate = self;
    _pickViewCell.pickView.hidden = YES;
    [_pickViewCell.pickView selectRow:(self.orderItem.statu/10) inComponent:0 animated:NO];
}

- (OrderItemView *) setOrderItemView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemView *orderCell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (orderCell == nil) {
        orderCell = [[OrderItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        orderCell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
        orderCell.orderCellDelegate = self;
    }
    [orderCell updateCellWithTitle:self.titleArray[indexPath.section][indexPath.row] detailInformation:[NSString stringWithFormat:@"%@",self.detailArray[indexPath.section][indexPath.row]]];
    return  orderCell;
}

- (OrderItemBenifitCell *) setOrderTextInputView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemBenifitCell *orderCell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (orderCell == nil) {
        orderCell = [[OrderItemBenifitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        orderCell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
    }
    orderCell.EditPriceActionBlock = ^(NSInteger number) {
        [self beginEditNumber:indexPath];
    };

    return  orderCell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.editTableView.rowHeight;
    
    if (indexPath.section == 0 && indexPath.row == 3 ) {
        height = self.statusPickerIsShowing ? kStatusPickerCellHeight : 0.0f;
    } else if(indexPath.section == 1 && indexPath.row == 0) {
        height = 300.0f;
    }
    
    return height;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.titleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

#pragma mark - handlerCellTap
- (void)clickEditingField:(OrderItemView *)orderItemView {
    NSInteger index = orderItemView.tag - ORDERTAGBASE;
    if (index/3 == 0) {
        if ((3-index) == 3) {
            [self handCustomCellTap];
        } else if ((3-index) ==2) {
            [self handleProductCellTap];
        } else if ((3 - index) == 1) {
            [self handleStatusCellTap:orderItemView];
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

- (void)handleStatusCellTap:(OrderItemView *)orderItemView {
    if (self.statusPickerIsShowing) {
        orderItemView.detailInfo.textColor = TITLECOLOR;
        self.orderItem.statu =  (OrderStatus)[self.pickViewCell.pickView selectedRowInComponent:0]*10;
        [self hideStatusPickerCell];
        [self initValueForCell];
        [self.editTableView reloadData];
    } else {
        [self resignFirstResponder];
        orderItemView.detailInfo.textColor = ORIANGECOLOR;
        [self showStatusPickerCell];
    }
}

- (void) showStatusPickerCell {
    self.statusPickerIsShowing = YES;
    [self.editTableView beginUpdates];
    [self.editTableView endUpdates];
    self.pickViewCell.pickView.hidden = NO;
    self.pickViewCell.pickView.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickViewCell.pickView.alpha = 1.0f;
    }];
}

- (void) hideStatusPickerCell {
    self.statusPickerIsShowing = NO;
    [self.editTableView beginUpdates];
    [self.editTableView endUpdates];
    [UIView animateWithDuration:0.25 animations:^{
        self.pickViewCell.pickView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.pickViewCell.pickView.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.statusStringArray.count;
}
#pragma mark - UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.statusStringArray[row];
}

#pragma mark - OrderPriceDelegate

- (void)beginEditNumber:(NSIndexPath *)cellIndex {
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
    //    [self.editTableView scrollRectToVisible:CGRectMake(0, 402, 60, 320) animated:YES];
        [self.editTableView scrollToRowAtIndexPath:cellIndex
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

@end
