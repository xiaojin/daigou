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
#import <Masonry/Masonry.h>

@interface OrderBasketPickerViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) UIView *headView;
@end

@implementation OrderBasketPickerViewController


- (instancetype)initWithProducts:(NSArray *)products {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _headView = [[UIView alloc]init];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _products.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [UITableViewCell ]
    //OrderProductsRightCell *cell =[OrderProductsRightCell cellWithTableView:tableView];
//    cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,Product *product){
//        if ([self.rightDelegate respondsToSelector:@selector(quantity:money:product:)]) {
//            [self.rightDelegate quantity:pageIndex money:money product:product];
//        }
//        
//    };
   // cell.backgroundColor=RGB(246, 246, 246);
    //cell.product=_products[indexPath.row];
    return nil;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
