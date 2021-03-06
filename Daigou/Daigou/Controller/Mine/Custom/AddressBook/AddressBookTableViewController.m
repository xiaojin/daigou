//
//  AddressBookTableViewController.m
//  Daigou
//
//  Created by jin on 3/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "AddressBookTableViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CommonDefines.h"
#import "DGAddressBook.h"
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "UISearchBar+UISearchBarAccessory.h"



@interface AddressBookTableViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *peopleListTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *peoples;
@property (nonatomic, strong) NSMutableArray *containsPeopleList;
@property (nonatomic, strong) NSArray *searchResultData;
@end

@implementation AddressBookTableViewController
- (instancetype)initWithAddressPeopleInfo:(NSArray *)peopleList {
    if (self = [super init]) {
        self.peoples = peopleList;
        self.searchResultData = [NSArray arrayWithArray:self.peoples];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _containsPeopleList = [NSMutableArray array];
    [self initSearchBar];
    [self initTableView];
}

- (void) initSearchBar {
    _searchBar = [[UISearchBar alloc]initWithAccessory];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    UIBarButtonItem *saveClient = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addUserContact)];
    self.navigationItem.rightBarButtonItem = saveClient;
}

- (void) initTableView {
    _peopleListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _peopleListTableView.delegate = self;
    _peopleListTableView.dataSource = self;
    _peopleListTableView.rowHeight = 45.0f;
    _peopleListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _peopleListTableView.bounds.size.width, 0.01f)];
    [self.view addSubview:_peopleListTableView];
    [_peopleListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_searchResultData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AddressBookCellIdentifier = @"AddressBookTableViewCell";
    
    UITableViewCell *cell = [self.peopleListTableView dequeueReusableCellWithIdentifier:AddressBookCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressBookCellIdentifier];
    }
    
    if ([_containsPeopleList containsObject:[_searchResultData objectAtIndex:indexPath.row]]) {
        UIImage *checkedImage = [IonIcons imageWithIcon:ion_ios_checkmark iconColor:THEMECOLOR iconSize:35.0f imageSize:CGSizeMake(35.0f, 35.0f)];
        cell.imageView.image = checkedImage;
    }
    else {
        UIImage *uncheckedImage = [IonIcons imageWithIcon:ion_ios_circle_outline iconColor:THEMECOLOR iconSize:35.0f imageSize:CGSizeMake(35.0f, 35.0f)];
        cell.imageView.image = uncheckedImage;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
    [cell.imageView addGestureRecognizer:tap];
    cell.imageView.userInteractionEnabled = YES; //added based on @John 's comment
    //[tap release];
    DGAddressBook *addressBook = [_searchResultData objectAtIndex:indexPath.row];
    cell.textLabel.text = addressBook.name;
    return cell;
}

- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapLocation = [tapRecognizer locationInView:self.peopleListTableView];
    NSIndexPath *tappedIndexPath = [self.peopleListTableView indexPathForRowAtPoint:tapLocation];
    
    if ([_containsPeopleList containsObject:[_searchResultData objectAtIndex:tappedIndexPath.row]]) {
        [_containsPeopleList removeObject:[_searchResultData objectAtIndex:tappedIndexPath.row]];
    }
    else {
        [_containsPeopleList addObject:[_searchResultData objectAtIndex:tappedIndexPath.row]];
    }
    [self.peopleListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
}

- (void)addUserContact {
    CustomInfoManagement *infoManagement = [CustomInfoManagement shareInstance];
    for (int i = 0; i< [_containsPeopleList count]; i++) {
        DGAddressBook *address = [_containsPeopleList objectAtIndex:i];
        CustomInfo *customInfo = [[CustomInfo alloc] init];
        customInfo.name = address.name;
        customInfo.email = address.email;
        customInfo.phonenum = address.tel;
        [infoManagement insertCustomInfo:customInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Sort & Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self search:searchText];
    [_peopleListTableView reloadData];
}

- (void)search:(NSString *)query {
    if (![query isEqual:@""]) {
        NSString *normalisedQuery = [NSString stringWithFormat:@"*%@*", [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ || ename LIKE[cd] %@" , normalisedQuery,normalisedQuery];
        _searchResultData = [_peoples filteredArrayUsingPredicate:predicate];
    } else {
        _searchResultData = _peoples;
    }
    
}

@end
