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
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface OrderSiderBarViewController()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *brandTableView;
@property(nonatomic, strong) NSArray *indexList;

@end

@implementation OrderSiderBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after    loading the view from its nib.
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
    
    
    _brandTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _brandTableView.dataSource = self;
    _brandTableView.delegate = self;
    _brandTableView.rowHeight = 65.0f;
    [self.contentView addSubview:_brandTableView];
    [_brandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

}


- (void)setBrandList:(NSArray *)brandList {
    _brandList = [self arrayForSections:brandList];
    [_brandTableView reloadData];
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
@end
