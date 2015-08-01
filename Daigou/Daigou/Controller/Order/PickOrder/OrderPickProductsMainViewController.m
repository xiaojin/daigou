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

@interface OrderPickProductsMainViewController () <DockTableViewDelegate,RightTableViewDelegate>
@property (nonatomic, strong)OrderProductDockView *dockTableView;
@property (nonatomic, strong)NSMutableArray *docksArray;
@property (nonatomic, strong)OrderProductsRightTableView *rightProductsTableView;
@property (nonatomic, weak) UILabel *totalSingular;
@property (nonatomic, weak) UIImageView *cartImage;
@property (nonatomic, strong) NSMutableArray *offsArray;
@property (nonatomic, strong) NSMutableDictionary *cartDict;
@property (nonatomic, strong) NSMutableDictionary *cartProductDict;
@property (nonatomic, strong) UILabel *countlbl;
@end

@implementation OrderPickProductsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    OrderProductDockView *prodDockView = [[OrderProductDockView alloc]init];
    prodDockView.rowHeight = 50;
    prodDockView.dockDelegate = self;
    prodDockView.backgroundColor = RGB(255, 255, 255);
    [prodDockView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:prodDockView];
    [prodDockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@75);
    }];
    
    _dockTableView = prodDockView;
    OrderProductsRightTableView *rightTableView = [[OrderProductsRightTableView alloc]init];
    rightTableView.rowHeight = 90;
    rightTableView.rightDelegate = self;
    rightTableView.backgroundColor = RGB(238, 238, 238);
    rightTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:rightTableView];
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dockTableView.mas_top);
        make.left.equalTo(self.dockTableView.mas_right);
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.translucent = NO;
    
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
   

    _cartDict = [NSMutableDictionary dictionary];
    _cartProductDict = [NSMutableDictionary dictionary];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishSelect)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
// 结算栏
//    UIView *bottomView = [[UIView alloc]
//                          initWithFrame:(CGRect){0, kWindowHeight - 50, kWindowWidth, 50}];
//    bottomView.backgroundColor = UIColorRGBA(29, 29, 29, 1);
//    [self.view addSubview:bottomView];
//    
//    BALabel *bottomLabel = [[BALabel alloc]
//                            initWithFrame:(CGRect){kWindowWidth - 55 - 10, 50 / 2 - 24 / 2, 55, 24}];
//    bottomLabel.text = @"请选购";
//    bottomLabel.textColor = [UIColor whiteColor];
//    bottomLabel.textAlignment = NSTextAlignmentCenter;
//    bottomLabel.font = Font(13);
//    bottomLabel.backgroundColor = [UIColor lightGrayColor];
//    bottomLabel.layer.masksToBounds = YES;
//    bottomLabel.layer.cornerRadius = 6;
//    bottomLabel.layer.borderWidth = 1;
//    bottomLabel.userInteractionEnabled = NO;
//    [bottomLabel addTarget:self
//                    action:@selector(bottomLabelClick)
//          forControlEvents:BALabelControlEventTap];
//    bottomLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
//    [bottomView addSubview:bottomLabel];
//    _bottomLabel = bottomLabel;
//    ion_ios_cart_outline
//    UIImageView *cartImage =
//    [[UIImageView alloc] initWithFrame:(CGRect){10, 5, 40, 40}];
//    cartImage.image = [UIImage imageNamed:@"Home_Cart.jpg"];
//    [bottomView addSubview:cartImage];
//    _cartImage = cartImage;
//    _quantityInt = 0;
//    
//    UILabel *totalPrice = [[UILabel alloc]
//                           initWithFrame:(CGRect){CGRectGetMaxX(cartImage.frame) + 20,
//                               50 / 2 - 16 / 2, 200, 16}];
//    
//    totalPrice.text = @"￥0";
//    totalPrice.textColor = [UIColor whiteColor];
//    totalPrice.font = Font(16);
//    [bottomView addSubview:totalPrice];
//    _totalPrice = totalPrice;
//    
//    UILabel *totalSingular =
//    [[UILabel alloc] initWithFrame:(CGRect){35, 5, 15, 15}];
//    totalSingular.text = @"0";
//    totalSingular.hidden = YES;
//    totalSingular.layer.masksToBounds = YES;
//    totalSingular.layer.cornerRadius = 7.5;
//    totalSingular.textAlignment = NSTextAlignmentCenter;
//    totalSingular.backgroundColor = [UIColor redColor];
//    totalSingular.textColor = [UIColor whiteColor];
//    totalSingular.font = Font(13);
//    [bottomView addSubview:totalSingular];
//    _totalSingular = totalSingular;
//    
//    _key = [NSMutableArray array];
}

- (void)bottomLabelClick {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)quantity:(NSInteger)quantity
           money:(NSInteger)money
             product:(Product *)product{
    NSInteger prodId = product.pid;
    NSInteger addend = quantity;
    ProductWithCount *productWithCount = [ProductWithCount new];
    productWithCount.product = product;
    productWithCount.productNum = addend;
    [_cartDict setObject:productWithCount forKey:@(prodId)];
    //得到词典中所有KEY值
    NSEnumerator *enumeratorKey = [_cartDict keyEnumerator];
    //遍历所有KEY的值
    NSInteger totalSingularInt = 0;
    for (NSObject *object in enumeratorKey) {
        NSInteger number = [(ProductWithCount *)_cartDict[object] productNum];
        if (number != 0) {
            totalSingularInt += 1;
        } else {
            [_cartDict removeObjectForKey:object];
        }
    }
    _countlbl.text = [NSString stringWithFormat:@"%ld",totalSingularInt];
}

- (void)dockClickIndexRow:(NSMutableArray *)array index:(NSIndexPath *)index indexPath:(NSIndexPath *)indexPath {

//    [_rightProductsTableView setContentOffset:_rightProductsTableView.contentOffset animated:NO];
//    _offsArray[index.row] =NSStringFromCGPoint(_rightProductsTableView.contentOffset);
    _rightProductsTableView.rightArray=array;
    [_rightProductsTableView reloadData];
//    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
//     [_rightProductsTableView setContentOffset:point];
}

- (void)finishSelect {
    NSArray *controllers = self.navigationController.childViewControllers;
    NSInteger length = [controllers count];
    if ([[controllers objectAtIndex:length-2] isKindOfClass:[OrderBasketPickerViewController class]]) {
//        OrderBasketViewController *showBaskView =  (OrderBasketViewController *)[controllers lastObject];
        //showDetailView.customInfo = _customInfo;
        //[showBaskView refreshBasketContent];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showCartContent
{
    NSMutableArray *products = [NSMutableArray array];
    [_cartDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [products addObject:obj];
    }];
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


@end
