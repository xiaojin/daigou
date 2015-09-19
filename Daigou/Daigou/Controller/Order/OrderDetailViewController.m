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
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "OrderMainInfoViewController.h"
#import "OrderBasketViewController.h"
#import "OrderDeliveryStatusViewController.h"
#import "OrderItemManagement.h"
#import "OProductItem.h"
#import "CustomInfo.h"
#import "OrderItem.h"

@interface OrderDetailViewController  () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *orderDetailMainScrollView;
@property (nonatomic, strong) UIView *subTabView;
@property (nonatomic, strong) NSArray *subTabString;
@property (nonatomic, strong) NSArray *statusLbls;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) OrderMainInfoViewController *addNewOrderViewController;
@property (nonatomic, strong) OrderBasketViewController *orderBasketViewController;
@property (nonatomic, strong) OrderDeliveryStatusViewController *deliveryStatusViewController;
@property (nonatomic, strong) UIView *bottomView;
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
    [self initNavigateBar];
    [self addBottomView];
    [self initOrderData];
    [self setPageIndicator];
    [self initScrollView];
}

- (void)initNavigateBar {
    UIImage *backImage = [IonIcons imageWithIcon:ion_ios_arrow_left size:26 color:SYSTEMBLUE];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 33)];
    [backButton addTarget:self action:@selector(backFromDetail) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 0)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [backButton setTitle:@"订单" forState:UIControlStateNormal];
    [backButton setTitleColor:SYSTEMBLUE forState:UIControlStateNormal];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)addBottomView {
    CGFloat topOff = self.tabBarController.tabBar.frame.size.height;
    _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(topOff));
    }];
    UIButton *saveOrder = [[UIButton alloc]initWithFrame:CGRectZero];
    [saveOrder setTitle:@"保存订单" forState:UIControlStateNormal];
    [saveOrder.titleLabel setFont:Font(14)];
    [saveOrder setBackgroundColor:THEMECOLOR];
    [saveOrder.titleLabel setTextColor:[UIColor whiteColor]];
    [saveOrder addTarget:self action:@selector(saveOrder) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:saveOrder];
    [saveOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_bottomView.mas_left);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [shareButton setTitle:@"分享订单" forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:Font(14)];
    [shareButton setBackgroundColor:[UIColor redColor]];
    [shareButton.titleLabel setTextColor:[UIColor blackColor]];
    
    [_bottomView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(saveOrder.mas_right);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:Font(14)];
    [moreButton setBackgroundColor:[UIColor orangeColor]];
    [_bottomView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(shareButton.mas_right);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
}

- (void)initScrollView {
    _orderDetailMainScrollView = [[UIScrollView alloc] initWithFrame: CGRectZero];
    _orderDetailMainScrollView.delegate = self;
    [self.view addSubview:_orderDetailMainScrollView];
    [_orderDetailMainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_subTabView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    UIView *container = [UIView new];
    [_orderDetailMainScrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_orderDetailMainScrollView);
        make.height.equalTo(_orderDetailMainScrollView);
    }];
    
    [self setProductDetailController];
    [self setProdcutCollectionController];
    [self setProductMailingInfoController];
    [self.orderDetailMainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (index == 0) {
        [_addNewOrderViewController refreshMainInfo];
    }
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
        self.products = [itemManagement getOrderItemsGroupbyProductidByOrderId:self.orderItem.oid];
    }
}

#pragma mark -initControllers

- (void) setProductDetailController {
//    if (self.orderItem.parentoid == 0) {
//        _addNewOrderViewController = [[OrderMainInfoViewController alloc]
//                                      init];
//    } else {
        _addNewOrderViewController = [[OrderMainInfoViewController alloc]
                                      initWithOrderItem:self.orderItem withClientDetail:self.customInfo];
//    }
    
    
    _addNewOrderViewController.view.tag = ORDERDETAILTAG +0;
    [self addChildViewController:_addNewOrderViewController];
    [self.orderDetailMainScrollView addSubview:_addNewOrderViewController.view];
    [_addNewOrderViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderDetailMainScrollView);
        make.top.equalTo(_subTabView.mas_bottom);
        make.height.equalTo(self.orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];
}

// add some comment


- (void) setProdcutCollectionController {
    _orderBasketViewController = [[OrderBasketViewController alloc]initwithOrderItem:self.orderItem withGroupOrderProducts:self.products];
    _orderBasketViewController.view.tag = ORDERDETAILTAG +1;
    [self addChildViewController:_orderBasketViewController];
    [self.orderDetailMainScrollView addSubview:_orderBasketViewController.view];
    [_orderBasketViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addNewOrderViewController.view.mas_right);
        make.top.equalTo(_subTabView.mas_bottom);
        make.height.equalTo(self.orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];
}


- (void) setProductMailingInfoController {
    _deliveryStatusViewController = [[OrderDeliveryStatusViewController alloc]init];
    _deliveryStatusViewController.receiverInfo = _customInfo;
    _deliveryStatusViewController.orderItem = _orderItem;
    _deliveryStatusViewController.view.tag = ORDERDETAILTAG +2;
    [self addChildViewController:_deliveryStatusViewController];
    [self.orderDetailMainScrollView addSubview:_deliveryStatusViewController.view];
    [_deliveryStatusViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderBasketViewController.view.mas_right);
        make.top.equalTo(_subTabView.mas_bottom);
        make.height.equalTo(self.orderDetailMainScrollView);
        make.width.equalTo(self.view);
    }];

}
#pragma mark SaveOrder
- (void)saveOrder {
    if (_addNewOrderViewController.customInfo.cid != 0 ) {
        //SAVE MAIN INFO
        [_addNewOrderViewController saveMainInfo];
        _orderItem.clientid = _addNewOrderViewController.customInfo.cid;
        _orderItem.subtotal = _addNewOrderViewController.orderItem.subtotal;
        _orderItem.discount = _addNewOrderViewController.orderItem.discount;
        _orderItem.totoal = _addNewOrderViewController.orderItem.totoal;
        _orderItem.othercost =_addNewOrderViewController.orderItem.othercost;
        _orderItem.profit = _addNewOrderViewController.orderItem.profit;
        _orderItem.note = _addNewOrderViewController.orderItem.note;
        
        //SAVE DELIVERY STATUS
        [_deliveryStatusViewController saveDeliveryStatus];
        CustomInfo *receiverInfo = _deliveryStatusViewController.receiverInfo;
        _orderItem.expressid = _deliveryStatusViewController.express.eid;
        _orderItem.barcode = _deliveryStatusViewController.deliverybarCode;
        _orderItem.delivery = _deliveryStatusViewController.deliveryPrice;
        _orderItem.reviever = receiverInfo.name;
        _orderItem.address = receiverInfo.address;
        _orderItem.phonenumber = receiverInfo.phonenum;
        _orderItem.postcode = receiverInfo.postcode;
        OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
        [orderItemManagement updateOrderItem:_orderItem];
        
        if (_orderItem.oid ==0) {
            NSInteger rowid = [orderItemManagement getLastInsertOrderId];
            [_orderBasketViewController saveBasketInfoWithOrderId:rowid];
        }
        
    } else {
        OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
        [orderItemManagement deleteTemperOrderItems];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backFromDetail {
    [self saveOrder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self scrollToStaus:page];
}
@end
