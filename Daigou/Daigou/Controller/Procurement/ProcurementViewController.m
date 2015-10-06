//
//  FirstViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProcurementViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import <UIAlertView-Blocks/RIButtonItem.h>
#import <UIAlertView-Blocks/UIActionSheet+Blocks.h>
#import "CommonDefines.h"
#import "ProcurementStatusListTableView.h"
#import "ProcurementListCell.h"
#import "OProductItem.h"
#import "ProcurementEditView.h"
#import "OrderItemManagement.h"
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "AddNewProcurementViewController.h"

#define LBL_DISTANCE ((kWindowWidth-10)/2)
#define CELL_HEIGHT 85

@interface ProcurementViewController ()<UITableViewDataSource,UITableViewDelegate,ProcurementEditViewDelegate, AddNewProcurementViewControllerDelegate>
@property (nonatomic, strong) ProcurementStatusListTableView *orderListTableView;
@property (nonatomic, strong) UIButton *searchTitleBtn;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic ,strong) NSArray *allProcurementProducts;
@property (nonatomic ,strong) NSMutableDictionary *procurementProductsGroup;
@property (nonatomic, assign) NSInteger clickTag;
@end

@implementation ProcurementViewController
NSString *const procurementListcellIdentity = @"procurementListcellIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initOrderListTableView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProcure)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self searchAllOrderProducts];
    _clickTag = 10001;
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self purchaseDidFinish];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initNavBar {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40.0f, 44.0f)];
    [titleLabel  setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLabel setText:@"采购"];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    
    _searchTitleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100.0f, 44.0f)];
    [_searchTitleBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_searchTitleBtn setTitle:@"全部订单" forState:UIControlStateNormal];
    [_searchTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_searchTitleBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    UIImage *arrowDown = [IonIcons imageWithIcon:ion_arrow_down_b size:22.0f color:[UIColor blackColor]];
    [_searchTitleBtn setImage:arrowDown forState:UIControlStateNormal];
    [_searchTitleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 65)];
    [_searchTitleBtn addTarget:self action:@selector(filterPurchaseProducts) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:_searchTitleBtn];
    
    self.navigationItem.leftBarButtonItems = @[titleBarItem,searchBtn];
    
}

- (void)filterPurchaseProducts {
    if (IOS8_OR_ABOVE) {
        [self filteriOS8AndAbove];
    } else {
        [self filterBelowiOS8];
    }
}

- (void)filteriOS8AndAbove {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* allBtn = [UIAlertAction actionWithTitle:@"全部订单" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                                [self searchAllOrderProducts];
                                                               _clickTag = 10001;
                                                           }];
    UIAlertAction* orderBtn = [UIAlertAction actionWithTitle:@"按订单查看" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self searchAllProductsByOrder];
                                                                      _clickTag = 10002;
                                                                  }];
    UIAlertAction* stockListBtn = [UIAlertAction actionWithTitle:@"囤货清单" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self searchAllStockProducts];
                                                         _clickTag = 10003;
                                                     }];
    __weak id weakSelf = self;
    [alert addAction:allBtn];
    [alert addAction:orderBtn];
    [alert addAction:stockListBtn];
    alert.popoverPresentationController.sourceRect = self.view.frame;
    alert.popoverPresentationController.sourceView = weakSelf;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)filterBelowiOS8 {
    RIButtonItem *allBtn = [RIButtonItem itemWithLabel:@"全部订单" action:^{
        [self searchAllOrderProducts];
        _clickTag = 10001;
    }];
    RIButtonItem *orderBtn = [RIButtonItem itemWithLabel:@"按订单查看" action:^{
        [self searchAllProductsByOrder];
        _clickTag = 10002;
    }];
    RIButtonItem *stockListBtn = [RIButtonItem itemWithLabel:@"囤货清单" action:^{
        [self searchAllStockProducts];
        _clickTag = 10003;
    }];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     cancelButtonItem:nil
                                                destructiveButtonItem: nil
                                                     otherButtonItems:allBtn, orderBtn,
                                                        stockListBtn,nil];
    
    [actionSheet showFromRect:self.view.frame inView:self.view animated:YES];
}

- (void)searchAllOrderProducts {
    [_searchTitleBtn setTitle:@"全部订单" forState:UIControlStateNormal];
    _orderList = [NSMutableArray arrayWithObject:@"全部订单"];
    NSArray *products = [[OrderItemManagement shareInstance] getprocurementProductItemsGroupByStatus:OrderProduct];
    _productsList = [NSMutableArray array];
    [_productsList addObject:products];
    [_orderListTableView reloadData];
}

