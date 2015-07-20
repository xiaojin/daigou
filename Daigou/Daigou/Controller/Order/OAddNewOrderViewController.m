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
#define ORDERTAGBASE 6000
@interface OAddNewOrderViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate>
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@property(nonatomic, strong)NSArray *detailArray;
@property(nonatomic, strong)OrderItem *orderItem;
@property(nonatomic, strong)CustomInfo *customInfo;
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

- (void)loadView
{
    [super loadView];
    if (self.customInfo == nil) {
        self.customInfo = [[CustomInfo alloc]init];
    }
    if (self.orderItem == nil) {
        self.orderItem = [[OrderItem alloc]init];
    }
    
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveOrderInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"填写订单";
    [self initValueForCell];
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

}

- (void) initValueForCell{
    NSArray *firstSection = @[@"客户姓名",@"客户地址",@"货品清单"];
//    if (self.orderItem) {
//        <#statements#>
//    }
//    NSArray *detailFirstSection = @[self.customInfo.name,self.customInfo.address]
    NSArray *secSection = @[@"小记",@"优惠",@"总价",@"货品清单"];
    self.titleArray = @[firstSection, secSection];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemView *cell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (cell == nil) {
        cell = [[OrderItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
    }
    [cell updateCellWithTitle:self.titleArray[indexPath.section][indexPath.row] detailInformation:@""];
    cell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
    if (indexPath.section == 0) {
        cell.orderCellDelegate = self;
    }
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

- (void)clickEditingField:(OrderItemView *)orderItem {
    NSInteger index = orderItem.tag - ORDERTAGBASE;
    if (index/4 == 0) {
        if ((4-index) == 4) {
            MCustInfoViewController *customInfo = [[MCustInfoViewController alloc]init];
            [self.navigationController pushViewController:customInfo animated:YES];
        } else if ((4-index) ==2) {
            OrderItem *orderItem = [[OrderItem alloc]init];
            OrderBasketViewController *orderBasket = [[OrderBasketViewController alloc]initwithOrderItem:orderItem];
            [self.navigationController pushViewController:orderBasket animated:YES];
        }
    } else {
    
    
    }
   
}
@end
