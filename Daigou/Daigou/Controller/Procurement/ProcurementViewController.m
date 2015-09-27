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

#define LBL_DISTANCE ((kWindowWidth-10)/2)
#define CELL_HEIGHT 85

@interface ProcurementViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ProcurementEditViewDelegate>
@property (nonatomic, strong) UIScrollView *pStatusView;
@property (nonatomic, strong) UIScrollView *pMainScrollView;
@property (nonatomic, strong) UILabel *orderProductsLbl;
@property (nonatomic, strong) UILabel *unOrderProductsLbl;
@property (nonatomic, strong) NSArray *statusLabels;
@property (nonatomic, strong) ProcurementStatusListTableView *stockListTableView;
@property (nonatomic, strong) ProcurementStatusListTableView *orderListTableView;
@property (nonatomic, strong) UIButton *searchTitleBtn;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic ,strong) NSArray *allProcurementProducts;
@property (nonatomic ,strong) NSMutableDictionary *procurementProductsGroup;

@end

@implementation ProcurementViewController
NSString *const procurementListcellIdentity = @"procurementListcellIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProcureStatusView];
    [self initScrollView];
    [self initNavBar];
    [self initOrderListTableView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProcure)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self getAllProductOrderItemWithoutGroup];
    [self searchAllOrderProducts];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addProcureStatusView {
    UIView *contentView = [[UIView alloc]init];
    UIView *underLineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCROLL_VIEW_HEIGHT-1, self.view.frame.size.width, 1)];
    underLineView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat topOff = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _pStatusView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCROLL_VIEW_HEIGHT)];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(topOff);
        make.right.equalTo(self.view);
        make.height.equalTo(@SCROLL_VIEW_HEIGHT);
        
    }];
    [contentView addSubview:underLineView];
    [contentView addSubview:_pStatusView];
    _orderProductsLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_orderProductsLbl setText:@"订单商品"];
    [_orderProductsLbl setFont:[UIFont systemFontOfSize:16.0f]];
    _orderProductsLbl.textColor = RGB(241, 109, 52);
    [_orderProductsLbl setTextAlignment:NSTextAlignmentCenter];
    [_orderProductsLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectOrderList)];
    tapgesture.numberOfTapsRequired = 1;
    [_orderProductsLbl addGestureRecognizer:tapgesture];
    [_pStatusView addSubview:_orderProductsLbl];
    
    //
    _unOrderProductsLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderProductsLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [_unOrderProductsLbl setText:@"囤货商品"];
    [_unOrderProductsLbl setFont:[UIFont systemFontOfSize:14.0f]];
    _unOrderProductsLbl.textColor = RGB(0, 0, 0);
    [_unOrderProductsLbl setTextAlignment:NSTextAlignmentCenter];
    [_unOrderProductsLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *unpestachedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectUnOrderList)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [_unOrderProductsLbl addGestureRecognizer:unpestachedTapgesture];
    [_pStatusView addSubview:_unOrderProductsLbl];
    
    _pStatusView.contentSize = CGSizeMake(CGRectGetMaxX(_unOrderProductsLbl.frame), SCROLL_VIEW_HEIGHT-1);
    [_pStatusView setShowsHorizontalScrollIndicator:NO];
    _statusLabels = @[_orderProductsLbl,_unOrderProductsLbl];

}

- (void)initNavBar {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40.0f, 44.0f)];
    [titleLabel  setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLabel setText:@"采购"];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    
    _searchTitleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100.0f, 44.0f)];
    [_searchTitleBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_searchTitleBtn setTitle:@"全部" forState:UIControlStateNormal];
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

- (void)initScrollView {
    _pMainScrollView = [[UIScrollView alloc] initWithFrame: CGRectZero];
    _pMainScrollView.delegate = self;
    [self.view addSubview:_pMainScrollView];
    [_pMainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_pStatusView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    UIView *container = [UIView new];
    [_pMainScrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_pMainScrollView);
        make.height.equalTo(_pMainScrollView);
    }];
    [self initOrderListTableView];
    [self initStockListTableView];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_stockListTableView.mas_right);
    }];
    _pMainScrollView.pagingEnabled = YES;

}

- (void)filteriOS8AndAbove {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* allBtn = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                                [self searchAllOrderProducts];
                                                           }];
    UIAlertAction* orderBtn = [UIAlertAction actionWithTitle:@"按订单查看" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self searchAllProductsByOrder];
                                                                  }];
    __weak id weakSelf = self;
    [alert addAction:allBtn];
    [alert addAction:orderBtn];
    alert.popoverPresentationController.sourceRect = self.view.frame;
    alert.popoverPresentationController.sourceView = weakSelf;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)filterBelowiOS8 {
    RIButtonItem *allBtn = [RIButtonItem itemWithLabel:@"全部" action:^{
        [self searchAllOrderProducts];
        
    }];
    RIButtonItem *orderBtn = [RIButtonItem itemWithLabel:@"按订单查看" action:^{
        [self searchAllProductsByOrder];
        
    }];

    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     cancelButtonItem:nil
                                                destructiveButtonItem: nil
                                                     otherButtonItems:allBtn, orderBtn,nil];
    
    [actionSheet showFromRect:self.view.frame inView:self.view animated:YES];
}

