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

@interface MProductsViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *productsCollectionView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) OrderSiderBarViewController *sidebarVC;

@end
@implementation MProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBar];
    _products = [NSArray arrayWithObjects:@1,@2,@3, nil];
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
        make.top.equalTo(_searchBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(bottomLayoutGuide.mas_top);
    }];
    [self initNavigationBarMenu];

}

- (void)initNavigationBarMenu {
     UIImage *menuIcon= [IonIcons imageWithIcon:ion_navicon_round iconColor:[UIColor blackColor] iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:menuIcon style:UIBarButtonItemStylePlain target:self action:@selector(selectProductCategory)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    
    self.sidebarVC = [[OrderSiderBarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    //[self.view addSubview:self.sidebarVC.view];
    [self.view insertSubview:self.sidebarVC.view aboveSubview:_productsCollectionView];

    [_sidebarVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //UIView *topLayGrid = (id)self.topLayoutGuide;
        UIView *bottomLayGrid = (id)self.bottomLayoutGuide;
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(bottomLayGrid.mas_top);
    }];
    // 左侧边栏结束
}

- (void) selectProductCategory {
    [self.sidebarVC showHideSidebar];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.sidebarVC panDetected:recoginzer];
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (id)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Sort & Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
//[self.viewModel filterByString:searchText.uppercaseString];
    } else {
       // [self.viewModel cancelFilter];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
}

#pragma mark -- UICollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
     MProductItemCell *collectionCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    collectionCell.backgroundColor = [UIColor whiteColor];
    collectionCell.productTitle = @"纽乐护肝宝胶囊100粒";
    return collectionCell;

}
#pragma mark -- UICollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWindowWidth-4)/3, kWindowWidth/3 +10);
}

@end
