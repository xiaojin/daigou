//
//  MExpressManagementViewController.m
//  Daigou
//
//  Created by jin on 14/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MExpressManagementViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "MEditExpressViewController.h"
#import "Express.h"
#import "ExpressManagement.h"

@interface MExpressManagementViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *expressTableView;
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSArray *expressList;
@end

@implementation MExpressManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    _expressTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _expressTableView.dataSource = self;
    _expressTableView.delegate = self;
    _expressTableView.rowHeight = 45.0f;
    [self.view addSubview:_expressTableView];
    [_expressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.expressList = [self getExpress];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)initNavigationBar {
    UIImage *menuIcon= [IonIcons imageWithIcon:ion_plus iconColor:SYSTEMBLUE iconSize:24.0f imageSize:CGSizeMake(24.0f, 24.0f)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:menuIcon style:UIBarButtonItemStylePlain target:self action:@selector(addExpressCompany)];
    self.navigationItem.rightBarButtonItem = leftBarButton;
}

- (void)addExpressCompany {
    MEditExpressViewController *editExpressViewController = [[MEditExpressViewController alloc]init];
    [self.navigationController pushViewController:editExpressViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_expressDelegate expressDidSelected:expressInfo];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
