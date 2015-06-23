//
//  MineViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MineViewController.h"
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>

#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]
#define kICONSIZE 20.0f
@interface MineViewController ()
@property(nonatomic, strong)NSArray *stringArray;
@property(nonatomic, strong)NSArray *iconArray;
@end

@implementation MineViewController
NSString *const kTableCellID = @"SETTINGCELLID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingArray];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    //self.settingTableView.scrollEnabled = NO;
    self.settingTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.settingTableView.bounds.size.width, 0.01f)];
}

- (void)settingArray {
  NSArray *firstSection = [NSArray arrayWithObjects:@"客户信息",@"商品目录",@"快递管理",@"现状统计",nil];
  NSMutableArray *firstSectionIcons = [NSMutableArray array];
  [firstSectionIcons addObject:[IonIcons imageWithIcon:ion_android_person size:kICONSIZE color:kICONCOLOR]];
  [firstSectionIcons addObject:[IonIcons imageWithIcon:ion_bag size:kICONSIZE color:kICONCOLOR]];
  [firstSectionIcons addObject:[IonIcons imageWithIcon:ion_android_plane size:kICONSIZE color:kICONCOLOR]];
  [firstSectionIcons addObject:[IonIcons imageWithIcon:ion_ios_calculator_outline size:kICONSIZE color:kICONCOLOR]];
  NSArray *secSection = [NSArray arrayWithObjects:@"设置",@"分享",@"关于", nil];
  NSMutableArray *secSectionIcons = [NSMutableArray array];
  [secSectionIcons addObject:[IonIcons imageWithIcon:ion_ios_gear_outline size:kICONSIZE color:kICONCOLOR]];
  [secSectionIcons addObject:[IonIcons imageWithIcon:ion_android_share_alt size:kICONSIZE color:kICONCOLOR]];
  [secSectionIcons addObject:[IonIcons imageWithIcon:ion_ios_information_outline size:kICONSIZE color:kICONCOLOR]];
  self.stringArray = [NSArray arrayWithObjects:firstSection,secSection, nil];
  self.iconArray = [NSArray arrayWithObjects:firstSectionIcons,secSectionIcons, nil];
}





#pragma mark --TableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableCellID];
  }
  cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = self.stringArray[indexPath.section][indexPath.row];
  cell.imageView.image =self.iconArray[indexPath.section][indexPath.row];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger count = 0;
  switch (section) {
    case 0:
      count = [(NSArray*)self.stringArray[0] count];
      break;
    case 1:
      count = [(NSArray*)self.stringArray[1] count];
      break;
  }
  return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [self.stringArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [[UIView alloc]initWithFrame:CGRectZero];
  
}
#pragma mark --TableViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
