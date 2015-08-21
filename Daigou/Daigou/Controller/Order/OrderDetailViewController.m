//
//  OrderDetailViewController.m
//  Daigou
//
//  Created by jin on 15/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CommonDefines.h"
#import <Masonry/Masonry.h>
#import "OAddNewOrderViewController.h"
#import "OrderBasketViewController.h"
#import "OrderDeliveryStatusViewController.h"
#import "OrderItemManagement.h"
#import "OProductItem.h"
#import "CustomInfo.h"

@interface OrderDetailViewController  () <UIScrollViewDelegate>
@property (nonatomic, strong)UIPageViewController *pageController;
@property (nonatomic, strong) UIScrollView *orderDetailMainScrollView;
@property (nonatomic, strong) UIView *subTabView;
@property (nonatomic, strong) NSArray *subTabString;
@property (nonatomic, strong) NSArray *statusLbls;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) OAddNewOrderViewController *addNewOrderViewController;
@property (nonatomic, strong) OrderBasketViewController *orderBasketViewController;
@property (nonatomic, strong) OrderDeliveryStatusViewController *deliveryStatusViewController;
@end

@implementation OrderDetailViewController

- (instancetype)initWithOrderItem:(OrderItem *)orderItem withClientDetail:(CustomInfo *)client
{
    if (self = [super init]) {
        self.customInfo = client;
        self.orderItem = orderItem;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initOrderData];
    [self setPageIndicator];
    [self initScrollView];
}

- (void)initScrollView {
    _orderDetailMainScrollView = [[UIScrollView alloc] initWithFrame: CGRectZero];
    _orderDetailMainScrollView.delegate = self;
    [self.view addSubview:_orderDetailMainScrollView];
    CGFloat topOff = self.tabBarController.tabBar.frame.size.height;
    [_orderDetailMainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_subTabView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-topOff);
    }];
    UIView *container = [UIView new];
    [_orderDetailMainScrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_orderDetailMainScrollView);
    }];
    
    [self setProductDetailController];
    [self setProdcutCollectionController];
    [self setProductMailingInfoController];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_deliveryStatusViewController.view.mas_right);
    }];
    _orderDetailMainScrollView.pagingEnabled = YES;
    _orderDetailMainScrollView.showsHorizontalScrollIndicator = NO;
}

- (void) setPageIndicator {
    _subTabView = [[UIView alloc]init];
    [_subTabView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_subTabView];
    CGFloat topOff = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    [_subTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(topOff);
        make.right.equalTo(self.view);
        make.height.equalTo(@SCROLL_VIEW_HEIGHT);
    }];
    UIView *underLineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCROLL_VIEW_HEIGHT-1, self.view.frame.size.width, 1)];
    underLineView.backgroundColor = [UIColor lightGrayColor];
    [_subTabView addSubview:underLineView];
    
    CGFloat LBL_DISTANCE = self.view.frame.size.width / 3;
    UILabel *orderInfoLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [orderInfoLbl setText:@"订单信息"];
    [orderInfoLbl setFont:[UIFont systemFontOfSize:16.0f]];
    orderInfoLbl.textColor = RGB(241, 109, 52);
    [orderInfoLbl setTextAlignment:NSTextAlignmentCenter];
    [orderInfoLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectOrderInfo)];
    tapgesture.numberOfTapsRequired = 1;
    [orderInfoLbl addGestureRecognizer:tapgesture];
    [_subTabView addSubview:orderInfoLbl];
    
    //
    UILabel *prodListLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderInfoLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [prodListLbl setText:@"货品清单"];
    [prodListLbl setFont:[UIFont systemFontOfSize:14.0f]];
    prodListLbl.textColor = RGB(0, 0, 0);
    [prodListLbl setTextAlignment:NSTextAlignmentCenter];
    [prodListLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *unpestachedTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectProductList)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [prodListLbl addGestureRecognizer:unpestachedTapgesture];
    [_subTabView addSubview:prodListLbl];
    
    //
    UILabel * deliveryInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(prodListLbl.frame), 0, LBL_DISTANCE, SCROLL_VIEW_HEIGHT-1)];
    [deliveryInfoLbl setText:@"快递信息"];
    [deliveryInfoLbl setFont:[UIFont systemFontOfSize:14.0f]];
    deliveryInfoLbl.textColor = RGB(0, 0, 0);
    [deliveryInfoLbl setTextAlignment:NSTextAlignmentCenter];
    [deliveryInfoLbl setUserInteractionEnabled:YES];
    UITapGestureRecognizer *transportTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDeliveryInfo)];
    unpestachedTapgesture.numberOfTapsRequired = 1;
    [deliveryInfoLbl addGestureRecognizer:transportTapgesture];
    [_subTabView addSubview:deliveryInfoLbl];
    
    _statusLbls = @[orderInfoLbl,prodListLbl,deliveryInfoLbl];
    

}

