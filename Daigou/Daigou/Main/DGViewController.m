//
//  DGViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "DGViewController.h"

@interface DGViewController ()

@end

@implementation DGViewController

- (void)viewDidLoad {

  [super viewDidLoad];
  UIStoryboard *procurementStoryboard = [UIStoryboard storyboardWithName:@"Procurement" bundle:nil];
  UIViewController *firstVC = [procurementStoryboard instantiateInitialViewController];
  firstVC.title = @"采购";
  UIStoryboard *orderStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
  UIViewController *secVC = [orderStoryboard instantiateInitialViewController];
  secVC.title = @"订单";
  UIStoryboard *addStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
  UIViewController *thirdVC = [addStoryboard instantiateInitialViewController];
  thirdVC.title = @"新增";
  UIStoryboard *stockStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
  UIViewController *forthVC = [stockStoryboard instantiateInitialViewController];
  forthVC.title = @"库存";
  UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
  UIViewController *fifthVC = [mineStoryboard instantiateInitialViewController];
  fifthVC.title = @"我的";
  [self setViewControllers:[NSArray arrayWithObjects:firstVC,secVC,thirdVC,forthVC,fifthVC, nil]];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
