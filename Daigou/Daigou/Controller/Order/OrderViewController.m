//
//  SecondViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//  订单item 向右划 可以显示两个控件，一个删除，一个复制

#import "OrderViewController.h"
#import "OAddNewOrderViewController.h"
#import "OrderListCell.h"
#import "OrderItem.h"
#import "OrderItemManagement.h"
#import "OAddNewOrderViewController.h"
#import "CustomInfoManagement.h"
#import "CustomInfo.h"
@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *orderListTableView;
@property (nonatomic, strong)NSArray *orderItems;
@property (nonatomic, strong)NSArray *custominfos;
@end

@implementation OrderViewController
NSString *const orderlistcellIdentity = @"orderlistcellIdentity";

- (void)viewDidLoad {
  [super viewDidLoad];
    [self fetchAllOrders];
    [self fetchAllClients];
    self.orderListTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    self.orderListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.orderListTableView.bounds.size.width, 0.01f)];
    [self.view addSubview:self.orderListTableView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self.orderListTableView reloadData];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)addNewOrder {
    OAddNewOrderViewController *addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                                             init];
    [self.navigationController pushViewController:addNewOrderViewController animated:YES];

}


- (void)fetchAllOrders {
    self.orderItems = [NSArray array];
    self.orderItems = [[OrderItemManagement shareInstance] getOrderItems];
}

- (void)fetchAllClients {
    CustomInfoManagement *customManagement = [CustomInfoManagement shareInstance];
    self.custominfos = [customManagement getCustomInfo];
}

- (CustomInfo *)getCustomInfobyId:(NSInteger)clientID {
    __block CustomInfo *customInfo = nil;
    [self.custominfos enumerateObjectsUsingBlock:^(CustomInfo *obj, NSUInteger idx, BOOL *stop) {
        if (obj.cid == clientID) {
            customInfo = obj;
            return;
        }
    }];
    return customInfo;
}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:orderlistcellIdentity];
    if (cell == nil) {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderlistcellIdentity];
    }
    OrderItem *item = [self.orderItems objectAtIndex:indexPath.row];
    cell.orderItem = item;
    cell.custom = [self getCustomInfobyId:item.clientid];
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItem *orderItem = (OrderItem *)[self.orderItems objectAtIndex:indexPath.row];
    OAddNewOrderViewController *editOrderViewContorller = [[OAddNewOrderViewController alloc]initWithOrderItem:orderItem withClientDetail:[self getCustomInfobyId:orderItem.clientid]];
    [self.navigationController pushViewController:editOrderViewContorller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