- (void)searchAllProductsByOrder {
    [self getAllProductOrderItemWithoutGroup];
    [_searchTitleBtn setTitle:@"按订单查看" forState:UIControlStateNormal];
    _orderList = [NSMutableArray array];
    _productsList = [NSMutableArray array];
    for (NSNumber *mykey in [_procurementProductsGroup allKeys]) {
        NSArray *orderItemClients = [_procurementProductsGroup objectForKey:mykey];
        [_orderList addObject:[(OrderItemClient*)orderItemClients[0] customInfo].name];
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        for (OrderItemClient *orderItemClient in orderItemClients) {
            NSArray *keys = [mutableDict allKeys];
            BOOL hasKey = [keys containsObject:[NSNumber numberWithInteger:orderItemClient.productItem.productid]];
            if (hasKey) {
                NSMutableArray *products = [mutableDict objectForKey:[NSNumber numberWithInteger:orderItemClient.productItem.productid]];
                [products addObject:orderItemClient.productItem];
                [mutableDict setObject:products forKey:[NSNumber numberWithInteger:orderItemClient.productItem.productid]];
            } else {
                NSMutableArray *products = [NSMutableArray array];
                [products addObject:orderItemClient.productItem];
                [mutableDict setObject:products forKey:[NSNumber numberWithInteger:orderItemClient.productItem.productid]];
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSNumber *key in mutableDict.allKeys) {
            NSArray *objects = (NSArray *)[mutableDict objectForKey:key];
            NSDictionary *orderGroupDict = @{@"oproductitem":objects[0],
                                             @"count":@(objects.count)};
            [array addObject:orderGroupDict];
        }
        [_productsList addObject:array];
    }
    [_orderListTableView reloadData];
}

- (void)searchAllStockProducts {
    [_searchTitleBtn setTitle:@"囤货清单" forState:UIControlStateNormal];
    _orderList = [NSMutableArray arrayWithObject:@"囤货清单"];
    NSArray *products = [[OrderItemManagement shareInstance] getprocurementProductItemsGroupByStatus:UnOrderProduct];
    _productsList = [NSMutableArray array];
    [_productsList addObject:products];
    [_orderListTableView reloadData];
}

- (void)getAllProductOrderItemWithoutGroup {
    OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
    _allProcurementProducts = [orderItemManagement getAllprocurementProductItemsWithOutGroup];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    for (int i =0; i < [_allProcurementProducts count]; i++) {
        OrderItemClient *productItemCLient = [_allProcurementProducts objectAtIndex:i];
        NSArray *keys = [mutableDict allKeys];
        BOOL hasKey = [keys containsObject:[NSNumber numberWithInteger:productItemCLient.productItem.orderid]];
        if (hasKey) {
            NSMutableArray *products = [mutableDict objectForKey:[NSNumber numberWithInteger:productItemCLient.productItem.orderid]];
            [products addObject:productItemCLient];
            [mutableDict setObject:products forKey:[NSNumber numberWithInteger:productItemCLient.productItem.orderid]];
        }else {
            NSMutableArray *products = [NSMutableArray array];
            [products addObject:productItemCLient];
            [mutableDict setObject:products forKey:[NSNumber numberWithInteger:productItemCLient.productItem.orderid]];
        }
    }
    _procurementProductsGroup = mutableDict;
}


- (void)addNewProcure {
    AddNewProcurementViewController *addNewProcurementViewController = [[AddNewProcurementViewController alloc] init];
    addNewProcurementViewController.view.backgroundColor = [UIColor whiteColor];
    addNewProcurementViewController.delegate = self;
    addNewProcurementViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addNewProcurementViewController animated:YES];
}

- (void)initOrderListTableView {
    self.orderListTableView = [[ProcurementStatusListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.orderListTableView.rowHeight = CELL_HEIGHT;
    [self.view addSubview:self.orderListTableView];
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    self.orderListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.orderListTableView.bounds.size.width, 0.01f)];
}

#pragma mark - AddNewProcurementViewControllerDelegate

- (void)didFinishAddNewProcurement {
    [self searchAllStockProducts];
}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger orderCount = [[_productsList objectAtIndex:section] count];

    return orderCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _orderList[section];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProcurementListCell * cell = [tableView dequeueReusableCellWithIdentifier:procurementListcellIdentity];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (cell == nil) {
        cell = [[ProcurementListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:procurementListcellIdentity];
    }
    NSDictionary *item = (NSDictionary *)[[_productsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.procurementItem = item;
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcurementEditView *editView = [[ProcurementEditView alloc]init];
    editView.clickTag = _clickTag;
    editView.delegate = self;
    NSDictionary *item = _productsList[indexPath.section][indexPath.row];
    editView.productItemDict = item;
    [editView showWithBlock:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ProcurementEditViewDelegate
- (void)purchaseDidFinish {
    if (_clickTag == 10001) {
        [self searchAllOrderProducts];
    } else if (_clickTag == 10002) {
        [self searchAllProductsByOrder];
    } else {
        [self searchAllStockProducts];
    }
    [self.orderListTableView reloadData];

}
@end
