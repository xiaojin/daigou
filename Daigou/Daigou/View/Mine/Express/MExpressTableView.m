//
//  MExpressTableView.m
//  Daigou
//
//  Created by jin on 13/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MExpressTableView.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "Express.h"
#import "ExpressManagement.h"

@interface MExpressTableView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSArray *expressList;
@end
@implementation MExpressTableView

- (void)layoutSubviews {
    _expressTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _expressTableView.dataSource = self;
    _expressTableView.delegate = self;
    _expressTableView.rowHeight = 65.0f;
    [self addSubview:_expressTableView];
    [_expressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.expressList = [self getExpress];
}


- (NSArray *)getExpress{
    ExpressManagement *expressManagement = [ExpressManagement shareInstance];
    return [expressManagement getExpress];
}

- (void)setExpressList:(NSArray *)expressList {
    _expressList = [self arrayForSections:expressList];
    [self.expressTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_expressList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_expressList[section] count];
}
- (NSArray *)arrayForSections:(NSArray *)objects {
    SEL selector = @selector(name);
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    NSMutableArray *mutableSections = [[NSMutableArray alloc]initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount;idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [collation sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    NSMutableArray *existTitleSections = [NSMutableArray array];
    for (NSArray *section in mutableSections) {
        if ([section count] > 0) {
            [existTitleSections addObject:section];
        }
    }
    
    NSMutableArray *existTitles = [NSMutableArray array];
    NSArray *allSections = [collation sectionIndexTitles];
    
    for (NSUInteger i =0; i < [allSections count]; i++) {
        if ([mutableSections[i] count] > 0) {
            [existTitles addObject:allSections[i]];
        }
    }
    self.indexList = existTitles;
    return existTitleSections;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYEXPRESS"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYEXPRESS"];
    }
    Express *info = [_expressList objectAtIndex:indexPath.section][indexPath.row];
    cell.textLabel.text =info.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _indexList[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexList;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Express *expressInfo = [_expressList objectAtIndex:indexPath.section][indexPath.row];
    [_delegate expressDidSelected:expressInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
