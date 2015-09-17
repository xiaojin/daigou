//
//  MAddressCollectionViewController.m
//  Daigou
//
//  Created by jin on 16/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MAddressCollectionViewController.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"
#import "CustomInfo.h"
@interface MAddressCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *addressTableView;
@property(nonatomic,strong)CustomInfo *customInfo;
@property(nonatomic,strong)NSMutableArray *addressArray;
@end

@implementation MAddressCollectionViewController


- (instancetype)initWithCustomInfo:(CustomInfo *)customInfo {
    if (self = [super init]) {
        _customInfo = customInfo;
        _addressArray = [NSMutableArray array];
        [self initAddressArray];
    }
    return self;
}

- (void)initAddressArray {
    if (_customInfo.address!=nil && ![_customInfo.address isEqualToString:@""]) {
        [_addressArray addObject:_customInfo.address];
    }
    if (_customInfo.address1!=nil && ![_customInfo.address1 isEqualToString:@""]) {
        [_addressArray addObject:_customInfo.address1];
    }
    if (_customInfo.address2!=nil && ![_customInfo.address2 isEqualToString:@""]) {
        [_addressArray addObject:_customInfo.address2];
    }
    if (_customInfo.address3!=nil && ![_customInfo.address3 isEqualToString:@""]) {
        [_addressArray addObject:_customInfo.address3];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    _addressTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _addressTableView.delegate = self;
    _addressTableView.dataSource = self;
    _addressTableView.rowHeight = 45.0f;

    [self.view addSubview:_addressTableView];
    [_addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AddressCollectionBookCellIdentifier = @"AddressCollectionTableViewCell";
    
    UITableViewCell *cell = [self.addressTableView dequeueReusableCellWithIdentifier:AddressCollectionBookCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressCollectionBookCellIdentifier];
    }

    cell.textLabel.text = _addressArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *address = _addressArray[indexPath.row];
    [_delegate addressDidSelect:address];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
