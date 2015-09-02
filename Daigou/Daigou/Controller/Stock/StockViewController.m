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

#define CELL_HEIGHT 65

@interface StockViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSArray *statusLabels;
@property (nonatomic, strong) StockStatusListTableView *stockListTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation StockViewController
NSString *const stockListcellIdentity = @"stockListcellIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    [self initScrollView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewStock)];
    self.navigationItem.rightBarButtonItem =editButton;
    // Do any additional setup after loading the view.
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
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, 200, 44);
    _searchBar.layer.cornerRadius = 12;
    self.navigationItem.titleView = _searchBar;

    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc]initWithTitle:@"库存" style:UIBarButtonItemStylePlain target:nil action:nil];
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

- (void)addNewStock {

}


#pragma marl - Sort & Search
#pragma mark - Sort & Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        //[self.viewModel filterByString:searchText.uppercaseString];
    } else {
        // [self.viewModel cancelFilter];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
}



#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger orderCount = [[self.stockListTableView stockProductList] count];
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

    OProductItem *item = (OProductItem *)[[self.stockListTableView stockProductList] objectAtIndex:indexPath.row];
    cell.procurementItem = item;
    return cell;
}



@end
