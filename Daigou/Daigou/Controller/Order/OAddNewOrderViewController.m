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
#define ORDERTAGBASE 6000
@interface OAddNewOrderViewController()<UITableViewDataSource, UITableViewDelegate,OrderCellDelegate>
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)NSArray *titleArray;
@end


@implementation OAddNewOrderViewController
NSString *const oAddNewOrderCellIdentify = @"oAddNewOrderCellIdentify";
- (void)loadView
{
    [super loadView];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveOrderInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"填写订单";
    [self initValueForCell];
    [self addTableVIew];
    //[self hideTabBar:self.tabBarController];
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

- (void) initValueForCell{
    NSArray *firstSection = @[@"客户姓名",@"客户地址",@"货品清单"];
    NSArray *secSection = @[@"小记",@"优惠",@"总价",@"货品清单"];
    self.titleArray = @[firstSection, secSection];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemView *cell = [tableView dequeueReusableCellWithIdentifier:oAddNewOrderCellIdentify];
    if (cell == nil) {
        cell = [[OrderItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oAddNewOrderCellIdentify];
        [cell updateCellWithTitle:self.titleArray[indexPath.section][indexPath.row] detailInformation:@""];
        cell.tag = ORDERTAGBASE + indexPath.section *4 + indexPath.row;
        if (indexPath.section == 0) {
            cell.orderCellDelegate = self;
        }
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
        
        }
    } else {
    
    
    }
   
}
@end
