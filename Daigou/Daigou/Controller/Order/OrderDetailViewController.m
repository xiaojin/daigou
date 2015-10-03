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
#import <UIAlertView-Blocks/RIButtonItem.h>
#import <UIAlertView-Blocks/UIActionSheet+Blocks.h>
#import "OrderMainInfoViewController.h"
#import "OrderBasketViewController.h"
#import "OrderDeliveryStatusViewController.h"
#import "OrderItemManagement.h"
#import "OProductItem.h"
#import "CustomInfo.h"
#import "OrderItem.h"
@interface OrderDetailViewController  () <UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *orderDetailMainScrollView;
@property (nonatomic, strong) UIView *subTabView;
@property (nonatomic, strong) NSArray *subTabString;
@property (nonatomic, strong) NSArray *statusLbls;
@property (nonatomic, strong) NSDictionary *products;
@property (nonatomic, strong) OrderMainInfoViewController *addNewOrderViewController;
@property (nonatomic, strong) OrderBasketViewController *orderBasketViewController;
@property (nonatomic, strong) OrderDeliveryStatusViewController *deliveryStatusViewController;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *saveOrderButton;
@property (nonatomic, strong) UIButton *toDispatchButton;
@property (nonatomic, strong) UIButton *toShippedButton;
@property (nonatomic, strong) UIButton *toDeliveredButton;
@property (nonatomic, strong) UIButton *toDoneButton;
@property (nonatomic, strong) UIButton *DoneButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSArray *productsInPurchseList;
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
    [self checkDidFinishPurchasing];
    [self initNavigateBar];
    [self addBottomView];
    [self initOrderData];
    [self setPageIndicator];
    [self initScrollView];
}

- (void)checkDidFinishPurchasing {
    if (_orderItem != nil && _orderItem.statu == PURCHASED) {
        OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
        NSArray *productsArray = [orderItemManagement getOrderProductsByOrderId:_orderItem.oid];
        if ([productsArray count] !=0) {
              NSArray *filterProducts =[productsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"statu == %d",PRODUCT_PURCHASE]];
            if ([filterProducts count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单状态"
                                                                    message:@"所有物品已采购完毕"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"好的", nil];
                alertView.tag = PRODUCTDETAILIVIEW + 20;
                [alertView show];
                // 更改状态到采购
            }
            
        }
    }
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
    _saveOrderButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_saveOrderButton.titleLabel setFont:Font(14)];
    [_saveOrderButton setBackgroundColor:THEMECOLOR];
    [_saveOrderButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self initStatusButton];
    [_bottomView addSubview:_saveOrderButton];
    [_saveOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_bottomView.mas_left);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
    _saveOrderButton = [self makeStatusUpdateButton:@"保存订单" withButtonAction:@selector(saveOrder)];
    _toDispatchButton = [self makeStatusUpdateButton:@"采购完成,待发货" withButtonAction:@selector(changeStatusToUNDISPATCHED)];
    _toShippedButton = [self makeStatusUpdateButton:@"清点发货" withButtonAction:@selector(changeStatusToSHIPPED)];
    _toDeliveredButton = [self makeStatusUpdateButton:@"确认收货" withButtonAction:@selector(changeStatusToDELIVERD)];
    _toDoneButton = [self makeStatusUpdateButton:@"已完成" withButtonAction:@selector(changeStatusToDONE)];
    _DoneButton = [self makeStatusUpdateButton:@"" withButtonAction:nil];
    [self initStatusButton];
    
    _shareButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_shareButton setTitle:@"分享订单" forState:UIControlStateNormal];
    [_shareButton.titleLabel setFont:Font(14)];
    [_shareButton setBackgroundColor:[UIColor redColor]];
    [_shareButton.titleLabel setTextColor:[UIColor blackColor]];
    
    [_bottomView addSubview:_shareButton];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_saveOrderButton.mas_right);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
    _moreButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton.titleLabel setFont:Font(14)];
    [_moreButton setBackgroundColor:[UIColor orangeColor]];
    [_moreButton addTarget:self action:@selector(showPopupView) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_moreButton];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_shareButton.mas_right);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    
}

