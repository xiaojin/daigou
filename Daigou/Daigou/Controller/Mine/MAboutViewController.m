//
//  AboutViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MAboutViewController.h"

@interface MAboutViewController ()
@property(nonatomic, strong) NSMutableArray *about;
@end

@implementation MAboutViewController

NSString *const aboutTableCellID = @"ABOUTCELLID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.about = [@[@"版本",@"QQ用户群",@"联系我们",@"意见反馈",@"检查新版本",@"更新日志",@"网站"] mutableCopy];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.about.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:aboutTableCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:aboutTableCellID];
    }
    cell.textLabel.text = self.about[indexPath.row];
    switch (indexPath.row) {
        case 0:
            [cell.detailTextLabel setText: @"1.0"];
            break;
        case 1:
            [cell.detailTextLabel setText:@"111111"];
            break;
        default:break;
    }
    return cell;
}


@end
