//
//  OrderBasketViewController.m
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderBasketViewController.h"
#import "OrderItem.h"
#import "OrderItemManagement.h"
#import "OrderBasketCell.h"
#import "OProductItem.h"
#import "OrderPickProductsMainViewController.h"
#import "CommonDefines.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "ProductWithCount.h"

@interface OrderBasketViewController()<UITableViewDataSource, UITableViewDelegate,OrderPickProductsMainViewControllerDelegate> {
    CGSize keyboardSize;
}
@property(nonatomic, strong) OrderItem *orderItem;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) NSArray *products;
@property(nonatomic, strong) NSMutableArray *orderItemFrames;
@property(nonatomic, strong) NSIndexPath *currentCellIndex;
@end
@implementation OrderBasketViewController

- (instancetype)initwithOrderItem :(OrderItem *)orderitem  withGroupOrderProducts:(NSArray *)products{
    self.orderItem = orderitem;
    self.products = [NSArray array];
    self.products = products;
    return [self init];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addProduct)];
    [self checkBasketItems];
}


- (void)addProduct {
    OrderPickProductsMainViewController *orderPickMainViewController =  [[OrderPickProductsMainViewController alloc]initWithOrderItem:self.orderItem];
    orderPickMainViewController.delegate = self;
    [self presentViewController:orderPickMainViewController animated:YES completion:nil];
}

- (void)checkBasketItems {
    if (self.products.count == 0) {
        [self showEmptyView];
    } else {
        [self initOrderBasketItemsFrameWithOrderItems:self.products];
        [self showOrderItemsTableView];
    }
}


- (void)showEmptyView {
    self.emptyView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.emptyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.emptyView];

    CGFloat labelHeight = 44.0f;
    CGFloat labelWidth = CGRectGetWidth(self.view.frame);
    CGFloat offY = (CGRectGetHeight(self.view.frame) - labelHeight)/2;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, offY, labelWidth, labelHeight)];
    [label setText:@"您还订单货物是空的哦"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.emptyView addSubview:label];
    
    UIImage *basketImage = [IonIcons imageWithIcon:ion_bag iconColor:GRAYCOLOR iconSize:70.0f imageSize:CGSizeMake(70.0f, 70.0f)];
    UIImageView *basketImageView = [[UIImageView alloc]initWithImage:basketImage];
    basketImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProduct)];
    [imageTapGesture setNumberOfTapsRequired:1];
    [basketImageView addGestureRecognizer:imageTapGesture];
    [self.emptyView addSubview:basketImageView];
    [basketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_top).with.offset(-5);
        make.height.equalTo(@75.0f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@75.0f);
    }];
    
}

- (void)showOrderItemsTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:RGB(238, 238, 238)];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 160.f, 0);
}

- (void)initOrderBasketItemsFrameWithOrderItems:(NSArray *)orderItems {
    self.orderItemFrames = [NSMutableArray array];
     for (NSDictionary *item in orderItems) {
         NSMutableDictionary *prodocstdict = [NSMutableDictionary dictionary];
         [prodocstdict setValue:[item objectForKey:@"oproductitem"] forKey:@"product"];
         [prodocstdict setValue:[item objectForKey:@"count"] forKey:@"count"];
         [self.orderItemFrames addObject:prodocstdict];
     }
}