- (UIButton *)makeStatusUpdateButton:(NSString *)title withButtonAction:(SEL)buttonAction {
     UIButton *updateButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [updateButton.titleLabel setFont:Font(14)];
    [updateButton setBackgroundColor:THEMECOLOR];
    [updateButton.titleLabel setTextColor:[UIColor whiteColor]];
    [updateButton setTitle:title forState:UIControlStateNormal];
    [updateButton addTarget:self action:buttonAction forControlEvents:UIControlEventTouchUpInside];
    updateButton.hidden = YES;
    [_bottomView addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.left.equalTo(_bottomView.mas_left);
        make.bottom.equalTo(_bottomView.mas_bottom);
        make.width.equalTo(@(kWindowWidth/3));
    }];
    return updateButton;
}

- (void)initStatusButton {
    if (_orderItem.statu == PURCHASED) {
        if (_orderItem.oid == 0) {
            _saveOrderButton.hidden = NO;
        } else {
            _toDispatchButton.hidden = NO;
        }
        self.title = @"采购中";
    } else if (_orderItem.statu == UNDISPATCH) {
        _toShippedButton.hidden = NO;
        self.title = @"待发货";
    } else if (_orderItem.statu == SHIPPED ) {
        _toDeliveredButton.hidden = NO;
        self.title = @"运输中";
    } else if (_orderItem.statu == DELIVERD) {
        _toDoneButton.hidden = NO;
        self.title = @"已收货";
    } else if (_orderItem.statu == DONE) {
        _DoneButton.hidden = NO;
        self.title = @"已完成";
    }
}

- (void)updateButtonToStatus:(OrderStatus)status {
    if (status == PURCHASED) {
        if (_orderItem.oid == 0) {
            [self hideAllButton];
            _saveOrderButton.hidden = NO;
        } else {
            [self hideAllButton];
            _toDispatchButton.hidden = NO;
        }
        self.title = @"采购中";
    } else if (status == UNDISPATCH) {
        [self hideAllButton];
        _toShippedButton.hidden = NO;
        self.title = @"待发货";
    } else if (status == SHIPPED ) {
        [self hideAllButton];
        _toDeliveredButton.hidden = NO;
        self.title = @"运输中";
    } else if (status== DELIVERD) {
        [self hideAllButton];
        _toDoneButton.hidden = NO;
        self.title = @"已收货";
    } else if (status == DONE) {
        [self hideAllButton];
        _DoneButton.hidden = NO;
        self.title = @"已完成";
    }
}

- (void)hideAllButton {
    _saveOrderButton.hidden = YES;
    _toDispatchButton.hidden = YES;
    _toShippedButton.hidden = YES;
    _toDeliveredButton.hidden = YES;
    _toDoneButton.hidden = YES;
    _DoneButton.hidden = YES;
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

- (void)showPopupView {
    if (IOS8_OR_ABOVE) {
        [self menuCameraPhotoiOS8AndAbove];
    } else {
        [self menuCameraPhotoBelowiOS8];
    }
}


- (void)menuCameraPhotoiOS8AndAbove {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelOrderBtn = [UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                     
                                                           }];
    UIAlertAction* viewDeliveryStatusBtn = [UIAlertAction actionWithTitle:@"查看物流" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                           
                                                         }];
    UIAlertAction* checkOrderProductsBtn = [UIAlertAction actionWithTitle:@"清点订单商品" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                      }];
    __weak id weakSelf = self;
    [alert addAction:cancelOrderBtn];
    [alert addAction:viewDeliveryStatusBtn];
    [alert addAction:checkOrderProductsBtn];
    [alert addAction:cancelBtn];
    alert.popoverPresentationController.sourceRect = self.view.frame;
    alert.popoverPresentationController.sourceView = weakSelf;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)menuCameraPhotoBelowiOS8 {
    RIButtonItem *cancelOrderBtn = [RIButtonItem itemWithLabel:@"取消订单" action:^{
        
    }];
    RIButtonItem *viewDeliveryStatusBtn = [RIButtonItem itemWithLabel:@"查看物流" action:^{
        
    }];
    RIButtonItem *checkOrderProductsBtn = [RIButtonItem itemWithLabel:@"清点订单商品" action:^{
        
    }];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     cancelButtonItem:[RIButtonItem itemWithLabel:@"取消"]
                                                destructiveButtonItem: nil
                                                     otherButtonItems:cancelOrderBtn, viewDeliveryStatusBtn,checkOrderProductsBtn,nil];
    
    [actionSheet showFromRect:self.view.frame inView:self.view animated:YES];
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
        self.products = [NSDictionary dictionary];
    } else {
        self.products = [self filterProductByProductId:[itemManagement getOrderProductsByOrderId:self.orderItem.oid]];
    }
}

