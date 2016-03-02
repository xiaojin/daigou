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
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableDictionary *cartDict;
@end

@implementation OrderBasketPickerViewController


- (instancetype)initWithProducts:(NSArray *)products {
    if (self = [super init]) {
        _products = [NSMutableArray arrayWithArray:products];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = RGB(48, 49, 53);
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
    _tableView.backgroundColor = [UIColor whiteColor];
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
    [dismissButton setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
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
    
    _cartDict = [self getCartProductFromCache];
    
}

- (void)dismissBasketView {
    [self storeCartProductIntoCache];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderBasketPickerCell *cell =[OrderBasketPickerCell cellWithTableView:tableView withCellIndex:indexPath.row];
    cell.TapActionBlock=^(NSInteger cellIndex, ProductWithCount * product){
        [self refreshProductDataSource:cellIndex WithProduct:product];
    };
    cell.backgroundColor=[UIColor whiteColor];
    cell.productCount=_products[indexPath.row];
    return cell;
    
    
}

- (void)refreshProductDataSource:(NSInteger) cellIndex WithProduct:(ProductWithCount *)productWithCount {
    [_products replaceObjectAtIndex:cellIndex withObject:productWithCount];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSMutableDictionary *)getCartProductFromCache {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cartDict = [userDefaults objectForKey:CARTPRODUCTSCACHE];
    NSMutableDictionary *newCartDict = [NSMutableDictionary dictionary];
    [cartDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        ProductWithCount *carProduct = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        NSString *cartKey = key;
        [newCartDict setObject:carProduct forKey:cartKey];
    }];
    
    return newCartDict;
}

- (void)storeCartProductIntoCache{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (ProductWithCount *obj in _products) {
        NSString *cartKey = [NSString stringWithFormat:@"%ld",(long)obj.product.pid];
        NSData *productEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [_cartDict setObject:productEncodedObject forKey:cartKey];
    }

    [userDefaults setObject:_cartDict forKey:CARTPRODUCTSCACHE];
    [userDefaults synchronize];
}
@end
