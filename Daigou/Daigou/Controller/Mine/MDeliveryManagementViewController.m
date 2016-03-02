//
//  DeliveryManagementViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MDeliveryManagementViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "MExpressManagementViewController.h"
#import "OrderItemManagement.h"
#import "OrderItem.h"

@interface MDeliveryManagementViewController ()<UITableViewDataSource, UITableViewDelegate,MExpressManagementViewControllerDelegate>
@property(nonatomic, strong)UITableView *orderItemTableView;
@property(nonatomic, strong)NSArray *orderList;
@property(nonatomic, strong)Express *express;
@end

@implementation MDeliveryManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    _orderItemTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _orderItemTableView.dataSource = self;
    _orderItemTableView.delegate = self;
    [self.view addSubview:_orderItemTableView];
    [_orderItemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)initNavigationBar {
    UIImage *menuIcon= [IonIcons imageWithIcon:ion_navicon_round iconColor:SYSTEMBLUE iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:menuIcon style:UIBarButtonItemStylePlain target:self action:@selector(expressCategorySelect)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)expressCategorySelect {
    MExpressManagementViewController *expressManagementViewController = [[MExpressManagementViewController alloc]init];
    expressManagementViewController.expressDelegate =self;
    [self.navigationController pushViewController:expressManagementViewController animated:YES];
}

- (void)getOrderItemsWithExpress:(Express *)express {
    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
    NSArray *items = [itemManagement getOrderItemsByExpress:express];
    [self arrayForSections:items];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_orderList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_orderList[section] count] ;
}
- (NSArray *)arrayForSections:(NSArray *)objects {
    NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:5];
    for (int x =0; x <5; x++) {
        NSMutableArray *array = [NSMutableArray array];
        [items addObject:array];
    }
    
    for (OrderItem *item in objects) {
        [(NSMutableArray *)[items objectAtIndex:(item.statu/10)] addObject:item];

    }
    for (NSMutableArray *obj in items) {
        if ([obj count] == 0) {
            [items removeObject:obj];
        }
    }
    
    _orderList = items;
    return _orderList;
}

- (NSString *)getTitlForStatu:(OrderStatus)staus {
    switch (staus) {
        case PURCHASED:
            return PURCHASEDTITLE;
            break;
         case UNDISPATCH:
            return UNDISPATCHTITLE;
            break;
        case SHIPPED:
            return SHIPPEDTITLE;
            break;
        case DELIVERD:
            return DELIVERDTITLE;
            break;
        case DONE:
            return DONETITLE;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYEXPRESSORDERS"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYEXPRESSORDERS"];
    }
    OrderItem *orderItem = _orderList[indexPath.section][indexPath.row];
    cell.textLabel.text = orderItem.reviever;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    OrderItem *orderItem =  _orderList[section][0];
    return [self getTitlForStatu:orderItem.statu];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark MExpressManagementViewControllerDelegate 
- (void)expressDidSelected:(Express *)express {
    self.title = express.name;
    [self getOrderItemsWithExpress:express];
    [_orderItemTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
