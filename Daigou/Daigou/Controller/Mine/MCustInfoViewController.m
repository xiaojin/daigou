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
#import "OAddNewOrderViewController.h"
#import "OrderDetailViewController.h"

@interface MCustInfoViewController ()
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *indexList;
@end

@implementation MCustInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        return  [self initWithStyle:UITableViewStylePlain];
    }
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self checkIsFromOrder]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCustom)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CustomInfoManagement *customManage = [CustomInfoManagement shareInstance];
    NSArray *customes = [customManage getCustomInfo];
    self.contacts = [NSArray arrayWithArray:customes];
    [self.tableView reloadData];
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

- (BOOL) checkIsFromOrder {
    NSArray *viewController = self.navigationController.viewControllers;
    __block BOOL result = NO;
    [viewController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[OrderDetailViewController class]]) {
            result = YES;
        }
    }];
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self checkIsFromOrder]) {
        NSArray *viewController = self.navigationController.viewControllers;
        [viewController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[OrderDetailViewController class]]) {
                UIViewController *viewcontroler = [[(OrderDetailViewController *)obj childViewControllers][0]  childViewControllers][0];
                if ([viewcontroler isKindOfClass:[OAddNewOrderViewController class]]) {
                        OAddNewOrderViewController *editNewOrderViewController = (OAddNewOrderViewController *)viewcontroler;
                        editNewOrderViewController.customInfo =[_contacts objectAtIndex:indexPath.section][indexPath.row];
                        [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    } else {
        MShowCustomDetailViewController *showDetailViewController = [[MShowCustomDetailViewController alloc]initWithCustomInfo:[_contacts objectAtIndex:indexPath.section][indexPath.row]];
        
        [self.navigationController pushViewController:showDetailViewController animated:YES];
    }

}
@end