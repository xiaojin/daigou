//
//  MShowProductDetailViewController.m
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MShowProductDetailViewController.h"

@interface MShowProductDetailViewController()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *titleArray;
    NSMutableArray *valueArray;
}
@property(nonatomic, strong)UITableView *tableView;

@end
@implementation MShowProductDetailViewController
NSString *const tableviewCell = @"MShowProductDetailCell ";

- (instancetype)initWithProduct:(Product *)product {
    if (self = [self init]) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.scrollEnabled  = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
        self.tableView.allowsSelection = NO;
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.product = product;
        [self.view addSubview:self.tableView];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editProductInfo)];
        self.navigationItem.rightBarButtonItem =editButton;
        self.title = @"详细信息";
    }
    return self;
}

- (void)editProductInfo {


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    titleArray = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    [self initValueForCell];
    [self.tableView reloadData];
}

- (void) initValueForCell{
    [titleArray addObject:@"名字"];
    [valueArray addObject:self.product.name];
    [titleArray addObject:@"商品品牌列表"];
    [valueArray addObject:@(self.product.brandid)];
    [titleArray addObject:@"产品分类"];
    [valueArray addObject:@(self.product.categoryid)];
    [titleArray addObject:@"型号"];
    [valueArray addObject:self.product.model];
    [titleArray addObject:@"条码"];
    [valueArray addObject:self.product.barcode];
    [titleArray addObject:@"重量"];
    [valueArray addObject:@(self.product.wight)];
    [titleArray addObject:@"检索码"];
    [valueArray addObject:self.product.quickid];
    [titleArray addObject:@"采购价格参考"];
    [valueArray addObject:@(self.product.costprice)];
    [titleArray addObject:@"出售价格"];
    [valueArray addObject:@(self.product.sellprice)];
    [titleArray addObject:@"功效"];
    [valueArray addObject:self.product.function];
    [titleArray addObject:@"卖点说明"];
    [valueArray addObject:@(self.product.sellprice)];
    [titleArray addObject:@"备注"];
    [valueArray addObject:self.product.note];
    [titleArray addObject:@"缺货产品"];
//    NSString *agentDesc = self.product.agent? @"是":@"否";
//    [valueArray addObject:agentDesc];
}


@end