#pragma mark - OrderPickProductsMainDelegate
- (void)finishPickProducts {
    [self reloadOrderProductsFromDB];
    if (!self.emptyView.hidden) {
        [self checkBasketItems];
        [self.emptyView removeFromSuperview];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [_tableView reloadData];
}

#pragma mark - UINotification
- (void)keyboardWillHide:(NSNotification *)sender {
    OrderBasketCell *currentCell = (OrderBasketCell *)[self.tableView cellForRowAtIndexPath:_currentCellIndex];
    [currentCell updateDoneButton];
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = 140.0f;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = CGSizeMake(keyboardSize.width, keyboardSize.height + 100.0f);

}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != [self.products count]) {
        OrderBasketCell *cell = [OrderBasketCell OrderWithCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary * productDict = _orderItemFrames[indexPath.row];
        cell.productDict = productDict;
        cell.OrderProductItemsAllDeleted = ^(){
            [self cellDeletedWithIndexPath];
        };
        cell.EditQuantiyActionBlock = ^(NSInteger number){
        [self beginEditNumber:indexPath];
        };
        return cell;
    } else {
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"orderAddCell"];
        [addCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (addCell == nil) {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderAddCell"];
        }
        UIButton *addButton = [[UIButton alloc]init];
        [addCell.contentView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addCell.contentView);
            make.left.equalTo(addCell.contentView);
            make.right.equalTo(addCell.contentView);
            make.bottom.equalTo(addCell.contentView);
        }];
        [addButton setImage:[IonIcons imageWithIcon:ion_android_add size:35.0f color:[UIColor blackColor]] forState:UIControlStateNormal];
    
        [addButton setTitle:@"新增" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [addButton addTarget:self action:@selector(addProduct) forControlEvents:UIControlEventTouchUpInside];
        return addCell;
    }
}

- (void)cellDeletedWithIndexPath {
    [self reloadOrderProductsFromDB];
    [_tableView reloadData];
}

- (void)reloadOrderProductsFromDB {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    NSArray *products = [itemManagement getOrderProductsByOrderId:self.orderItem.oid];
    NSMutableDictionary *productsDict = [NSMutableDictionary dictionary];
    NSInteger stockCount = 0;
    NSInteger pruchaseCount = 0;
    for (int i =0; i < [products count]; i++) {
        OProductItem *oProductItem = products[i];
        if (oProductItem.statu == PRODUCT_PURCHASE) {
            pruchaseCount ++;
        } else if (oProductItem.statu == PRODUCT_INSTOCK){
            stockCount ++;
        }
        NSArray *keys = [productsDict allKeys];
        if ([keys containsObject:[NSNumber numberWithInteger:oProductItem.iid]]) {
            NSMutableArray *products = [productsDict objectForKey:[NSNumber numberWithInteger:oProductItem.iid]];
            [products addObject:oProductItem];
            [productsDict setObject:products forKey:[NSNumber numberWithInteger:oProductItem.iid]];
        } else {
            NSMutableArray *products = [NSMutableArray array];
            [products addObject:oProductItem];
            [productsDict setObject:products forKey:[NSNumber numberWithInteger:oProductItem.iid]];
        }
    }
    NSMutableArray *productsCountDictList = [NSMutableArray array];
    for (NSNumber *key in [productsDict allKeys]) {
        NSArray *products = [productsDict objectForKey:key];
        [productsCountDictList addObject:@{@"oproductitem":[products lastObject],
                                           @"count":@([products count])}];
    }
    self.products = productsCountDictList;
    if (self.orderItem.statu == UNDISPATCH && stockCount !=0) {
        OrderItemManagement *orderManagement = [OrderItemManagement shareInstance];
        self.orderItem.statu = PURCHASED;
        [orderManagement updateOrderItem:self.orderItem];
    }
    [self initOrderBasketItemsFrameWithOrderItems:self.products];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return ([self.orderItemFrames count] +1);

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.products count]) {
        return 60.0f;
    } else {
        return 142.0f;
    }
}

#pragma mark - BasketCellDelegate 

- (void)beginEditNumber:(NSIndexPath *)cellIndex {
    CGFloat kbHeight = keyboardSize.height;
    if (keyboardSize.height == 0) {
        kbHeight = 402.f;
    }
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = kbHeight;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = kbHeight;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
        [self.tableView scrollToRowAtIndexPath:cellIndex
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    _currentCellIndex = cellIndex;
}

#pragma mark -- SaveBasket
- (void)saveBasketInfoWithOrderId:(NSInteger)oid {
    OrderItemManagement *orderManagement = [OrderItemManagement shareInstance];
    [orderManagement updateTemperOrderItemsWithOrderId:oid];
}

@end
