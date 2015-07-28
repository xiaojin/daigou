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
    OrderProductDockView *prodDockView = [[OrderProductDockView alloc]initWithFrame:(CGRect){0,0,75,kWindowHeight-50}];
    prodDockView.rowHeight = 50;
    prodDockView.dockDelegate = self;
    prodDockView.backgroundColor = RGB(238, 238, 238);
    [prodDockView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:prodDockView];
    
    _dockTableView = prodDockView;
    
    OrderProductsRightTableView *rightTableView = [[OrderProductsRightTableView alloc]initWithFrame:(CGRect){75,0,kWindowWidth-75,kWindowHeight-50}];
    rightTableView.rowHeight = 90;
    rightTableView.rightDelegate = self;
    rightTableView.backgroundColor = RGB(238, 238, 238);
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:rightTableView];
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
    _offsArray = [NSMutableArray array];
    for (int i = 0; i < [_docksArray count]; i++) {
        CGPoint point = CGPointMake(0, 0);
        [_offsArray addObject:NSStringFromCGPoint(point)];
    }

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
//    
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
             key:(NSString *)key {
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

-(void)dockClickindexPathRow:(NSMutableArray *)array index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath
{
//    [_rightTableView setContentOffset:_rightTableView.contentOffset animated:NO];
//    _offsArray[index.row] =NSStringFromCGPoint(_rightTableView.contentOffset);
//    _rightTableView.rightArray=array;
//    [_rightTableView reloadData];
//    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
//    [_rightTableView setContentOffset:point];
    //    NSLog(@"%@",row);
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
