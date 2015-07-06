//
//  MShowCustomDetailViewController.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MShowCustomDetailViewController.h"
#import "MShowCustomDetailCell.h"
#import "MEditCustomInfoViewController.h"
@interface MShowCustomDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
  NSMutableArray *titleArray;
  NSMutableArray *valueArray;
}
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation MShowCustomDetailViewController

NSString *const tableviewCell = @"MShowCustomDetailCell ";

- (instancetype)initWithCustomInfo:(CustomInfo *)customInfo {
  if (self = [self init]) {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled  = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customInfo = customInfo;
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editCustomInfo)];
    self.navigationItem.rightBarButtonItem =editButton;
      self.title = @"详细信息";
  }
  return self;
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
  [titleArray addObject:@"姓名"];
  [valueArray addObject:self.customInfo.name];
  [titleArray addObject:@"邮箱"];
  [valueArray addObject:self.customInfo.email];
  [titleArray addObject:@"地址"];
  [valueArray addObject:self.customInfo.address];
  [titleArray addObject:@"身份证"];
  [valueArray addObject:self.customInfo.idnum];
  [titleArray addObject:@"代理"];
   NSString *agentDesc = self.customInfo.agent? @"是":@"否";
  [valueArray addObject:agentDesc];
  [titleArray addObject:@"备注"];
  [valueArray addObject:self.customInfo.note];

}

- (void)editCustomInfo {
    MEditCustomInfoViewController *editCustomInfoViewController = [[MEditCustomInfoViewController alloc]initWithCustom:_customInfo];
    [self.navigationController pushViewController:editCustomInfoViewController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MShowCustomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:tableviewCell];
  if (cell==nil) {
    cell = [[MShowCustomDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableviewCell];
  }
    [cell updateCellWithTitle:titleArray[indexPath.row] detailInformation:valueArray[indexPath.row] ];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [titleArray count];
}

@end
