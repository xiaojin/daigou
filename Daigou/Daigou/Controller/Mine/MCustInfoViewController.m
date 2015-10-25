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
#import "UIScanViewController.h"
#import "HttpPromiseRequestOperation.h"
#import <CHCSVParser/CHCSVParser.h>
#import "NSString+StringToPinYing.h"


@interface MCustInfoViewController ()<UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate, UIScanViewControllerDelegate,CHCSVParserDelegate>
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *indexList;
@property(nonatomic, strong) NSMutableArray *currentRow;
@property(nonatomic, strong) NSMutableArray *csvArray;
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
    UIActionSheet *addCustomInfoStype = [[UIActionSheet alloc]initWithTitle:@"添加联系人信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从通讯录导入",@"自定义添加联系人",@"批量导入客户信息",nil];
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
        addressBook.ename = [nameString transformToPinyin];
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

- (void) bunchImportCustomInfo {
    UIScanViewController *scaViewController = [[UIScanViewController alloc] init];
    scaViewController.isQR = NO;
    // 2. configure ViewController
    scaViewController.delegate = self;
    
    // 3. show ViewController
    [self presentViewController:scaViewController animated:YES completion:nil];
}

- (void)handlerContacter:(NSString *)downloadURL {
    [self downloadContact:downloadURL];
}

- (RXPromise *)downloadContact:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:url];

    HttpPromiseRequestOperation *operation = [HttpPromiseRequestOperation operationWithRequest:downloadRequest];
    
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead: %ld, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    @weakify(self);
    return [operation startPromise].then(^id(NSData *data){
        @strongify(self);
        NSInputStream *inputSteam = [[NSInputStream alloc]initWithData:data];
        NSStringEncoding encoding = NSUTF8StringEncoding;
        CHCSVParser *csvParser = [[CHCSVParser alloc] initWithInputStream:inputSteam usedEncoding:&encoding delimiter:','];
        csvParser.delegate = self;
        _csvArray = [[NSMutableArray alloc] init];
        [csvParser parse];          
        return data;
        //parse csv file
    },^id(NSError *error){
        return error;
    });
}

#pragma mark -- CHCSParseDelegate
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentRow = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    [_currentRow addObject:field];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_csvArray addObject:_currentRow];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
    [self savePeopleInfo];
    NSLog(@"did finish parse Contact Name");
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}


- (void)savePeopleInfo {
    //名字，地址，电话，身份证号，电子邮箱，备用地址，备用地址，备用地址，备注
    CustomInfoManagement *customInfoManagement = [CustomInfoManagement shareInstance];
    for (int i = 1; i < _csvArray.count; i++) {
        NSArray *row = [_csvArray objectAtIndex:i];
        CustomInfo *customInfo = [[CustomInfo alloc] init];
        customInfo.name = [self replaceCharacter:[row objectAtIndex:0]];
        customInfo.address = [self replaceCharacter:[row objectAtIndex:1]];
        customInfo.phonenum = [self replaceCharacter:[row objectAtIndex:2]];
        customInfo.idnum = [self replaceCharacter:[row objectAtIndex:3]];
        customInfo.email = [self replaceCharacter:[row objectAtIndex:4]];
        customInfo.address1 = [self replaceCharacter:[row objectAtIndex:5]];
        customInfo.address2 = [self replaceCharacter:[row objectAtIndex:6]];
        customInfo.address3 = [self replaceCharacter:[row objectAtIndex:7]];
        [customInfoManagement insertCustomInfo:customInfo];
    }
}

- (NSString *)replaceCharacter:(NSString *)objectString {
    objectString = [objectString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    objectString = [objectString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    objectString = [objectString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return objectString;
}
#pragma mark --scameBarcode

- (void)didFinishedReadingQR:(NSString *)string {
    [self handlerContacter:string];
    NSLog(@"%@",string);
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
        editCustomInfoViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:editCustomInfoViewController animated:YES];

    } else if (buttonIndex == 2) {
        [self bunchImportCustomInfo];
    } else if (buttonIndex == 3) {
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
        editDetailViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:editDetailViewController animated:YES];
    }

}
@end