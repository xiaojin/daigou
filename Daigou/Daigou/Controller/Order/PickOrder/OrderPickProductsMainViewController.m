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


@interface OrderPickProductsMainViewController () <DockTableViewDelegate,RightTableViewDelegate>
@property (nonatomic, strong)OrderProductDockView *dockTableView;
@property (nonatomic, strong)NSMutableArray *docksArray;
@property (nonatomic, strong)OrderProductsRightTableView *rightProductsTableView;
@property(nonatomic, weak) UILabel *totalSingular;
@property(nonatomic, weak) UIImageView *cartImage;
@property(nonatomic, strong) NSMutableArray *offsArray;
//@property(nonatomic, weak) BALabel *bottomLabel;

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
    
    //self.navigationItem.leftBarButtonItem =
    UIView *cartButton = [[UIView alloc]init];
    [cartButton setFrame:CGRectMake(0, 0, 35, 35)];
    UIImage *cart = [IonIcons imageWithIcon:ion_ios_cart_outline iconColor:[UIColor blackColor] iconSize:35.0f imageSize:CGSizeMake(35.0f, 35.0f)];
    UIImageView *carView = [[UIImageView alloc]initWithImage:cart];
    [carView setFrame:cartButton.frame];
    [cartButton addSubview:carView];
    UILabel *countlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [countlbl setText:@"0"];
    countlbl.layer.masksToBounds = YES;
    countlbl.layer.cornerRadius = 7.5;
    countlbl.textAlignment = NSTextAlignmentCenter;
    countlbl.backgroundColor = [UIColor redColor];
    [countlbl setTextColor:[UIColor whiteColor]];
    [countlbl setFont:[UIFont systemFontOfSize:12.0f]];
    [cartButton addSubview:countlbl];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:cartButton];
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
//    _dic = [NSMutableDictionary dictionary];
//    _key = [NSMutableArray array];
}

- (void)bottomLabelClick {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)quantity:(NSInteger)quantity
           money:(NSInteger)money
             key:(NSInteger)key {
//    NSInteger addend = quantity * money;
//    
//    [_dic setObject:[NSString stringWithFormat:@"%ld", addend] forKey:key];
//    //得到词典中所有KEY值
//    NSEnumerator *enumeratorKey = [_dic keyEnumerator];
//    //遍历所有KEY的值
//    NSInteger total = 0;
//    NSInteger totalSingularInt = 0;
//    for (NSObject *object in enumeratorKey) {
//        total += [_dic[object] integerValue];
//        if ([_dic[object] integerValue] != 0) {
//            totalSingularInt += 1;
//            _totalSingular.hidden = NO;
//        }
//    }
//    if (totalSingularInt == 0) {
//        _totalSingular.hidden = YES;
//        _bottomLabel.backgroundColor = [UIColor lightGrayColor];
//        _bottomLabel.userInteractionEnabled = NO;
//        _bottomLabel.text = @"请选购";
//    } else {
//        _bottomLabel.backgroundColor = [UIColor clearColor];
//        _bottomLabel.userInteractionEnabled = YES;
//        _bottomLabel.text=@"去结算";
//    }
//    _totalSingular.text=[NSString stringWithFormat:@"%ld",totalSingularInt];
//    _totalPrice.text=[NSString stringWithFormat:@"￥%ld",total];
    
}

- (void)dockClickIndexRow:(NSMutableArray *)array index:(NSIndexPath *)index indexPath:(NSIndexPath *)indexPath {

//    [_rightProductsTableView setContentOffset:_rightProductsTableView.contentOffset animated:NO];
//    _offsArray[index.row] =NSStringFromCGPoint(_rightProductsTableView.contentOffset);
    _rightProductsTableView.rightArray=array;
    [_rightProductsTableView reloadData];
//    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
//     [_rightProductsTableView setContentOffset:point];
}


-(void)cartImageClick
{
    
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