- (NSDictionary *)filterProductByProductId:(NSArray *)productList {
    NSMutableDictionary *productsDict = [NSMutableDictionary dictionary];
    for (int i =0; i < [productList count]; i++) {
        OProductItem *oProductItem = productList[i];
        NSArray *keys = [productsDict allKeys];
        if ([keys containsObject:[NSNumber numberWithInteger:oProductItem.productid]]) {
            NSMutableArray *products = [productsDict objectForKey:[NSNumber numberWithInteger:oProductItem.productid]];
            [products addObject:oProductItem];
            [productsDict setObject:products forKey:[NSNumber numberWithInteger:oProductItem.productid]];
        } else {
            NSMutableArray *products = [NSMutableArray array];
            [products addObject:oProductItem];
            [productsDict setObject:products forKey:[NSNumber numberWithInteger:oProductItem.productid]];
        }
    }
    return productsDict;
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
        if (_orderItem.oid ==0) {
            _orderItem.noteImage = [[NSUserDefaults standardUserDefaults] objectForKey:PHOTOURLS];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:PHOTOURLS];
            _orderItem.statu = PURCHASED;
        }
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
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self missingCustomInfoAlertView];
    }
}

- (void)missingCustomInfoAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单信息" message:@"缺少客户信息"
                                                       delegate:self
                                              cancelButtonTitle:@"继续编辑"
                                              otherButtonTitles:@"放弃", nil];
    alertView.tag = PRODUCTDETAILIVIEW +10;
    [alertView show];
}

- (void)missingCustomInfoHandler {
    // clear temp saved data when user create a new orderitem
    OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
    [orderItemManagement deleteTemperOrderItems];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PHOTOURLS];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag - PRODUCTDETAILIVIEW)  == 10) {
        if (buttonIndex == 1) {
           [self missingCustomInfoHandler];
        }
    } else if ((alertView.tag - PRODUCTDETAILIVIEW)  == 20) {
        [self saveToUNDISPATCHED];
    } else if ((alertView.tag - PRODUCTDETAILIVIEW)  == 30) {
        if (buttonIndex == 1) [self saveToUNDISPATCHED];
    }
}

- (void)backFromDetail {
    [self saveOrder];
}

- (void)changeStatusToUNDISPATCHED {
    //if do not have stock in side
    //then update all product to in_stock
    //otherwise give up to save it as purchase
    [self checkPRUCHSEProductStatus];
    if ([_productsInPurchseList count]!=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单状态"
                                                            message:@"确认已采购完成所有商品"
                                                           delegate:self
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles: @"确认",nil];
        alertView.tag = PRODUCTDETAILIVIEW + 30;
        [alertView show];
    } else {
        _orderItem.statu = UNDISPATCH;
        [self saveOrder];
        //update all product to in_stock
    }
}

- (void)saveToUNDISPATCHED {
    OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
    for (OProductItem *prodItem in _productsInPurchseList) {
        prodItem.statu = PRODUCT_INSTOCK;
    }
    [orderItemManagement updateProductItemWithProductItem:_productsInPurchseList withNull:NO];
    _orderItem.statu = UNDISPATCH;
    [self saveOrder];
}



- (void)changeStatusToSHIPPED {
    _orderItem.statu = SHIPPED;
    [self saveOrder];
}

- (void)changeStatusToDELIVERD {
    _orderItem.statu = DELIVERD;
    [self saveOrder];
}

- (void)changeStatusToDONE {
    _orderItem.statu = DONE;
    [self saveOrder];
}

- (void)checkPRUCHSEProductStatus {
    OrderItemManagement *orderItemManagement = [OrderItemManagement shareInstance];
    NSArray *products = [orderItemManagement getOrderProductsByOrderId:_orderItem.oid];
    _productsInPurchseList = [products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"statu == %d",PRODUCT_PURCHASE]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self scrollToStaus:page];
}
@end
