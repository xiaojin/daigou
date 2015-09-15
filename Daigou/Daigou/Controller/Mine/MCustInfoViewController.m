//
//  MCustInfoViewController.m
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MCustInfoViewController.h"
#import "CustomInfo.h"
#import "MEditCustomInfoViewController.h"
#import "CustomInfoManagement.h"
#import "OrderMainInfoViewController.h"
#import "OrderDetailViewController.h"
#import  <AddressBookUI/AddressBookUI.h>
#import "CommonDefines.h"
#import "DGAddressBook.h"
#import "AddressBookTableViewController.h"
#import "MineViewController.h"

@interface MCustInfoViewController ()<UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate>
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
    if ([self checkIsInMineViewController]) {
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
    
    UIActionSheet *addCustomInfoStype = [[UIActionSheet alloc]initWithTitle:@"添加联系人信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从通讯录导入",@"自定义添加联系人",nil];
    [addCustomInfoStype showFromTabBar:self.tabBarController.tabBar];

}



- (void)addPeopleInfoFromAddressbook {
    UIAlertView *cantAddContactAlert = nil;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"通讯录设置" message: @"请在iPhone设置－隐私－通讯录中允许访问通讯录" delegate:nil cancelButtonTitle: @"取消" otherButtonTitles:nil];
    } else {
        cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"通讯录设置" message: @"请在iPhone设置－隐私－通讯录中允许访问通讯录" delegate:nil cancelButtonTitle: @"取消" otherButtonTitles:@"设置",nil];
    }
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
//        NSLog(@"Denied");

        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        [self getUserInfoFromAddressBook];
//        NSLog(@"Authorized");
//        [self addPetToContacts:sender];
    } else{
        //3 ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    //4
                    [cantAddContactAlert show];
                    return;
                }
                //5
                 [self getUserInfoFromAddressBook];
                //[self addPetToContacts:sender];
            });
        });
    }
}

- (void)getUserInfoFromAddressBook {
    ABAddressBookRef addressBooks = nil;
    addressBooks = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        DGAddressBook *addressBook = [[DGAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty,
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    [self showContactDateInTableView:addressBookTemp];
}

- (void) showContactDateInTableView:(NSArray *)addressList{
    AddressBookTableViewController *booktableViewController = [[AddressBookTableViewController alloc]initWithAddressPeopleInfo:addressList];
    booktableViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:booktableViewController animated:YES];
}


#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && !(SYSTEM_VERSION_LESS_THAN(@"8.0"))) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate




#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"从通讯录导入");
        [self addPeopleInfoFromAddressbook];
    } else if (buttonIndex == 1){
        NSLog(@"自定义添加联系人");
        CustomInfo *customInfo = [[CustomInfo alloc]init];
        MEditCustomInfoViewController *editCustomInfoViewController = [[MEditCustomInfoViewController alloc]initWithCustom:customInfo];
        editCustomInfoViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editCustomInfoViewController animated:YES];

    } else if (buttonIndex == 2){
        NSLog(@"Cancel");
    }

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

- (BOOL) checkIsInMineViewController {
    NSArray *viewController = self.navigationController.viewControllers;
    __block BOOL result = NO;
    [viewController enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MineViewController class]]) {
            result = YES;
        }
    }];
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self checkIsInMineViewController]) {
        [_customDelegate didSelectCustomInfo:[_contacts objectAtIndex:indexPath.section][indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        MEditCustomInfoViewController *editDetailViewController = [[MEditCustomInfoViewController alloc]initWithCustom:[_contacts objectAtIndex:indexPath.section][indexPath.row]];
        
        [self.navigationController pushViewController:editDetailViewController animated:YES];
    }

}
@end