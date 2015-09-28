//
//  OrderPickProductsMainViewController.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderPickProductsMainViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/ionicons-codes.h>
#import <ionicons/IonIcons.h>
#import "OrderProductsRightTableView.h"
#import "CommonDefines.h"
#import "ProductManagement.h"
#import "ProductCategoryManagement.h"
#import "Product.h"
#import "ProductCategory.h"
#import "OrderBasketPickerViewController.h"
#import "ProductWithCount.h"
#import "OrderSiderBarViewController.h"
#import "OrderItemManagement.h"
#import "OProductItem.h"

@interface OrderPickProductsMainViewController () <RightTableViewDelegate,OrderSiderBarDelegate>
@property (nonatomic, strong)NSMutableArray *docksArray;
@property (nonatomic, strong)OrderProductsRightTableView *rightProductsTableView;
@property (nonatomic, strong) UILabel *totalSingular;
@property (nonatomic, strong) UIImageView *cartImage;
@property (nonatomic, strong) NSMutableArray *offsArray;
@property (nonatomic, strong) NSMutableDictionary *cartDict;
@property (nonatomic, strong) UILabel *countlbl;
@property (nonatomic, strong) OrderSiderBarViewController *sidebarVC;
@property (nonatomic, strong) OrderItem *order;
@end

@implementation OrderPickProductsMainViewController

- (instancetype)initWithOrderItem:(OrderItem*)ordeItem {
    _order = ordeItem;
    return [self init];
}
- (instancetype)init {
    if (self = [super init]) {
        [self removeCartProductFromCache];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableDictionary *cartProduct = [self getCartProductFromCache];
    if (cartProduct != nil) {
        _cartDict = cartProduct;
        [self refreshCartCount];
    } else {
        _cartDict = [NSMutableDictionary dictionary];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topBarView = [[UIView alloc]init];
    [topBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topBarView];
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    UIImage *menuIcon= [IonIcons imageWithIcon:ion_navicon_round iconColor:SYSTEMBLUE iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setImage:menuIcon forState:UIControlStateNormal];
    [topBarView addSubview:menuButton];
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBarView.mas_top).with.offset(28);
        make.left.equalTo(topBarView.mas_left).with.offset(10);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    [menuButton addTarget:self action:@selector(showProductsList) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [[UIButton alloc]init];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:SYSTEMBLUE forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [topBarView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuButton.mas_top);
        make.right.equalTo(topBarView.mas_right).with.offset(-10);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    [doneButton addTarget:self action:@selector(finishSelect) forControlEvents:UIControlEventTouchUpInside];

    OrderProductsRightTableView *rightTableView = [[OrderProductsRightTableView alloc]init];
    rightTableView.rowHeight = 90;
    rightTableView.rightDelegate = self;
    rightTableView.backgroundColor = RGB(238, 238, 238);
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:rightTableView];
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBarView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _rightProductsTableView = rightTableView;
    
    NSArray *categories = [self fetchAllCategory];
    NSArray *productUnderCategory = [self fetchAllProduct:categories[0]];
    [self showSelectedProducts:productUnderCategory];

    UIButton *cartButton = [[UIButton alloc]init];
    [self.view addSubview:cartButton];
    [cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    UIImage *cart = [IonIcons imageWithIcon:ion_ios_cart_outline iconColor:[UIColor blackColor] iconSize:35.0f imageSize:CGSizeMake(35.0f, 35.0f)];
    UIImageView *carView = [[UIImageView alloc]initWithImage:cart];
    [cartButton addSubview:carView];
    [carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cartButton);
        make.top.equalTo(cartButton);
        make.right.equalTo(cartButton);
        make.bottom.equalTo(cartButton);
    }];
    UILabel *countlbl = [[UILabel alloc]init];
    [cartButton addSubview:countlbl];
    [countlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cartButton);
        make.top.equalTo(cartButton);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [countlbl setText:@"0"];
    countlbl.layer.masksToBounds = YES;
    countlbl.layer.cornerRadius = 7.5;
    countlbl.textAlignment = NSTextAlignmentCenter;
    countlbl.backgroundColor = [UIColor redColor];
    [countlbl setTextColor:[UIColor whiteColor]];
    [countlbl setFont:[UIFont systemFontOfSize:12.0f]];
    _countlbl = countlbl;
    [cartButton addTarget:self action:@selector(showCartContent) forControlEvents:UIControlEventTouchUpInside];
    
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    
    self.sidebarVC = [[OrderSiderBarViewController alloc] init];
    self.sidebarVC.orderDelegate = self;
    [self.sidebarVC setBgRGB:0x000000];
    self.sidebarVC.hideHeaderView = NO;
    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = self.view.bounds;
    // 左侧边栏结束
}


- (void) showProductsList {
    [self.sidebarVC showHideSidebar];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.sidebarVC panDetected:recoginzer];
}
#pragma mark - OrderProductsRightTableView
- (void)quantity:(NSInteger)quantity
           money:(NSInteger)money
         product:(Product *)product{
    NSString *prodId = [NSString stringWithFormat:@"%ld",(long)product.pid];
    ProductWithCount *productWithCount = nil;
    if ([_cartDict valueForKey:prodId]) {
        productWithCount = [_cartDict objectForKey:prodId];
        productWithCount.productNum = productWithCount.productNum + quantity;
    } else {
        productWithCount = [ProductWithCount new];
        productWithCount.product = product;
        productWithCount.productNum = quantity;
    }
    [_cartDict setObject:productWithCount forKey:prodId];
    [self refreshCartCount];
}

