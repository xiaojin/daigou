//
//  MProductsViewController.m
//  Daigou
//
//  Created by jin on 28/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MProductsViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "UISearchBar+UISearchBarAccessory.h"
#import "MProductItemCell.h"
#import "OrderSiderBarViewController.h"
#import "Product.h"
#import "ProductManagement.h"
#import "BrandManagement.h"
#import "UISearchViewController.h"
#import "UIProductDetailViewController.h"

@interface MProductsViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,LLBlurSidebarDelegate,OrderSiderBarDelegate>
@property (nonatomic, strong) UICollectionView *productsCollectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) OrderSiderBarViewController *sidebarVC;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSArray *productsList;
@end
@implementation MProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBar];
    [self initWithProducts];
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 2.0f;
    flowLayout.minimumLineSpacing =0.0f;
    _productsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _productsCollectionView.delegate = self;
    _productsCollectionView.dataSource = self;
    [_productsCollectionView registerClass:[MProductItemCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_productsCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_productsCollectionView];
    [_productsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *bottomLayoutGuide = (id)self.bottomLayoutGuide;
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(bottomLayoutGuide.mas_top);
    }];
    [self initNavigationBarMenu];
    

}

- (void)initWithProducts {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    NSArray *brands = [brandManagement getBrand];
    _productsList = [NSArray array];
    if (brands != nil && [brands count]>0) {
        Brand *firstBrand = brands[0];
        ProductManagement *prodManagement = [ProductManagement shareInstance];
        _productsList = [prodManagement getProductByBrand:firstBrand];
    }
}

- (void)initNavigationBarMenu {
     UIImage *menuIcon= [IonIcons imageWithIcon:ion_navicon_round iconColor:SYSTEMBLUE iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:menuIcon style:UIBarButtonItemStylePlain target:self action:@selector(selectProductCategory)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    self.sidebarVC = [[OrderSiderBarViewController alloc] init];
    self.sidebarVC.navHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.sidebarVC.tabHeight = (kWindowHeight- CGRectGetMinY(self.tabBarController.tabBar.frame));
    self.sidebarVC.hideHeaderView = YES;
    self.sidebarVC.delegate = self;
    self.sidebarVC.orderDelegate = self;
    [self.sidebarVC setBgRGB:0x000000];
    [self.view insertSubview:self.sidebarVC.view aboveSubview:_productsCollectionView];
    [_sidebarVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayGrid = (id)self.topLayoutGuide;
        make.top.equalTo(topLayGrid.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_productsCollectionView.mas_bottom);
    }];
    // 左侧边栏结束
    //if MProductsViewController is shown by other controller
    NSInteger countNumber = [self.navigationController.childViewControllers count];
    UIBarButtonItem *rightButton = nil;
    if (countNumber > 1) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelect)];
    } else {
        rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProduct)];
    }
    self.navigationItem.rightBarButtonItem =rightButton;
}

- (NSArray *)getProductsByBrand:(Brand *)brand {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    NSArray *products =[productManagement getProductByBrand:brand];
    return products;
}

- (void) selectProductCategory {
    self.tabBarController.tabBar.hidden = YES;
    [self.sidebarVC showHideSidebar];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.sidebarVC panDetected:recoginzer];
}

- (void)sidebarDidHidden {
    //if MProductsViewController is shown by other controller
    if ([self.navigationController.childViewControllers count] > 1) return;
        self.tabBarController.tabBar.hidden = NO;
}

- (void)itemDidSelect:(Brand *)brand {
    if (brand != nil) {
        _productsList = [self getProductsByBrand:brand];
        [_productsCollectionView reloadData];
    }
    [self.sidebarVC showHideSidebar];
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    [_searchBar sizeToFit];
}

#pragma mark - Sort & Search
- (void)searchBarTap {
    UISearchViewController *searchController =[[UISearchViewController alloc]init];
    UINavigationController *searchNav = [[UINavigationController alloc]initWithRootViewController:searchController];
    [self presentViewController:searchNav animated:NO completion:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self searchBarTap];
    return NO;
}

- (void)search:(NSString *)query {
    NSString *normalisedQuery = [NSString stringWithFormat:@"*%@*", [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ or function LIKE[cd] %@", normalisedQuery,normalisedQuery];
    
    _productsList = [_productsList filteredArrayUsingPredicate:predicate];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"search button clicked");
}

#pragma mark -- UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_productsList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    MProductItemCell *collectionCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    collectionCell.backgroundColor = [UIColor whiteColor];
    collectionCell.product = [_productsList objectAtIndex:indexPath.row];
    return collectionCell;

}
#pragma mark -- UICollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWindowWidth-4)/3, kWindowWidth/3 +10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = [_productsList objectAtIndex:indexPath.row];
    if ([self.navigationController.childViewControllers count] > 1) {
        [_delegate didSelectProduct:product];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIProductDetailViewController *productDetailViewController = [[UIProductDetailViewController alloc]init];
        productDetailViewController.product = product;
        productDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productDetailViewController animated:NO];
    }

}

#pragma mark -- ProductHandler 
- (void)addNewProduct {
    UIProductDetailViewController *productDetailViewController = [[UIProductDetailViewController alloc]init];
    productDetailViewController.product = [Product new];
    productDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailViewController animated:NO];
}

- (void) finishSelect {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
