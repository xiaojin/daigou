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
#define ORDERTAGBASE 6000
@interface OAddNewOrderViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate>
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *detailArray;
@property(nonatomic, strong)NSArray *products;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initValueForCell];
    [self.editTableView reloadData];
}


- (void)loadView
{
    [super loadView];
    if (self.customInfo == nil) {
        self.customInfo = [[CustomInfo alloc]init];
    }
    if (self.orderItem == nil) {
        self.orderItem = [[OrderItem alloc]init];
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
    NSArray *firstSection = @[@"客户姓名",@"客户地址",@"货品清单"];
    NSArray *detailFirstSection = nil;
    NSArray *detailSecSection  = nil;
    if (self.orderItem.oid != 0) {
        detailFirstSection = @[self.customInfo.name,self.customInfo.address,@(self.products.count)];
        detailSecSection = @[@0,@0,@0,@""];
    } else {
        detailFirstSection = @[@"",@"",@0];
        detailSecSection = @[@0,@0,@0,@""];
    }
    NSArray *secSection = @[@"小记",@"优惠",@"总价",@"注释"];
    self.titleArray = @[firstSection, secSection];
    self.detailArray = @[detailFirstSection, detailSecSection];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemView *cell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (cell == nil) {
        cell = [[OrderItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        cell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
        if (indexPath.section == 0) {
            cell.orderCellDelegate = self;
        }
    }
    
    [cell updateCellWithTitle:self.titleArray[indexPath.section][indexPath.row] detailInformation:[NSString stringWithFormat:@"%@",self.detailArray[indexPath.section][indexPath.row]]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.titleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (void)clickEditingField:(OrderItemView *)orderItemView {
    NSInteger index = orderItemView.tag - ORDERTAGBASE;
    if (index/4 == 0) {
        if ((4-index) == 4) {
            MCustInfoViewController *customInfo = [[MCustInfoViewController alloc]init];
            [self.navigationController pushViewController:customInfo animated:YES];
        } else if ((4-index) ==2) {
            OrderBasketViewController *orderBasket = [[OrderBasketViewController alloc]initwithOrderItem:self.orderItem withProducts:self.products];
           [self.navigationController pushViewController:orderBasket animated:YES];
        }
    } else {
    
    
    }
   
}
@end
