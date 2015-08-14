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
#import "OrderBasketCellFrame.h"
#import "OrderBasketCell.h"
#import "OProductItem.h"
#import "OrderPickProductsMainViewController.h"
#import "CommonDefines.h"

@interface OrderBasketViewController()<UITableViewDataSource, UITableViewDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) OrderItem *orderItem;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) NSArray *products;
@property(nonatomic, strong) NSMutableArray *orderItemFrames;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addProduct)];
    [self checkBasketItems];
}

- (void)addProduct {
    OrderPickProductsMainViewController *orderPickMainViewController =  [[OrderPickProductsMainViewController alloc]init];
    [self.navigationController pushViewController:orderPickMainViewController animated:YES];
}

- (void)checkBasketItems {
    if (self.products.count == 0) {
        [self showEmptyView];
    } else {
        [self initOrderBasketItemsFrameWithOrderItems:self.products];
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 142.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:RGB(238, 238, 238)];
    [self.view addSubview:self.tableView];
}

- (void)initOrderBasketItemsFrameWithOrderItems:(NSArray *)orderItems {
    self.orderItemFrames = [NSMutableArray array];
    for (OProductItem *item in orderItems) {
        OrderBasketCellFrame *itemFrame = [[OrderBasketCellFrame alloc]initFrameWithOrderProduct:item withViewFrame:self.view.bounds];
        [self.orderItemFrames addObject:itemFrame];
    }
    
}

#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = 0;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderBasketCell *cell = [OrderBasketCell OrderWithCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderBasketCellFrame * orderFrame = _orderItemFrames[indexPath.row];
    cell.orderBasketCellFrame = orderFrame;
    cell.EditQuantiyActionBlock = ^(NSInteger number){
        [self beginEditNumber:indexPath];
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.products count];

}

#pragma mark - RefreshBasket 
- (void)refreshBasketContent {

}


#pragma mark - BasketCellDelegate 

- (void)beginEditNumber:(NSIndexPath *)cellIndex {
    CGFloat kbHeight = keyboardSize.height;
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = kbHeight;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = kbHeight;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
        [self.tableView scrollToRowAtIndexPath:cellIndex
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}
@end
