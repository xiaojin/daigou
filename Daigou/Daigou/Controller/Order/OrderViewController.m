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
#import <Masonry/Masonry.h>
#import "CommonDefines.h"

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
    [self addOrderStatusView];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addOrderStatusView {
    UIScrollView *orderStatusView = [[UIScrollView alloc]init];
    [orderStatusView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:orderStatusView];
    
    [orderStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    UILabel *purchaseStatusLbl = [[UILabel alloc]init];
    [purchaseStatusLbl setText:@""];
    [purchaseStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    purchaseStatusLbl.textColor = RGB(255, 255, 255);
    [purchaseStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [orderStatusView addSubview:purchaseStatusLbl];
    [purchaseStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderStatusView);
        make.top.equalTo(orderStatusView);
        make.bottom.equalTo(orderStatusView);
        make.width.equalTo(@30);
    }];
    
    UILabel *unpestachedStatusLbl = [[UILabel alloc]init];
    [unpestachedStatusLbl setText:@""];
    [unpestachedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    unpestachedStatusLbl.textColor = RGB(255, 255, 255);
    [unpestachedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [orderStatusView addSubview:unpestachedStatusLbl];
    [unpestachedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(purchaseStatusLbl);
        make.top.equalTo(orderStatusView);
        make.bottom.equalTo(orderStatusView);
        make.width.equalTo(@30);
    }];

    UILabel *transportedStatusLbl = [[UILabel alloc]init];
    [transportedStatusLbl setText:@""];
    [transportedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    transportedStatusLbl.textColor = RGB(255, 255, 255);
    [transportedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [orderStatusView addSubview:transportedStatusLbl];
    [transportedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(unpestachedStatusLbl);
        make.top.equalTo(orderStatusView);
        make.bottom.equalTo(orderStatusView);
        make.width.equalTo(@30);
    }];
    
    UILabel *receivedStatusLbl = [[UILabel alloc]init];
    [receivedStatusLbl setText:@""];
    [receivedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    receivedStatusLbl.textColor = RGB(255, 255, 255);
    [receivedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [orderStatusView addSubview:receivedStatusLbl];
    [receivedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transportedStatusLbl);
        make.top.equalTo(orderStatusView);
        make.bottom.equalTo(orderStatusView);
        make.width.equalTo(@30);
    }];
    
    UILabel *finishStatusLbl = [[UILabel alloc]init];
    [finishStatusLbl setText:@""];
    [finishStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    finishStatusLbl.textColor = RGB(255, 255, 255);
    [finishStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [orderStatusView addSubview:finishStatusLbl];
    [finishStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receivedStatusLbl);
        make.top.equalTo(orderStatusView);
        make.bottom.equalTo(orderStatusView);
        make.width.equalTo(@30);
    }];
    
    orderStatusView.contentSize = CGSizeMake(CGRectGetMaxX(finishStatusLbl.frame), 44.0f);

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
