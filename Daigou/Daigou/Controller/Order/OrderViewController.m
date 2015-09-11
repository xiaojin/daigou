//
//  SecondViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//  订单item 向右划 可以显示两个控件，一个删除，一个复制

#import "OrderViewController.h"
#import "OrderMainInfoViewController.h"
#import "OrderListCell.h"
#import "OrderItem.h"
#import "OrderItemManagement.h"
#import "OrderMainInfoViewController.h"
#import "CustomInfoManagement.h"
#import "CustomInfo.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "OrderStausListTableView.h"
#import "OrderDetailViewController.h"

#define LBL_DISTANCE 90
#define CELL_HEIGHT 65
@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) OrderStausListTableView *orderListTableView;
@property (nonatomic, strong) OrderStausListTableView *unpestachedTableView;
@property (nonatomic, strong) OrderStausListTableView *transportTableView;
@property (nonatomic, strong) OrderStausListTableView *receivedTableView;
@property (nonatomic, strong) OrderStausListTableView *finishedTableView;
@property (nonatomic, strong) NSArray *custominfos;
@property (nonatomic, strong) UIScrollView *orderStatusView;
@property (nonatomic, strong) UIScrollView *orderMainScrollView;
@property (nonatomic, strong) UILabel *purchaseStatusLbl;
@property (nonatomic, strong) UILabel *unpestachedStatusLbl;
@property (nonatomic, strong) UILabel *transportedStatusLbl;
@property (nonatomic, strong) UILabel *receivedStatusLbl;
@property (nonatomic, strong) UILabel *finishStatusLbl;
@property (nonatomic, strong) OrderItem *orderItem;
@property (nonatomic, strong) NSArray *statusLabels;
@end

@implementation OrderViewController
NSString *const orderlistcellIdentity = @"orderlistcellIdentity";

- (void)viewDidLoad {
  [super viewDidLoad];
  
    [self fetchAllClients];
    [self addOrderStatusView];
    [self initScrollView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self.orderListTableView reloadData];
    [self.unpestachedTableView reloadData];
    [self.transportTableView reloadData];
    [self.receivedTableView reloadData];
    [self.finishedTableView reloadData];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)initScrollView {
    _orderMainScrollView = [[UIScrollView alloc] initWithFrame: CGRectZero];
    _orderMainScrollView.delegate = self;
    [self.view addSubview:_orderMainScrollView];
    [_orderMainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    UIView *container = [UIView new];
    [_orderMainScrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_orderMainScrollView);
        make.height.equalTo(_orderMainScrollView);
    }];
    
    [self initOrderTableView];
    [self initUnpestachedTableView];
    [self initTransportTableView];
    [self initReceivedTableView];
    [self initFinishedTableView];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_finishedTableView.mas_right);
    }];
    _orderMainScrollView.pagingEnabled = YES;
}

- (void)initOrderTableView {
    self.orderListTableView = [[OrderStausListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.orderListTableView.allowsSelection = NO;
    self.orderListTableView.status = PURCHASED;
    self.orderListTableView.rowHeight = CELL_HEIGHT;
    [self.orderMainScrollView addSubview:self.orderListTableView];
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderMainScrollView);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.orderMainScrollView);
    }];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    self.orderListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.orderListTableView.bounds.size.width, 0.01f)];
}

- (void)initUnpestachedTableView {
    self.unpestachedTableView = [[OrderStausListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.unpestachedTableView.status = UNDISPATCH;
    self.unpestachedTableView.allowsSelection = NO;
    self.unpestachedTableView.rowHeight = CELL_HEIGHT;
    [self.orderMainScrollView addSubview:self.unpestachedTableView];
    [self.unpestachedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderListTableView.mas_right);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.bottom.equalTo(self.orderMainScrollView);
        make.width.equalTo(self.view);
    }];
    self.unpestachedTableView.dataSource = self;
    self.unpestachedTableView.delegate = self;
    self.unpestachedTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.unpestachedTableView.bounds.size.width, 0.01f)];
}

- (void)initTransportTableView {
    self.transportTableView = [[OrderStausListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.transportTableView.status = SHIPPED;
    self.transportTableView.allowsSelection = NO;
    self.transportTableView.rowHeight = CELL_HEIGHT;
    [self.orderMainScrollView addSubview:self.transportTableView];
    [self.transportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unpestachedTableView.mas_right);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.bottom.equalTo(self.orderMainScrollView);
        make.width.equalTo(self.view);
    }];
    self.transportTableView.dataSource = self;
    self.transportTableView.delegate = self;
    self.transportTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.transportTableView.bounds.size.width, 0.01f)];
}

- (void)initReceivedTableView {
    self.receivedTableView = [[OrderStausListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.receivedTableView.status = DELIVERD;
    self.receivedTableView.allowsSelection = NO;
    self.receivedTableView.rowHeight = CELL_HEIGHT;
    [self.orderMainScrollView addSubview:self.receivedTableView];
    [self.receivedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_transportTableView.mas_right);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.bottom.equalTo(self.orderMainScrollView);
        make.width.equalTo(self.view);
    }];
    self.receivedTableView.dataSource = self;
    self.receivedTableView.delegate = self;
    self.receivedTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.receivedTableView.bounds.size.width, 0.01f)];
}

