//
//  OrderSearchViewController.m
//  Daigou
//
//  Created by jin on 7/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      uu                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

#import "OrderSearchViewController.h"
#import "OrderItemManagement.h"
#import "UISearchBar+UISearchBarAccessory.h"
#import <Masonry/Masonry.h>
#import "CustomInfoManagement.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"

@interface OrderSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSArray *searchObjects;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UITableView *searchTableView;
@property(nonatomic, strong)NSMutableArray *searchResultData;
@property(nonatomic, strong)NSMutableArray *customs;
@property(nonatomic, strong)NSMutableArray *titleList;
@end

@implementation OrderSearchViewController

- (instancetype)init {
    if (self = [super init]) {
        [self getAllOrders];
    }
    return self;
}

- (void)getAllOrders {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    CustomInfoManagement *customMangement = [CustomInfoManagement shareInstance];
    _searchObjects = [itemManagement getOrderItems];
    NSMutableArray *customList = [NSMutableArray array];
    _customs = [NSMutableArray array];
    for (OrderItem * item in _searchObjects) {
        if (![customList containsObject:@(item.clientid)]) {
            [customList addObject:@(item.clientid)];
        }
    }
    for (NSNumber *customIdObject in customList) {
        CustomInfo *custom = [customMangement getCustomInfoById:[customIdObject integerValue]];
        [_customs addObject:custom];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResultData = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"客户姓名搜索";
    self.navigationItem.titleView = _searchBar;
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
    // Do any additional setup after loading the view.
}

- (void)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CustomInfo *)getCustomInfobyId:(NSInteger)customId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cid == %d", customId];
    NSArray *filterCustoms = [_customs filteredArrayUsingPredicate:predicate];
    return filterCustoms[0];
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ORDERSEARCHCELL"];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (cell == nil) {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ORDERSEARCHCELL"];
    }
    cell.TapEditBlock = ^{
        [_searchBar resignFirstResponder];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            OrderItem *item = _searchResultData[indexPath.section][indexPath.row];
            [_delegate didSelectOrderItem:item withCustom:[self getCustomInfobyId:item.clientid]];
        }];
    };
    
    cell.TapStatusButtonBlock = nil;
    
    OrderItem *item = _searchResultData[indexPath.section][indexPath.row];
    cell.orderItem = item;
    cell.custom = [self getCustomInfobyId:item.clientid];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_searchResultData objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_searchResultData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_titleList objectAtIndex:section];
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
    _searchResultData = [NSMutableArray array];
    _titleList = [NSMutableArray array];
    if (![query isEqual:@""]) {
        NSString *normalisedQuery = [NSString stringWithFormat:@"*%@*", [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ || ename LIKE[cd] %@", normalisedQuery, normalisedQuery];
        NSArray *filterCustoms = [_customs filteredArrayUsingPredicate:predicate];
        NSMutableArray *filterOrders = [NSMutableArray array];
        for (CustomInfo *custom in filterCustoms) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientid == %d", custom.cid];
            NSArray *filterOrder = [_searchObjects filteredArrayUsingPredicate:predicate];
            [filterOrders addObjectsFromArray:filterOrder];
        }
        NSPredicate *purchasedPredicate = [NSPredicate predicateWithFormat:@"statu == %d", PURCHASED];
        NSPredicate *unDispatchPredicate = [NSPredicate predicateWithFormat:@"statu == %d", UNDISPATCH];
        NSPredicate *shippedPredicate = [NSPredicate predicateWithFormat:@"statu == %d", SHIPPED];
        NSPredicate *deliverdPredicate = [NSPredicate predicateWithFormat:@"statu == %d", DELIVERD];
        NSPredicate *donePredicate = [NSPredicate predicateWithFormat:@"statu == %d", DONE];
        
        NSArray *purchasedArray = [filterOrders filteredArrayUsingPredicate:purchasedPredicate];
        if ([purchasedArray count] >0) {
            [_titleList addObject:@"采购中订单"];
            [_searchResultData addObject:purchasedArray];
        }
        
        NSArray *unDispatchArray = [filterOrders filteredArrayUsingPredicate:unDispatchPredicate];
        if ([unDispatchArray count] >0) {
            [_titleList addObject:@"待发货订单"];
            [_searchResultData addObject:unDispatchArray];
        }
        
        NSArray *shippedArray = [filterOrders filteredArrayUsingPredicate:shippedPredicate];
        if ([shippedArray count] >0) {
            [_titleList addObject:@"运输中订单"];
            [_searchResultData addObject:shippedArray];
        }
        
        NSArray *deliverdArray = [filterOrders filteredArrayUsingPredicate:deliverdPredicate];
        if ([deliverdArray count] >0) {
            [_titleList addObject:@"已收获订单"];
            [_searchResultData addObject:deliverdArray];
        }
        
        NSArray *doneArray = [filterOrders filteredArrayUsingPredicate:donePredicate];
        if ([doneArray count] >0) {
            [_titleList addObject:@"已完成订单"];
            [_searchResultData addObject:doneArray];
        }
    }
    
}

@end
