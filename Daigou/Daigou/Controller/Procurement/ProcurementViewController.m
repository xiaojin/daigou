//
//  FirstViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "ProcurementViewController.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "ProcurementStatusListTableView.h"
#import "ProcurementListCell.h"
#import "OProductItem.h"
#define LBL_DISTANCE ((kWindowWidth-10)/2)
#define CELL_HEIGHT 65

@interface ProcurementViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *pStatusView;
@property (nonatomic, strong) UIScrollView *pMainScrollView;
@property (nonatomic, strong) UILabel *orderProductsLbl;
@property (nonatomic, strong) UILabel *unOrderProductsLbl;
@property (nonatomic, strong) NSArray *statusLabels;
@property (nonatomic, strong) ProcurementStatusListTableView *orderListTableView;
@property (nonatomic, strong) ProcurementStatusListTableView *stockListTableView;
@end

@implementation ProcurementViewController
NSString *const procurementListcellIdentity = @"procurementListcellIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProcureStatusView];
    [self initScrollView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProcure)];
    self.navigationItem.rightBarButtonItem =editButton;
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
    [_orderProductsLbl setText:@"非订单商品"];
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
    [_unOrderProductsLbl setText:@"待发货"];
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

- (void)addNewProcure {
}

- (void)initOrderListTableView {
    self.orderListTableView = [[ProcurementStatusListTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.orderListTableView.allowsSelection = NO;
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
    
    OProductItem *item = (OProductItem *)[[procurementListTableView procurementProductList] objectAtIndex:indexPath.row];
    cell.procurementItem = item;
    return cell;
}

#pragma mark -updateContentView
- (void)selectOrderList {
    [self scrollToStaus:0];
    
}

- (void)selectUnOrderList {
    [self scrollToStaus:1];
}

- (void)scrollToStaus:(NSInteger)index {
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
@end
