//
//  MCustInfoViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MCustInfoViewController.h"
#import "CustomInfo.h"
@interface MCustInfoViewController ()
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *indexList;
@end

@implementation MCustInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  CustomInfo *info1 = [[CustomInfo alloc]init];
  info1.name = @"abv";
  CustomInfo *info2 = [[CustomInfo alloc]init];
  info2.name = @"bbv";
  CustomInfo *info3 = [[CustomInfo alloc]init];
  info3.name = @"vbv";
  CustomInfo *info4 = [[CustomInfo alloc]init];
  info4.name = @"dsv";
  CustomInfo *info5 = [[CustomInfo alloc]init];
  info5.name = @"ebv";
  CustomInfo *info6 = [[CustomInfo alloc]init];
  info6.name = @"zbv";
  CustomInfo *info7 = [[CustomInfo alloc]init];
  info7.name = @"jbv";
  CustomInfo *info8 = [[CustomInfo alloc]init];
  info8.name = @"hbv";
  CustomInfo *info9 = [[CustomInfo alloc]init];
  info9.name = @"ibv";
  CustomInfo *info10 = [[CustomInfo alloc]init];
  info10.name = @"kbv";
  CustomInfo *info11 = [[CustomInfo alloc]init];
  info11.name = @"wbv";
  self.contacts = [NSArray arrayWithObjects:info1,info2,info3,info4,info5,info6,info7,info8,info9,info10,info11,nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContacts:(NSArray *)contacts {
  _contacts = [self arrayForSections:contacts];
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_contacts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_contacts[section] count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCONTACT"];
    if (cell==nil) {
      cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYCONTACT"];
    }
    CustomInfo *info = [_contacts objectAtIndex:indexPath.section][indexPath.row];
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