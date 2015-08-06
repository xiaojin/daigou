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
#define SCROLL_VIEW_HEIGHT 34
#define LBL_DISTANCE 90
@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *orderListTableView;
@property (nonatomic, strong) NSArray *orderItems;
@property (nonatomic, strong) NSArray *custominfos;
@property (nonatomic, strong) UIScrollView *orderStatusView;
@property (nonatomic, strong) UILabel *purchaseStatusLbl;
@property (nonatomic, strong) UILabel *unpestachedStatusLbl;
@property (nonatomic, strong) UILabel *transportedStatusLbl;
@property (nonatomic, strong) UILabel *receivedStatusLbl;
@property (nonatomic, strong) UILabel *finishStatusLbl;

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
    UIView *underLineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCROLL_VIEW_HEIGHT-1, self.view.frame.size.width, 1)];
    underLineView.backgroundColor = [UIColor lightGrayColor];

    CGFloat topOff = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _orderStatusView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCROLL_VIEW_HEIGHT)];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(topOff);
        make.right.equalTo(self.view);
        make.height.equalTo(@SCROLL_VIEW_HEIGHT);
        
    }];
    [contentView addSubview:underLineView];
    [contentView addSubview:_orderStatusView];
    
    
    _purchaseStatusLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_purchaseStatusLbl setText:@"采购中"];
    [_purchaseStatusLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _purchaseStatusLbl.textColor = RGB(0, 0, 0);
    [_purchaseStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [_purchaseStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPurchageLbl)];
    tapgesture.numberOfTapsRequired = 1;
    [_purchaseStatusLbl addGestureRecognizer:tapgesture];
    [_orderStatusView addSubview:_purchaseStatusLbl];

//
    _unpestachedStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_purchaseStatusLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_unpestachedStatusLbl setText:@"待发货"];
    [_unpestachedStatusLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _unpestachedStatusLbl.textColor = RGB(0, 0, 0);
    [_unpestachedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [_orderStatusView addSubview:_unpestachedStatusLbl];
    [_unpestachedStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *unpestachedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectUnpestachedStatusLbl)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [_unpestachedStatusLbl addGestureRecognizer:unpestachedTapgesture];
    [_orderStatusView addSubview:_purchaseStatusLbl];
 
//
    _transportedStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_unpestachedStatusLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_transportedStatusLbl setText:@"运输中"];
    [_transportedStatusLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _transportedStatusLbl.textColor = RGB(0, 0, 0);
    [_transportedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [_transportedStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *transportTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTransportedStatusLbl)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [_transportedStatusLbl addGestureRecognizer:transportTapgesture];
    [_orderStatusView addSubview:_transportedStatusLbl];

//
    _receivedStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_transportedStatusLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_receivedStatusLbl setText:@"已收货"];
    [_receivedStatusLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _receivedStatusLbl.textColor = RGB(0, 0, 0);
    [_receivedStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [_receivedStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *receivedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectReceivedStatusLbl)];
    receivedTapgesture.numberOfTapsRequired = 1;
    [_receivedStatusLbl addGestureRecognizer:receivedTapgesture];
    [_orderStatusView addSubview:_receivedStatusLbl];

//
    _finishStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_receivedStatusLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_finishStatusLbl setText:@"已完成"];
    [_finishStatusLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _finishStatusLbl.textColor = RGB(0, 0, 0);
    [_finishStatusLbl setTextAlignment:NSTextAlignmentCenter];
    [_finishStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *finishedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectFinishStatusLbl)];
    finishedTapgesture.numberOfTapsRequired = 1;
    [_finishStatusLbl addGestureRecognizer:finishedTapgesture];
    [_orderStatusView addSubview:_finishStatusLbl];
//
    _orderStatusView.contentSize = CGSizeMake(CGRectGetMaxX(_finishStatusLbl.frame), SCROLL_VIEW_HEIGHT-1);
    [_orderStatusView setShowsHorizontalScrollIndicator:NO];

}

- (void)selectPurchageLbl {
    [self updateLblstatus:_purchaseStatusLbl];
}

- (void)selectUnpestachedStatusLbl {
    [self updateLblstatus:_unpestachedStatusLbl];
}

- (void)selectTransportedStatusLbl {
    [self updateLblstatus:_transportedStatusLbl];
}

- (void)selectReceivedStatusLbl {
    [self updateLblstatus:_receivedStatusLbl];
}

- (void)selectFinishStatusLbl {
    [self updateLblstatus:_finishStatusLbl];
}

- (void)updateLblstatus:(UILabel *)selectedLbl {
    NSArray *statusLbl = @[_purchaseStatusLbl, _unpestachedStatusLbl, _transportedStatusLbl, _receivedStatusLbl,_finishStatusLbl];
    [statusLbl enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        if ([obj isEqual:selectedLbl]) {
            obj.textColor = RGB(241, 109, 52);
            obj.font = [UIFont systemFontOfSize:16.0f];
        } else {
            obj.textColor = RGB(0,0,0);
            obj.font = [UIFont systemFontOfSize:14.0f];
        }
        [UIView commitAnimations];
    }];

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
