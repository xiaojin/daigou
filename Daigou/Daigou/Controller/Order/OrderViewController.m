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
@property (nonatomic, strong)UIScrollView *orderStatusView;
@end

@implementation OrderViewController
NSString *const orderlistcellIdentity = @"orderlistcellIdentity";

- (void)viewDidLoad {
  [super viewDidLoad];
    [self fetchAllOrders];
    [self fetchAllClients];
    [self addOrderStatusView];
    self.orderListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.orderListTableView];
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    self.orderListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.orderListTableView.bounds.size.width, 0.01f)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self.orderListTableView reloadData];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addOrderStatusView {
    UIView *contentView = [[UIView alloc]init];
    UIView *underLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 33, self.view.frame.size.width, 1)];
    underLineView.backgroundColor = [UIColor grayColor];

    CGFloat topOff = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _orderStatusView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(topOff);
        make.right.equalTo(self.view);
        make.height.equalTo(@34);
        
    }];
    [contentView addSubview:underLineView];
    [contentView addSubview:_orderStatusView];

    
    UILabel *purchaseStatusLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 34)];
    [purchaseStatusLbl setText:@"采购中"];
    [purchaseStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
    purchaseStatusLbl.textColor = RGB(100, 100, 100);
    [purchaseStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [purchaseStatusLbl setBackgroundColor:[UIColor blackColor]];

    [_orderStatusView addSubview:purchaseStatusLbl];
    [_orderStatusView setContentSize:CGSizeMake(self.view.frame.size.width, 34)];

//
//    UILabel *unpestachedStatusLbl = [[UILabel alloc]init];
//    [unpestachedStatusLbl setText:@"待发货"];
//    [unpestachedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
//    unpestachedStatusLbl.textColor = RGB(255, 255, 255);
//    [unpestachedStatusLbl setTextAlignment:NSTextAlignmentCenter];
//    [_orderStatusView addSubview:unpestachedStatusLbl];
//    [unpestachedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(purchaseStatusLbl);
//        make.top.equalTo(_orderStatusView);
//        make.bottom.equalTo(_orderStatusView);
//        make.width.equalTo(@30);
//    }];
//
//    UILabel *transportedStatusLbl = [[UILabel alloc]init];
//    [transportedStatusLbl setText:@"运输中"];
//    [transportedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
//    transportedStatusLbl.textColor = RGB(255, 255, 255);
//    [transportedStatusLbl setTextAlignment:NSTextAlignmentCenter];
//    [_orderStatusView addSubview:transportedStatusLbl];
//    [transportedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(unpestachedStatusLbl);
//        make.top.equalTo(_orderStatusView);
//        make.bottom.equalTo(_orderStatusView);
//        make.width.equalTo(@30);
//    }];
//    
//    UILabel *receivedStatusLbl = [[UILabel alloc]init];
//    [receivedStatusLbl setText:@"已收货"];
//    [receivedStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
//    receivedStatusLbl.textColor = RGB(255, 255, 255);
//    [receivedStatusLbl setTextAlignment:NSTextAlignmentCenter];
//    [_orderStatusView addSubview:receivedStatusLbl];
//    [receivedStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(transportedStatusLbl);
//        make.top.equalTo(_orderStatusView);
//        make.bottom.equalTo(_orderStatusView);
//        make.width.equalTo(@30);
//    }];
//    
//    UILabel *finishStatusLbl = [[UILabel alloc]init];
//    [finishStatusLbl setText:@"已完成"];
//    [finishStatusLbl setFont:[UIFont systemFontOfSize:12.0f]];
//    finishStatusLbl.textColor = RGB(255, 255, 255);
//    [finishStatusLbl setTextAlignment:NSTextAlignmentCenter];
//    [_orderStatusView addSubview:finishStatusLbl];
//    [finishStatusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(receivedStatusLbl);
//        make.top.equalTo(_orderStatusView);
//        make.bottom.equalTo(_orderStatusView);
//        make.width.equalTo(@30);
//    }];
//    
//    _orderStatusView.contentSize = CGSizeMake(CGRectGetMaxX(finishStatusLbl.frame), 44.0f);

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
