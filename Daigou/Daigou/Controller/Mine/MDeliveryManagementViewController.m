//
//  DeliveryManagementViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MDeliveryManagementViewController.h"
#import "MExpressTableView.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "MEditExpressViewController.h"
@interface MDeliveryManagementViewController ()

@end

@implementation MDeliveryManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MExpressTableView *expressTableView = [[MExpressTableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:expressTableView];
    [expressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}

- (void)initNavigationBar {
    if (self.isCancelButton) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExpress)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addExpress {
    MEditExpressViewController *editExpressViewController = [[MEditExpressViewController alloc]init];
    [self.navigationController pushViewController:editExpressViewController animated:YES];
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
