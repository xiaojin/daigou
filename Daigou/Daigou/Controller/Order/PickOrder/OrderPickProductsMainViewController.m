//
//  OrderPickProductsMainViewController.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderPickProductsMainViewController.h"
#import "OrderProductDockView.h"
#import "OrderProductsRightTableView.h"
#import "CommonDefines.h"
#import "OrderProductsRightTableView.h"
#import "ProductManagement.h"
#import "Product.h"
#import "ProductCategory.h"
#import "ProductCategoryManagement.h"
#import <Masonry/Masonry.h>
#import <ionicons/ionicons-codes.h>
#import <ionicons/IonIcons.h>
#import "OrderBasketPickerViewController.h"
#import "ProductWithCount.h"
#import "OrderSiderBarViewController.h"

@interface OrderPickProductsMainViewController () <DockTableViewDelegate,RightTableViewDelegate>
@property (nonatomic, strong)OrderProductDockView *dockTableView;
@property (nonatomic, strong)NSMutableArray *docksArray;
@property (nonatomic, strong)OrderProductsRightTableView *rightProductsTableView;
@property (nonatomic, weak) UILabel *totalSingular;
@property (nonatomic, weak) UIImageView *cartImage;
@property (nonatomic, strong) NSMutableArray *offsArray;
@property (nonatomic, strong) NSMutableDictionary *cartDict;
@property (nonatomic, strong) UILabel *countlbl;
@property (nonatomic, strong) OrderSiderBarViewController *sidebarVC;
@end

@implementation OrderPickProductsMainViewController

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
    //
    
    UIView *topBarView = [[UIView alloc]init];
    [topBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topBarView];
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    UIImage *menuIcon= [IonIcons imageWithIcon:ion_navicon_round iconColor:[UIColor blackColor] iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
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
    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [topBarView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuButton.mas_top);
        make.right.equalTo(topBarView.mas_right).with.offset(-10);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    [doneButton addTarget:self action:@selector(finishSelect) forControlEvents:UIControlEventTouchUpInside];

    
//    OrderProductDockView *prodDockView = [[OrderProductDockView alloc]init];
//    prodDockView.rowHeight = 50;
//    prodDockView.dockDelegate = self;
//    prodDockView.backgroundColor = RGB(255, 255, 255);
//    [prodDockView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    prodDockView.tableHeaderView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:prodDockView];
//    [prodDockView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topBarView.mas_bottom);
//        make.left.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.width.equalTo(@75);
//    }];
//    
//    _dockTableView = prodDockView;
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
    NSArray *categorys = [self fetchAllCategory];
    _docksArray = [NSMutableArray array];
    for (ProductCategory *category in categorys) {
        NSArray *products = [self fetchAllProduct:category];
        NSDictionary *dict = @{@"category":category,
                               @"products":products };
        [_docksArray addObject:dict];
        
    }
    
    _dockTableView.dockArray = _docksArray;
   [_dockTableView reloadData];
    
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
    [self.sidebarVC setBgRGB:0x000000];
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

- (void)bottomLabelClick {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

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

- (void)refreshCartCount {
    //得到词典中所有KEY值
    NSEnumerator *enumeratorKey = [_cartDict keyEnumerator];
    //遍历所有KEY的值
    NSInteger totalSingularInt = [[enumeratorKey allObjects] count];
    
    _countlbl.text = [NSString stringWithFormat:@"%ld",totalSingularInt];
}

- (void)dockClickIndexRow:(NSMutableArray *)array index:(NSIndexPath *)index indexPath:(NSIndexPath *)indexPath {
    _rightProductsTableView.rightArray=array;
    [_rightProductsTableView reloadData];
}

- (void)finishSelect {
    [self updateOrderDataBase];
    NSArray *controllers = self.navigationController.childViewControllers;
    NSInteger length = [controllers count];
    if ([[controllers objectAtIndex:length-2] isKindOfClass:[OrderBasketPickerViewController class]]) {
//        OrderBasketViewController *showBaskView =  (OrderBasketViewController *)[controllers lastObject];
        //showDetailView.customInfo = _customInfo;
        //[showBaskView refreshBasketContent];
    }
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
    [self.navigationController presentViewController:basketViewController animated:YES completion:^{
        
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

}
@end
