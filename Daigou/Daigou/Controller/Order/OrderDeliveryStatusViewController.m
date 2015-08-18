//
//  OrderDeliveryStatusViewController.m
//  Daigou
//
//  Created by jin on 16/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderDeliveryStatusViewController.h"
#import "OrderItemView.h"
#import "OrderItemPhoneView.h"

#define ORDERTAGBASE 80000;
@interface OrderDeliveryStatusViewController ()<UITableViewDataSource, UITableViewDelegate>{
    CGSize keyboardSize;
}
@property (nonatomic, strong) UITableView *deliveryTableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *detailArray;
@end

@implementation OrderDeliveryStatusViewController
static NSString *const orderdeliveryStatysIdentity = @"ORDERDELIVERYSTATUSCONTROLLER";
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"收件人",@"地址",@"联系电话",@"身份证号",@"邮政编码",@"快递公司",@"货运单号"];
    _detailArray = @[@"",@"",@"",@"",@"",@"",@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [self addTableVIew];
}

- (void)addTableVIew {
    self.deliveryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.deliveryTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.deliveryTableView.delegate = self;
    self.deliveryTableView.dataSource = self;
    //self.deliveryTableView.allowsSelection = NO;
    [self.view addSubview:self.deliveryTableView];
    
}
#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self deliveryTableView] contentInset];
        edgeInsets.bottom = 0;
        [[self deliveryTableView] setContentInset:edgeInsets];
        edgeInsets = [[self deliveryTableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self deliveryTableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey ] CGRectValue].size;
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + 100.0f);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 2) {
        cell = [self setOrderPhoneItemView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        cell = [self setOrderItemView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (OrderItemView *) setOrderItemView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemView *orderCell = [tableView dequeueReusableCellWithIdentifier:orderdeliveryStatysIdentity];
    if (orderCell == nil) {
        orderCell = [[OrderItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderdeliveryStatysIdentity];
    }
    [orderCell updateCellWithTitle:self.titleArray[indexPath.row] detailInformation:[NSString stringWithFormat:@"%@",self.detailArray[indexPath.row]]];
    return  orderCell;
}

- (OrderItemPhoneView *) setOrderPhoneItemView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemPhoneView *orderCell = [tableView dequeueReusableCellWithIdentifier:orderdeliveryStatysIdentity];
    if (orderCell == nil) {
        orderCell = [[OrderItemPhoneView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderdeliveryStatysIdentity];
    }
    [orderCell updateCellWithTitle:self.titleArray[indexPath.row] detailInformation:[NSString stringWithFormat:@"%@",self.detailArray[indexPath.row]]];
    return  orderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
@end
