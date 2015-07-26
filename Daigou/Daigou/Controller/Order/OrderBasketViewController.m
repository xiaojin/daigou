//
//  OrderBasketViewController.m
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderBasketViewController.h"
#import "OrderItem.h"
#import "OrderItemManagement.h"
#import "OrderProductsViewController.h"
@interface OrderBasketViewController()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) OrderItem *orderItem;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) NSArray *products;
@end
@implementation OrderBasketViewController

- (instancetype)initwithOrderItem :(OrderItem *)orderitem  withProducts:(NSArray *)products{
    self.orderItem = orderitem;
    self.products = [NSArray array];
    self.products = products;
    return [self init];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addProduct)];
    [self checkBasketItems];
}

- (void)addProduct {
    OrderProductsViewController *ordeProductView = [[OrderProductsViewController alloc]init];
    [self.navigationController pushViewController:ordeProductView animated:YES];
}

- (void)checkBasketItems {
    if (self.products.count == 0) {
        [self showEmptyView];
    } else {
        [self showOrderItemsTableView];
    }
}


- (void)showEmptyView {
    self.emptyView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    CGFloat labelHeight = 44.0f;
    CGFloat labelWidth = CGRectGetWidth(self.view.frame);
    CGFloat offY = (CGRectGetHeight(self.view.frame) - labelHeight)/2;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, offY, labelWidth, labelHeight)];
    [label setText:@"您还订单货物是空的哦"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.emptyView addSubview:label];
    [self.view addSubview:self.emptyView];
}

- (void)showOrderItemsTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORDERBASKETCELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ORDERBASKETCELL"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;

}

@end