#pragma mark --handleStatusClick 
- (void)selectOrderInfo {
    [self scrollToStaus:0];
}

- (void)selectProductList {
    [self scrollToStaus:1];
}

- (void)selectDeliveryInfo {
    [self scrollToStaus:2];
}

- (void)scrollToStaus:(NSInteger)index {
    UILabel *statusLabel = _statusLbls[index];
    [self updateLblstatus:statusLabel];
    [self moveToPage:index];
}

- (void)moveToPage:(NSInteger)index {
   [_orderDetailMainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*index, 0) animated:YES];
}

- (void)updateLblstatus:(UILabel *)selectedLbl {
 
    [_statusLbls enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
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

#pragma mark -handlerProductsData


- (void) initOrderData {

    if (self.customInfo == nil) {
        self.customInfo = [[CustomInfo alloc]init];
    }
    if (self.orderItem == nil) {
        self.orderItem = [[OrderItem alloc]init];
        self.orderItem.creatDate = [[NSDate date] timeIntervalSince1970];
    }
    [self fetchOrderProducts];
}

- (void)fetchOrderProducts {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    if (self.orderItem.oid == 0) {
        self.products = [NSArray array];
    } else {
        self.products = [itemManagement getOrderProductsByOrderId:self.orderItem.oid];
    }
}

#pragma mark -initControllers

- (void) setProductDetailController {
    if (self.orderItem.parentoid == 0) {
        _addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                      init];
    } else {
        _addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                      initWithOrderItem:self.orderItem withClientDetail:self.customInfo];
    }
    
    
    _addNewOrderViewController.view.tag = ORDERDETAILTAG +0;
    [self addChildViewController:_addNewOrderViewController];
    [self.orderDetailMainScrollView addSubview:_addNewOrderViewController.view];
    [_addNewOrderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderDetailMainScrollView);
        make.top.equalTo(_subTabView.mas_bottom);
        make.bottom.equalTo(_orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];
}

// add some comment


- (void) setProdcutCollectionController {
    _orderBasketViewController = [[OrderBasketViewController alloc]initwithOrderItem:self.orderItem withProducts:self.products];
    _orderBasketViewController.view.tag = ORDERDETAILTAG +1;
    [self addChildViewController:_orderBasketViewController];
    [self.orderDetailMainScrollView addSubview:_orderBasketViewController.view];
    [_orderBasketViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addNewOrderViewController.view.mas_right);
        make.top.equalTo(_subTabView.mas_bottom);
        make.bottom.equalTo(_orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];
}


- (void) setProductMailingInfoController {
    _deliveryStatusViewController = [[OrderDeliveryStatusViewController alloc]init];
    _deliveryStatusViewController.view.tag = ORDERDETAILTAG +2;
    [self addChildViewController:_deliveryStatusViewController];
    [self.orderDetailMainScrollView addSubview:_deliveryStatusViewController.view];
    [_deliveryStatusViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderBasketViewController.view.mas_right);
        make.top.equalTo(_subTabView.mas_bottom);
        make.bottom.equalTo(_orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self scrollToStaus:page];
}
@end
