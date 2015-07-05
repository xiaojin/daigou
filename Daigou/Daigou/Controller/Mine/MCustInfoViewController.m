//
//  MCustInfoViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MCustInfoViewController.h"
#import "CustomInfo.h"
#import "MShowCustomDetailViewController.h"
#import "MEditCustomInfoViewController.h"
#import "CustomInfoManagement.h"
@interface MCustInfoViewController ()
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *indexList;
@end

@implementation MCustInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  CustomInfo *info1 = [[CustomInfo alloc]init];
//  info1.name = @"abv";
//  info1.email = @"123123";
//  info1.address = @"123123";
//  info1.idnum = @"112312312312";
//  info1.note = @"123123123";
//  info1.agent = 0;
//  CustomInfo *info2 = [[CustomInfo alloc]init];
//  info2.name = @"bbv";
//  info2.email = @"kasjdansdnasd";
//  info2.address = @"22pmaamlsdpasd";
//  info2.idnum = @"922jasd[ansdalsd;";
//  info2.note = @"22klxalslasd";
//  info2.agent = 1;
//  CustomInfo *info3 = [[CustomInfo alloc]init];
//  info3.name = @"vbv";
//  info3.email = @"-k3pma,.sdasd ,ad;'alsdmasd";
//  info3.address = @"asdasdasdasd";
//  info3.idnum = @"azcqwevsczq zxcaq3c";
//  info3.note = @"m cxklb,m ,asdl c,mnfjwb3i";
//  info3.agent = 1;
//  CustomInfo *info4 = [[CustomInfo alloc]init];
//  info4.name = @"dsv";
//  info4.email = @"-k4pma,.sdasd ,ad;'alsdmasd";
//  info4.address = @"asdasdasdasd";
//  info4.idnum = @"azcqwevsczq zxcaq4c";
//  info4.note = @"m cxklb,m ,asdl c,mnfjwb4i";
//  info4.agent = 1;
//  CustomInfo *info5 = [[CustomInfo alloc]init];
//  info5.name = @"ebv";
//  info5.email = @"-k5pma,.sdasd ,ad;'alsdmasd";
//  info5.address = @"asdasdasdasd";
//  info5.idnum = @"azcqwevsczq zxcaq5c";
//  info5.note = @"m cxklb,m ,asdl c,mnfjwb5i";
//  info5.agent = 1;
//  CustomInfo *info6 = [[CustomInfo alloc]init];
//  info6.name = @"zbv";
//  info6.email = @"-k6pma,.sdasd ,ad;'alsdmasd";
//  info6.address = @"asdasdasdasd";
//  info6.idnum = @"azcqwevsczq zxcaq6c";
//  info6.note = @"m cxklb,m ,asdl c,mnfjwb6i";
//  info6.agent = 1;
//  CustomInfo *info7 = [[CustomInfo alloc]init];
//  info7.name = @"jbv";
//  info7.email = @"-k7pma,.sdasd ,ad;'alsdmasd";
//  info7.address = @"asdasdasdasd";
//  info7.idnum = @"azcqwevsczq zxcaq7c";
//  info7.note = @"m cxklb,m ,asdl c,mnfjwb7i";
//  info7.agent = 1;
//  CustomInfo *info8 = [[CustomInfo alloc]init];
//  info8.name = @"hbv";
//  info8.email = @"-k8pma,.sdasd ,ad;'alsdmasd";
//  info8.address = @"asdasdasdasd";
//  info8.idnum = @"azcqwevsczq zxcaq8c";
//  info8.note = @"m cxklb,m ,asdl c,mnfjwb8i";
//  info8.agent = 1;
//  CustomInfo *info9 = [[CustomInfo alloc]init];
//  info9.name = @"ibv";
//  info9.email = @"-k9pma,.sdasd ,ad;'alsdmasd";
//  info9.address = @"asdasdasdasd";
//  info9.idnum = @"azcqwevsczq zxcaq9c";
//  info9.note = @"m cxklb,m ,asdl c,mnfjwb9i";
//  info9.agent = 1;
//  CustomInfo *info10 = [[CustomInfo alloc]init];
//  info10.name = @"kbv";
//  info10.email = @"-k10pma,.sdasd ,ad;'alsdmasd";
//  info10.address = @"asdasdasdasd";
//  info10.idnum = @"azcqwevsczq zxcaq10c";
//  info10.note = @"m cxklb,m ,asdl c,mnfjwb10i";
//  info10.agent = 1;
//  CustomInfo *info11 = [[CustomInfo alloc]init];
//  info11.name = @"wbv";
//  info11.email = @"-k11pma,.sdasd ,ad;'alsdmasd";
//  info11.address = @"asdasdasdasd";
//  info11.idnum = @"azcqwevsczq zxcaq11c";
//  info11.note = @"m cxklb,m ,asdl c,mnfjwb11i";
//  info11.agent = 1;
//  self.contacts = [NSArray arrayWithObjects:info1,info2,info4,info4,info5,info6,info7,info8,info9,info10,info11,nil];
    CustomInfoManagement *customManage = [CustomInfoManagement shareInstance];
    NSArray *customes = [customManage getCustomInfo];
    self.contacts = [NSArray arrayWithArray:customes];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCustom)];
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

- (void)addNewCustom {
    CustomInfo *customInfo = [[CustomInfo alloc]init];
    MEditCustomInfoViewController *editCustomInfoViewController = [[MEditCustomInfoViewController alloc]initWithCustom:customInfo];
    [self.navigationController pushViewController:editCustomInfoViewController animated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MShowCustomDetailViewController *showDetailViewController = [[MShowCustomDetailViewController alloc]initWithCustomInfo:[_contacts objectAtIndex:indexPath.section][indexPath.row]];
  
  [self.navigationController pushViewController:showDetailViewController animated:YES];
}
@end