//
//  UISearchViewController.m
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UISearchViewController.h"
#import "UISearchBar+UISearchBarAccessory.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "Product.h"
#import "ProductManagement.h"
@interface UISearchViewController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSArray *searchObjects;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UITableView *searchTableView;
@property(nonatomic, strong)NSArray *searchResultData;
@end

@implementation UISearchViewController

- (instancetype)init {
    if (self = [super init]) {
        [self getAllProducts];
    }
    return self;
}

- (void)getAllProducts {
    ProductManagement *productmanagement = [ProductManagement shareInstance];
    _searchObjects = [productmanagement getProduct];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResultData = [NSArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"商品名称搜索";
    self.navigationItem.titleView = _searchBar;
    [_searchBar sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
    self.navigationItem.rightBarButtonItem =rightButton;
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    [self.view addSubview:_searchTableView];
    [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _searchTableView.hidden = YES;
    [_searchBar becomeFirstResponder];
}


- (void)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCHVIEWDELEGATE"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SEARCHVIEWDELEGATE"];
    }
    Product *product = [_searchResultData objectAtIndex:indexPath.row];
    cell.textLabel.text = product.name;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResultData count];
}

#pragma mark - Sort & Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self search:searchText];
    if ([_searchResultData count]>0) {
        _searchTableView.hidden = NO;
        [_searchTableView reloadData];
    } else {
        _searchTableView.hidden = YES;
    }
}

- (void)search:(NSString *)query {
    if (![query isEqual:@""]) {
        NSString *normalisedQuery = [NSString stringWithFormat:@"*%@*", [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@", normalisedQuery];
        _searchResultData = [_searchObjects filteredArrayUsingPredicate:predicate];
    } else {
        _searchResultData = [NSArray array];
    }
 
}
@end
