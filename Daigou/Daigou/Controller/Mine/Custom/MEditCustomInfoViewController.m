//
//  MEditCustomInfoViewController.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditCustomInfoViewController.h"
#import "MEditCustomDetailCell.h"
#import "CustomInfo.h"
@interface MEditCustomInfoViewController()<UITableViewDataSource,UITableViewDelegate>{
  NSMutableArray *placeHolderValue;
  NSMutableArray *textFieldValue;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)CustomInfo *customInfo;
@end


@implementation MEditCustomInfoViewController

NSString *const tableviewCellIdentity = @"MEditCustomDetailCell";

- (instancetype)initWithCustom:(CustomInfo*)custom {
  if (self = [super init]) {
    [self.editTableView registerClass: [MEditCustomDetailCell class]forCellReuseIdentifier:tableviewCellIdentity];
    self.customInfo = custom;
    [self initTableViewCellValue];
  }
  return self;
}


- (void)initTableViewCellValue {
  [placeHolderValue addObject:@"客户姓名"];
  [placeHolderValue addObject:@"客户邮箱"];
  [placeHolderValue addObject:@"客户地址"];
  [placeHolderValue addObject:@"客户身份证"];
  [placeHolderValue addObject:@"备注"];
  [placeHolderValue addObject:@"代理"];

}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableviewCellIdentity forIndexPath:indexPath];
  return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 6;
}
@end