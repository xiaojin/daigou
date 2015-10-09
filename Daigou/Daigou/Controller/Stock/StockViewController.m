//
//  StockViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "StockViewController.h"
#import "StockStatusListTableView.h"
#import "UISearchBar+UISearchBarAccessory.h"
#import <Masonry/Masonry.h>
#import "StockListCell.h"
#import "OrderItemManagement.h"
#import "ProductManagement.h"

#define CELL_HEIGHT 65

@interface StockViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *statusLabels;
@property (nonatomic, strong) StockStatusListTableView *stockListTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *stockProductList;
@property (nonatomic, strong) NSMutableArray *oldProductList;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *prodArray;
@end

@implementation StockViewController
NSString *const stockListcellIdentity = @"stockListcellIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    [self initScrollView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _stockProductList = [NSMutableArray arrayWithArray:[[OrderItemManagement shareInstance] getstockProductItems]];
    _oldProductList = [_stockProductList mutableCopy];
    [self productDetailForOrderItem];
    [_stockListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addStockStatusView {
    //可能增加搜索栏目
}

- (void)addSearchView {

    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, 160, 44);
    _searchBar.layer.cornerRadius = 12;
    self.navigationItem.titleView = _searchBar;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [lable setFont:[UIFont systemFontOfSize:14.0f]];
    lable.text = @"库存";
    [lable setTextColor:[UIColor blackColor]];
    
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:lable];
    self.navigationItem.leftBarButtonItems = @[titleButton];
}

- (void)initScrollView {
    _stockListTableView = [[StockStatusListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _stockListTableView.rowHeight = CELL_HEIGHT;
    [self.view addSubview:self.stockListTableView];
    [_stockListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _stockListTableView.dataSource = self;
    _stockListTableView.delegate = self;
    _stockListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.stockListTableView.bounds.size.width, 0.01f)];
    
}

- (void)productDetailForOrderItem {
    ProductManagement *prodManagement = [ProductManagement shareInstance];
    _itemArray = [NSMutableArray array];
    _prodArray = [NSMutableArray array];
    for (NSDictionary *dict in _oldProductList) {
        OProductItem *item = (OProductItem *)[dict objectForKey:@"oproductitem"];
        [_itemArray addObject:item];
        Product *product = [prodManagement getProductById:item.productid];
        [_prodArray addObject:product];
    }
}


#pragma mark - Sort & Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        [_stockProductList removeAllObjects];
        NSString *normalisedQuery = [NSString stringWithFormat:@"*%@*", [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ or ename LIKE[cd] %@", normalisedQuery,normalisedQuery];
        NSArray *searchProdResult = [_prodArray filteredArrayUsingPredicate:predicate];
        NSMutableArray *searchResult = [NSMutableArray array];
        for (Product *prod in searchProdResult) {
            NSUInteger index = [_prodArray indexOfObject:prod];
            [searchResult addObject:[_oldProductList objectAtIndex:index]];
        }
        _stockProductList = [NSMutableArray arrayWithArray:searchResult];
    } else {
        _stockProductList = [self.oldProductList mutableCopy];
    }
    [_stockListTableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
}



#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger orderCount = [_stockProductList count];
    return orderCount;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockListCell * cell = [tableView dequeueReusableCellWithIdentifier:stockListcellIdentity];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (cell == nil) {
        cell = [[StockListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stockListcellIdentity];
    }

    NSDictionary *item = (NSDictionary *)[_stockProductList objectAtIndex:indexPath.row];
    cell.procurementItem = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
