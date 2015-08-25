//
//  OrderSiderBarViewController.m
//  Daigou
//
//  Created by jin on 25/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderSiderBarViewController.h"

@implementation OrderSiderBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *backView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:backView];
}

@end
