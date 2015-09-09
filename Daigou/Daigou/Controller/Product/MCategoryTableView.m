//
//  MCategoryTableView.m
//  Daigou
//
//  Created by jin on 9/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
#import "MCategoryTableView.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "ProductCategory.h"
#import "ProductCategoryManagement.h"

@interface MCategoryTableView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *categoryableView;
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSArray *categoryList;
@end
@implementation MCategoryTableView


- (void)layoutSubviews {
    _categoryableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _categoryableView.dataSource = self;
    _categoryableView.delegate = self;
    _categoryableView.rowHeight = 65.0f;
    [self addSubview:_categoryableView];
    [_categoryableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.categoryList = [self getCategoryList];
}


- (NSArray *)getCategoryList{
    ProductCategoryManagement *categoryManagement = [ProductCategoryManagement shareInstance];
    return [categoryManagement getCategory];
}

- (void)setCategoryList:(NSArray *)categoryList {
    _categoryList = [self arrayForSections:categoryList];
    [self.categoryableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_categoryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_categoryList[section] count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYBRAND"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYBRAND"];
    }
    ProductCategory *info = [_categoryList objectAtIndex:indexPath.section][indexPath.row];
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
    ProductCategory *categoryInfo = [_categoryList objectAtIndex:indexPath.section][indexPath.row];
    [_delegate categoryDidSelected:categoryInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
