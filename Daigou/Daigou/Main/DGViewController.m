//
//  DGViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "DGViewController.h"
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "MProductCatalogViewController.h"
#import "MProductsViewController.h"
#define kTabICONSIZE 26.0f
#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]

@interface DGViewController ()

@end

@implementation DGViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    UIStoryboard *procurementStoryboard = [UIStoryboard storyboardWithName:@"Procurement" bundle:nil];
 
    UIStoryboard *orderStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    UIViewController *firstVC = [orderStoryboard instantiateInitialViewController];
    firstVC.title = @"订单";
    firstVC.tabBarItem.image = [IonIcons imageWithIcon:ion_document_text size:kTabICONSIZE color:kICONCOLOR];
    
    UIViewController *secVC = [procurementStoryboard instantiateInitialViewController];
    secVC.title = @"采购";
    secVC.tabBarItem.image = [IonIcons imageWithIcon:ion_android_cart size:kTabICONSIZE color:kICONCOLOR];
    
    UIStoryboard *addStoryboard = [UIStoryboard storyboardWithName:@"Add" bundle:nil];
    MProductsViewController *productsViewController = [[MProductsViewController alloc]init];
    UINavigationController *thirdVC =[[UINavigationController alloc] initWithRootViewController:productsViewController];
   // MProductCatalogViewController *thirdVC = [[MProductCatalogViewController alloc]init];
    productsViewController.title = @"商品";
    thirdVC.tabBarItem.image = [IonIcons imageWithIcon:ion_plus size:kTabICONSIZE color:kICONCOLOR];

    UIStoryboard *stockStoryboard = [UIStoryboard storyboardWithName:@"Stock" bundle:nil];
    UIViewController *forthVC = [stockStoryboard instantiateInitialViewController];
    forthVC.title = @"库存";
    forthVC.tabBarItem.image = [IonIcons imageWithIcon:ion_podium size:kTabICONSIZE color:kICONCOLOR];

    UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UIViewController *fifthVC = [mineStoryboard instantiateInitialViewController];
    fifthVC.title = @"我的";
    fifthVC.tabBarItem.image = [IonIcons imageWithIcon:ion_android_person size:kTabICONSIZE color:kICONCOLOR];
    [self setViewControllers:[NSArray arrayWithObjects:firstVC,secVC,thirdVC,forthVC,fifthVC, nil]];
    self.view.backgroundColor = [UIColor whiteColor];
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
