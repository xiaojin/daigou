//
//  SecondViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//  订单item 向右划 可以显示两个控件，一个删除，一个复制

#import "OrderViewController.h"
#import "OAddNewOrderViewController.h"
@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *orderListTableView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchAllOrders];
    self.orderListTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.orderListTableView.dataSource = self;
    self.orderListTableView.delegate = self;
    [self.view addSubview:self.orderListTableView];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    self.navigationItem.rightBarButtonItem =editButton;
    [self.orderListTableView reloadData];
}

- (void)addNewOrder {
    OAddNewOrderViewController *addNewOrderViewController = [[OAddNewOrderViewController alloc]
                                                             init];
    [self.navigationController pushViewController:addNewOrderViewController animated:YES];

}

- (void)fetchAllOrders {


}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productFrameItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemCell * cell = [ProductItemCell NewsWithCell:tableView];
    ProductItemFrame *newItem = self.productFrameItems[indexPath.row];
    cell.productFrame = newItem;
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemFrame *itemFrame =self.productFrameItems[indexPath.row];
    return itemFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MShowProductDetailViewController *showDetailViewController = [[MShowProductDetailViewController alloc]initWithProduct:[(ProductItemFrame *)self.productFrameItems[indexPath.row] getProduct]];
    [self.navigationController pushViewController:showDetailViewController animated:YES];
}
@end
