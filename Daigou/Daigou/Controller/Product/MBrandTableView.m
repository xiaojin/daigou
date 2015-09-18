//
//  MBrandTableView.m
//  Daigou
//
//  Created by jin on 9/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MBrandTableView.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "Brand.h"
#import "BrandManagement.h"
@interface MBrandTableView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSArray *brandList;
@end
@implementation MBrandTableView


- (void)layoutSubviews {
    _brandTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _brandTableView.dataSource = self;
    _brandTableView.delegate = self;
    _brandTableView.rowHeight = 65.0f;
    _brandTableView.frame= self.bounds;
    [self addSubview:_brandTableView];
     self.brandList = [self getBrands];
}


- (NSArray *)getBrands{
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    return [brandManagement getBrand];
}

- (void)setBrandList:(NSArray *)brandList {
    _brandList = [self arrayForSections:brandList];
    [self.brandTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_brandList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_brandList[section] count];
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
    Brand *info = [_brandList objectAtIndex:indexPath.section][indexPath.row];
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
    Brand *brandInfo = [_brandList objectAtIndex:indexPath.section][indexPath.row];
    [_delegate brandDidSelected:brandInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