#pragma mark - OrderSideBarDelegate
- (void)itemDidSelect:(Brand *)brand {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    NSArray *products =[productManagement getProductByBrand:brand];
    _rightProductsTableView.rightArray = products;
    [_rightProductsTableView reloadData];
    [self.sidebarVC showHideSidebar];
}

- (void)bottomLabelClick {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)refreshCartCount {
    __block NSInteger totalSingularInt = 0;
    [_cartDict enumerateKeysAndObjectsUsingBlock:^(NSString *prodId, ProductWithCount *productWithCount, BOOL *stop) {
        totalSingularInt = totalSingularInt + productWithCount.productNum;
    }];
    _countlbl.text = [NSString stringWithFormat:@"%ld",(long)totalSingularInt];
}

- (void)showSelectedProducts:(NSArray *)array {
    _rightProductsTableView.rightArray = array;
    [_rightProductsTableView reloadData];
}

- (void)finishSelect {
    if (_order.oid !=0 && _order.statu == UNDISPATCH) {
        //TODO:如果添加订单物品，需要将订单状态改为0号状态
        //TODO:如果减少订单物品，则需要减少订单物品的数量，优先修改采购数量，或者需要修改到库存中去
        OrderItemManagement *orderManagement = [OrderItemManagement shareInstance];
        _order.statu = PURCHASED;
        [orderManagement updateOrderItem:_order];
    }
    [self updateOrderDataBase];
    [_delegate finishPickProducts];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showCartContent
{
    NSMutableArray *products = [NSMutableArray array];
    [_cartDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [products addObject:obj];
    }];
    [self storeCartProductInCache];
    OrderBasketPickerViewController *basketViewController = [[OrderBasketPickerViewController alloc]initWithProducts:products];
    [self presentViewController:basketViewController animated:NO completion:^{
        
    }];
}

- (NSArray *)fetchAllProduct:(ProductCategory *)category {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    return [productManagement getProductByCategory:category];
}

- (NSArray *)fetchAllCategory {
    ProductCategoryManagement *categoryManage = [ProductCategoryManagement shareInstance];
    return [categoryManage getCategory];
}

- (NSMutableDictionary *)getCartProductFromCache {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cartDict = [userDefaults objectForKey:CARTPRODUCTSCACHE];
    NSMutableDictionary *newCartDict = [NSMutableDictionary dictionary];
    [cartDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        ProductWithCount *carProduct = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        [newCartDict setObject:carProduct forKey:key];
    }];
    
    return newCartDict;
}

- (void)storeCartProductInCache {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [_cartDict enumerateKeysAndObjectsUsingBlock:^(id key, ProductWithCount * product, BOOL *stop) {
        NSData *productEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:product];
        [_cartDict setObject:productEncodedObject forKey:key];
    }];
    [userDefaults setObject:_cartDict forKey:CARTPRODUCTSCACHE];
    [userDefaults synchronize];
}

- (void)removeCartProductFromCache {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:CARTPRODUCTSCACHE];
}

- (void)updateOrderDataBase {
    OrderItemManagement *orderManagement = [OrderItemManagement shareInstance];
    NSArray *orderProducts = [orderManagement getOrderProductsByOrderId:_order.oid];
    NSArray *unOrderProducts = [orderManagement getUnOrderProducItemByStatus:PRODUCT_INSTOCK];
    [_cartDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ProductWithCount *productWithCount, BOOL *stop) {
        //TODO:现存数据库中找到库存货
        //TODO:如果有库存，就优先更新库存货
        //TODO:
        NSArray *filterProducts =[orderProducts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"productid == %d",[key intValue]]];
        NSArray *filterUnOrderProducts = [unOrderProducts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"productid == %d",[key intValue]]];
        NSInteger countNeedCreate = -1;
        if ([filterUnOrderProducts count] !=0) {
            //修改库存的数量
            NSMutableArray *orders = [NSMutableArray array];
            NSInteger usedCount = productWithCount.productNum > [filterUnOrderProducts count] ? [filterUnOrderProducts count] : productWithCount.productNum ;
            for (int i = 0; i < usedCount ; i++) {
                OProductItem *item = filterUnOrderProducts[i];
                item.orderid = _order.oid;
                [orders addObject:item];
            }
            
            countNeedCreate = labs(((NSInteger)[filterUnOrderProducts count] - productWithCount.productNum));
            [orderManagement updateProductItemWithProductItem:orders];
        }
        
        NSMutableArray *orderProducts = [NSMutableArray array];
        if (countNeedCreate < 0) {
            countNeedCreate = productWithCount.productNum;
        }
        if ([filterProducts count] != 0) {
            for (int x = 0; x < countNeedCreate; x++) {
                [orderProducts addObject:[filterProducts lastObject]];
            }
        } else {
            Product *product = productWithCount.product;
            for (int x = 0; x < countNeedCreate; x++) {
                OProductItem *productItem = [[OProductItem alloc]initOProductItemWithProduct:product];
                productItem.orderid = _order.oid;
                [orderProducts addObject:productItem];
            }
        }
        [orderManagement insertOrderProductItems:orderProducts];
    }];
}
@end
