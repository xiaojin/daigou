//
//  OrderSiderBarViewController.m
//  Daigou
//
//  Created by jin on 25/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderSiderBarViewController.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "Brand.h"
#import "BrandManagement.h"
#import "ProductManagement.h"
#import "MBrandTableView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface OrderSiderBarViewController()<MBrandTableViewDelegate>
@property(nonatomic, strong)MBrandTableView *brandTableView;
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSArray *brandList;
@end

@implementation OrderSiderBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect menuRect = CGRectZero;
    if (!self.hideHeaderView) {
        UIView *headView = [[UIView alloc]init];
        [headView setBackgroundColor:RGB(243, 244, 246)];
        [self.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@60);
        }];
        UILabel *headViewTitle = [[UILabel alloc]init];
        [headViewTitle setText:@"全部分类"];
        [headViewTitle setFont:[UIFont systemFontOfSize:14.0f]];
        [headViewTitle setTextColor:RGB(125, 125, 125)];
        [headViewTitle setTextAlignment:NSTextAlignmentCenter];
        [headView addSubview:headViewTitle];
        
        [headViewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_top).with.offset(10);
            make.left.equalTo(headView.mas_left);
            make.bottom.equalTo(headView.mas_bottom);
            make.width.equalTo(@80);
        }];
        menuRect = CGRectMake(0, 60, self.contentView.bounds.size.width, self.contentView.bounds.size.height-60);
    } else {
        NSLog(@"%f",self.tabHeight + self.navHeight);
        menuRect = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height-(self.tabHeight + self.navHeight));
    }
    
    _brandTableView = [[MBrandTableView alloc]init];
    _brandTableView.delegate = self;
    _brandTableView.brandTableView.rowHeight = 65.0f;
    [self.contentView addSubview:_brandTableView];
    [_brandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-65.0f);
    }];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - MBrandtableviewDelegate

- (void)brandDidSelected:(Brand *)brand {
    [_orderDelegate itemDidSelect:brand];
}

@end
