//
//  MineViewController.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MineViewController.h"
#import <ionicons/IonIcons.h>
#import "MCustInfoViewController.h"
#import "MDeliveryManagementViewController.h"
#import "SettingItem.h"
#import "MSettingViewController.h"
#import "MAboutViewController.h"
#import "IASKAppSettingsViewController.h"
#import "MSellInfoViewController.h"

#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]
#define kICONSIZE 20.0f

@interface MineViewController ()
@property(nonatomic, strong) NSMutableArray *settings;
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
    NSMutableArray *firstSection = [
            @[[SettingItem itemWithIcon:ion_android_person title:@"客户列表" controller: [MCustInfoViewController class]],
                    [SettingItem itemWithIcon:ion_android_plane title:@"快递管理" controller:[MDeliveryManagementViewController class]],
                    [SettingItem itemWithIcon:ion_ios_calculator_outline title:@"卖家管理" controller:[MSellInfoViewController class]]]
            mutableCopy];

//    NSMutableArray *secondSection = [
//                                     
//            @[[SettingItem itemWithIcon:ion_android_person title:@"快递助手" controller:[MCustInfoViewController class]],[SettingItem itemWithIcon:ion_android_plane title:@"经营统计" controller:[MDeliveryManagementViewController class]],
//                    [SettingItem itemWithIcon:ion_ios_calculator_outline title:@"数据导出" controller:[MDeliveryManagementViewController class]]]
//            mutableCopy];

    NSMutableArray *thirdSection = [
            @[[SettingItem itemWithIcon:ion_ios_gear_outline title:@"设置" controller:[MSettingViewController class]],
                    [SettingItem itemWithIcon:ion_android_share_alt title:@"分享" controller:[MDeliveryManagementViewController class]],
                    [SettingItem itemWithIcon:ion_ios_information_outline title:@"关于" controller:[MAboutViewController class]]]
            mutableCopy];

    self.settings = [@[firstSection, thirdSection] mutableCopy];
}

- (SettingItem *) getItem:(NSIndexPath *)indexPath {
    return ((SettingItem *) self.settings[indexPath.section][indexPath.row]);
}


#pragma mark --TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableCellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self getItem:indexPath].title;
    cell.imageView.image = [IonIcons imageWithIcon:[self getItem:indexPath].icon size:kICONSIZE color:kICONCOLOR];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settings[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settings count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];

}

#pragma mark --TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0 && [indexPath section] == 2) {
        IASKAppSettingsViewController *asvc = [[IASKAppSettingsViewController alloc]init];
        asvc.showDoneButton = NO;
        [self.navigationController pushViewController:asvc animated:YES];
        return;
    }
    UIViewController *pushViewController = nil;
    pushViewController = (UIViewController *) [[[self getItem:indexPath].controllerClass alloc] init];
    pushViewController.title = [self getItem:indexPath].title;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    pushViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushViewController animated:YES];
}

@end
