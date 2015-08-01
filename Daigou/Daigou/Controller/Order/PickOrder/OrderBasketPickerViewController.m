//
//  OrderBasketViewController.m
//  Daigou
//
//  Created by jin on 1/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderBasketPickerViewController.h"
#import "ProductWithCount.h"
#import "CommonDefines.h"
#import "OrderProductsRightCell.h"
#import "OrderBasketPickerCell.h"
#import <Masonry/Masonry.h>

@interface OrderBasketPickerViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) UIView *headView;
@end

@implementation OrderBasketPickerViewController


- (instancetype)initWithProducts:(NSArray *)products {
    if (self = [super init]) {
        _products = products;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *dismissButton = [[UIButton alloc]init];
    [dismissButton addTarget:self action:@selector(dismissBasketView) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitle:@"完成" forState:UIControlStateNormal];
    [dismissButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [_headView addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).with.offset(7);
        make.top.equalTo(_headView.mas_top).with.offset(10);
        make.bottom.equalTo(_headView.mas_bottom).with.offset(7);
        make.width.equalTo(@40);
    }];
    
    UIView *underlineView = [[UIView alloc]init];
    [underlineView setBackgroundColor:RGB(125, 125, 125)];
    [_headView addSubview:underlineView];
    [underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left);
        make.right.equalTo(_headView.mas_right);
        make.bottom.equalTo(_headView.mas_bottom).with.offset(-1);
        make.height.equalTo(@1);
    }];
    
}

- (void)dismissBasketView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _products.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderBasketPickerCell *cell =[OrderBasketPickerCell cellWithTableView:tableView];
//    cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,Product *product){
//        if ([self.rightDelegate respondsToSelector:@selector(quantity:money:product:)]) {
//            [self.rightDelegate quantity:pageIndex money:money product:product];
//        }
//        
//    };
    cell.backgroundColor=RGB(246, 246, 246);
    cell.productCount=_products[indexPath.row];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