- (void)initFinishedTableView {
    self.finishedTableView = [[OrderStausListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.finishedTableView.status = DONE;
    self.finishedTableView.allowsSelection = NO;
    self.finishedTableView.rowHeight = CELL_HEIGHT;
    [self.orderMainScrollView addSubview:self.finishedTableView];
    [self.finishedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_receivedTableView.mas_right);
        make.top.equalTo(_orderStatusView.mas_bottom);
        make.bottom.equalTo(self.orderMainScrollView);
        make.width.equalTo(self.view);
    }];
    self.finishedTableView.dataSource = self;
    self.finishedTableView.delegate = self;
    self.finishedTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.finishedTableView.bounds.size.width, 0.01f)];
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
    [_purchaseStatusLbl setFont:[UIFont systemFontOfSize:16.0f]];
    _purchaseStatusLbl.textColor = RGB(241, 109, 52);
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
    [_unpestachedStatusLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *unpestachedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectUnpestachedStatusLbl)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [_unpestachedStatusLbl addGestureRecognizer:unpestachedTapgesture];
    [_orderStatusView addSubview:_unpestachedStatusLbl];

 
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
    
    _statusLabels = @[_purchaseStatusLbl,_unpestachedStatusLbl,_transportedStatusLbl,_receivedStatusLbl,_finishStatusLbl];

}

- (void)selectPurchageLbl {
    [self scrollToStaus:0];
}

- (void)selectUnpestachedStatusLbl {
    [self scrollToStaus:1];

}

- (void)selectTransportedStatusLbl {
    [self scrollToStaus:2];

}

- (void)selectReceivedStatusLbl {
    [self scrollToStaus:3];

}

- (void)selectFinishStatusLbl {
    [self scrollToStaus:4];
}

- (void)scrollToStaus:(NSInteger)index {
    UILabel *statusLabel = _statusLabels[index];
    [self updateLblstatus:statusLabel];
    switch (index) {
        case 0:
            break;
        case 1:
            [_orderStatusView scrollRectToVisible:_purchaseStatusLbl.frame animated:YES];
            break;
        case 2:
            [_orderStatusView scrollRectToVisible:_finishStatusLbl.frame animated:YES];
            break;
        case 3:
            [_orderStatusView scrollRectToVisible:_finishStatusLbl.frame animated:YES];
            break;
        case 4:
            break;
        default:
            index = 0;
            break;
    }
    [self moveToPage:index];
}

- (void)moveToPage:(NSInteger)index {
    [_orderMainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*index, 0) animated:YES];
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
    OrderDetailViewController *addNewOrderViewController = [[OrderDetailViewController alloc]
                                                             init];
    [self.navigationController pushViewController:addNewOrderViewController animated:YES];
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
    NSInteger orderCount = 0;
    if (tableView == self.orderListTableView) {
         orderCount = [[self.orderListTableView orderList] count];
    }
    if (tableView == self.unpestachedTableView) {
        orderCount = [[self.unpestachedTableView orderList] count];
    }
    if (tableView == self.transportTableView) {
        orderCount = [[self.transportTableView orderList] count];
    }
    if (tableView == self.receivedTableView) {
       orderCount = [[self.receivedTableView orderList] count];
    }
    if (tableView == self.finishedTableView) {
        orderCount = [[self.finishedTableView orderList] count];
    }
    return orderCount;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:orderlistcellIdentity];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (cell == nil) {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderlistcellIdentity];
    }
    OrderStausListTableView *orderListTableView = nil;
    if (tableView == self.orderListTableView) {
        orderListTableView = self.orderListTableView;
    }
    if (tableView == self.unpestachedTableView) {
        orderListTableView = self.unpestachedTableView;
    }
    if (tableView == self.transportTableView) {
        orderListTableView = self.transportTableView;
    }
    if (tableView == self.receivedTableView) {
         orderListTableView = self.receivedTableView;
    }
    if (tableView == self.finishedTableView) {
        orderListTableView = self.finishedTableView;
    }
    cell.TapEditBlock = ^{
        [self handleTapEditButtonWithIndex:indexPath withTableView:orderListTableView];
    };
    
    cell.TapStatusButtonBlock = ^{
        [self handleTapStatusButtonWithIndex:indexPath  withTableView:orderListTableView];
    };
    
    OrderItem *item = (OrderItem *)[[orderListTableView orderList] objectAtIndex:indexPath.row];
    cell.orderItem = item;
    cell.custom = [self getCustomInfobyId:item.clientid];
    return cell;
}


- (void)handleTapEditButtonWithIndex:(NSIndexPath *)indexPath withTableView:(OrderStausListTableView *) tableView{
    NSArray *orderList = [tableView orderList];
    OrderItem *orderItem = (OrderItem *)[orderList objectAtIndex:indexPath.row];
    
    OrderDetailViewController *editOrderViewContorller = [[OrderDetailViewController alloc]initWithOrderItem:orderItem withClientDetail:[self getCustomInfobyId:orderItem.clientid]];
    editOrderViewContorller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editOrderViewContorller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handleTapStatusButtonWithIndex:(NSIndexPath *)indexPath withTableView:(OrderStausListTableView *) tableView{
    NSArray *orderList = [tableView orderList];
    self.orderItem = (OrderItem *)[orderList objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改订单状态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if (self.orderItem.statu != DONE) {
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        switch (self.orderItem.statu) {
            case PURCHASED:
                self.orderItem.statu = UNDISPATCH;
                break;
            case UNDISPATCH:
                self.orderItem.statu = SHIPPED;
                break;
            case SHIPPED:
                self.orderItem.statu = DELIVERD;
                break;
            case DELIVERD:
                self.orderItem.statu = DONE;
                break;
            case DONE:
                break;
        }
        [[OrderItemManagement shareInstance] updateOrderItem:self.orderItem];
        [self.orderListTableView reloadData];
        [self.unpestachedTableView reloadData];
        [self.transportTableView reloadData];
        [self.receivedTableView reloadData];
        [self.finishedTableView reloadData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self scrollToStaus:page];
}


@end