- (void)searchAllOrderProducts {
    [_searchTitleBtn setTitle:@"全部" forState:UIControlStateNormal];
    _orderList = [NSMutableArray arrayWithObject:@"全部订单"];
    _productsList = [NSMutableArray arrayWithObject:[self.orderListTableView procurementProductList]];
    [_orderListTableView reloadData];
    
}

- (void)searchAllProductsByOrder {
    [_searchTitleBtn setTitle:@"按订单查看" forState:UIControlStateNormal];
    _orderList = [NSMutableArray array];
    for (NSNumber *mykey in [_procurementProductsGroup allKeys]) {
        NSArray *orderItemClients = [_procurementProductsGroup objectForKey:mykey];
        [_orderList addObject:[(OrderItemClient*)orderItemClients[0] customInfo].name];
        NSMutableArray *products = [NSMutableArray array];
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        NSArray *keys = [mutableDict allKeys];
        for (OrderItemClient *orderItemClient in orderItemClients) {
            BOOL hasKey = [keys containsObject:[NSNumber numberWithInteger:orderItemClient.productItem.iid]];
            if (hasKey) {
                NSMutableArray *products = [mutableDict objectForKey:[NSNumber numberWithInteger:orderItemClient.productItem.iid]];
                [products addObject:orderItemClient.productItem];
                [mutableDict setObject:products forKey:[NSNumber numberWithInteger:orderItemClient.productItem.iid]];
            } else {
                NSMutableArray *products = [NSMutableArray array];
                [products addObject:orderItemClient.productItem];
                [mutableDict setObject:products forKey:[NSNumber numberWithInteger:orderItemClient.productItem.iid]];
            }
            [products addObject:orderItemClient.productItem];
        
        }
        for (NSNumber *key in mutableDict.allKeys) {
            NSArray *objects = (NSArray *)[mutableDict objectForKey:key];
            NSDictionary *orderGroupDict = @{@"oproductitem":objects[0],
                                             @"count":@(objects.count)};
            [_productsList addObject:orderGroupDict];
        }
    }
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
}

- (void)initOrderListTableView {
    self.orderListTableView = [[ProcurementStatusListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.orderListTableView.status = OrderProduct;
    self.orderListTableView.rowHeight = CELL_HEIGHT;
    [self.pMainScrollView addSubview:self.orderListTableView];
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pMainScrollView);
        make.top.equalTo(_pStatusView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.pMainScrollView);

    }];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    self.orderListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.orderListTableView.bounds.size.width, 0.01f)];
}

- (void)initStockListTableView {
    self.stockListTableView = [[ProcurementStatusListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.stockListTableView.status = UnOrderProduct;
    self.stockListTableView.rowHeight = CELL_HEIGHT;
    [self.pMainScrollView addSubview:self.stockListTableView];
    [self.stockListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderListTableView.mas_right);
        make.top.equalTo(_pStatusView.mas_bottom);
        make.bottom.equalTo(self.pMainScrollView);
        make.width.equalTo(self.view);
    }];
    self.stockListTableView.dataSource = self;
    self.stockListTableView.delegate = self;
    self.stockListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.stockListTableView.bounds.size.width, 0.01f)];
}


#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger orderCount = 0;
    if (tableView == self.orderListTableView) {
        orderCount = [[self.orderListTableView procurementProductList] count];
    }
    if (tableView == self.stockListTableView) {
        orderCount = [[self.stockListTableView procurementProductList] count];
    }

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
    ProcurementStatusListTableView *procurementListTableView = nil;
    if (tableView == self.orderListTableView) {
        procurementListTableView = self.orderListTableView;
    }
    if (tableView == self.stockListTableView) {
        procurementListTableView = self.stockListTableView;
    }
    NSDictionary *item = (NSDictionary *)[[procurementListTableView procurementProductList] objectAtIndex:indexPath.row];
    cell.procurementItem = item;
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcurementEditView *editView = [[ProcurementEditView alloc]init];
    editView.delegate = self;
    NSDictionary *item = _productsList[indexPath.section][indexPath.row];
    editView.productItemDict = item;
    [editView showWithBlock:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -updateContentView
- (void)selectOrderList {
    [self scrollToStaus:0];
    
}

- (void)selectUnOrderList {
    [self scrollToStaus:1];
}


- (void)scrollToStaus:(NSInteger)index {
    if (index == 1) {
        _searchTitleBtn.hidden = YES;
    } else {
        _searchTitleBtn.hidden = NO;
    }
    UILabel *statusLabel = _statusLabels[index];
    [self updateLblstatus:statusLabel];
    [self moveToPage:index];
}

- (void)moveToPage:(NSInteger)index {
    [_pMainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*index, 0) animated:YES];
}

- (void)updateLblstatus:(UILabel *)selectedLbl {
    NSArray *statusLbl = @[_orderProductsLbl, _unOrderProductsLbl];
    [statusLbl enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        if ([obj isEqual:selectedLbl]) {
            obj.textColor = RGB(241, 109, 52);
            obj.font = [UIFont systemFontOfSize:16.0f];
            } else {
                obj.textColor = RGB(0,0,0);
                obj.font = [UIFont systemFontOfSize:14.0f];
            }
        [UIView commitAnimations];
        }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self scrollToStaus:page];
}

#pragma mark - ProcurementEditViewDelegate
- (void)purchaseDidFinish {
    [self.orderListTableView reloadData];
    [self.stockListTableView reloadData];
}
@end
