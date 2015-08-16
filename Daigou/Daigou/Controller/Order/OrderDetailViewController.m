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

@interface OrderDetailViewController  () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong)UIPageViewController *pageController;
@property (nonatomic, strong)NSArray *childPages;
@property (nonatomic, strong)UIView *subTabView;
@property (nonatomic, strong)NSArray *subTabString;
@property (nonatomic, strong)NSArray *statusLbls;
@property(nonatomic, strong)NSArray *products;

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
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageController.dataSource = self;
    _pageController.delegate = self;
    _childPages = @[[self setProductDetailController],[self setProdcutCollectionController],[self setProductMailingInfoController]];
    [_pageController setViewControllers:@[_childPages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
    
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [_pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTabView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.pageController didMoveToParentViewController:self];

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
    [_pageController setViewControllers:@[_childPages[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
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

- (UIViewController *) setProductDetailController {
    OAddNewOrderViewController *addNewOrderViewController = nil;
    if (self.orderItem.parentoid == 0) {
        addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                      init];
    }
    addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                 initWithOrderItem:self.orderItem withClientDetail:self.customInfo];
    addNewOrderViewController.view.frame = self.view.bounds;
    addNewOrderViewController.view.tag = ORDERDETAILTAG +0;
    return addNewOrderViewController;
}

- (UIViewController *) setProdcutCollectionController {
    OrderBasketViewController *orderBasket = [[OrderBasketViewController alloc]initwithOrderItem:self.orderItem withProducts:self.products];
    orderBasket.view.frame = self.view.bounds;
    orderBasket.view.tag = ORDERDETAILTAG +1;
    return orderBasket;
}


- (UIViewController *) setProductMailingInfoController {
    OrderDeliveryStatusViewController *deliveryStatusViewController = [[OrderDeliveryStatusViewController alloc]init];

    deliveryStatusViewController.view.frame = self.view.bounds;
    deliveryStatusViewController.view.tag = ORDERDETAILTAG +2;
    return deliveryStatusViewController;

}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if ([_childPages count] == 0 || index >= [_childPages count]) {
        return nil;
    }
    
    return [_childPages objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished) {
        NSInteger pageIndex =  ((UIViewController *)pageViewController.viewControllers[0]).view.tag - ORDERDETAILTAG;
        UILabel *statusLabel = _statusLbls[pageIndex];
        [self updateLblstatus:statusLabel];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = viewController.view.tag - ORDERDETAILTAG;
    if ((pageIndex == 0) || pageIndex == NSNotFound) {
        return nil;
    }
    pageIndex --;
    return [self viewControllerAtIndex:pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = viewController.view.tag - ORDERDETAILTAG;
    if (pageIndex == NSNotFound) {
        return nil;
    }
    pageIndex ++;
    if (pageIndex == [_childPages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:pageIndex];
}

@end
