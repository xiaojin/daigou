//
//  MShowCustomDetailViewController.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MShowCustomDetailViewController.h"
#import "MShowCustomDetailCell.h"
@interface MShowCustomDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
  NSMutableArray *titleArray;
  NSMutableArray *valueArray;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) CustomInfo *customInfo;
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
//    [self.tableView registerClass:[MShowCustomDetailCell class] forCellReuseIdentifier:tableviewCell];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customInfo = customInfo;
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    titleArray = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    [self initValueForCell];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editCustomInfo)];
    self.navigationItem.rightBarButtonItem =editButton;
  }
  return self;
}

- (void) initValueForCell{
  [titleArray addObject:@"姓名"];
  [valueArray addObject:_customInfo.name];
  [titleArray addObject:@"邮箱"];
  [valueArray addObject:_customInfo.email];
  [titleArray addObject:@"地址"];
  [valueArray addObject:_customInfo.address];
  [titleArray addObject:@"身份证"];
  [valueArray addObject:_customInfo.idnum];
  [titleArray addObject:@"备注"];
  [valueArray addObject:_customInfo.note];
  [titleArray addObject:@"代理"];
   NSString *agentDesc = _customInfo.agent? @"是":@"否";
  [valueArray addObject:agentDesc];

}

- (void)editCustomInfo {

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
