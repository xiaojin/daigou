//
//  MAddCusInfoViewController.m
//  Daigou
//
//  Created by jin on 27/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MAddCusInfoViewController.h"
#define kADDCUSTOMINFOCELLIDENTITY  @"ADDCUSTOMINFOCELLIDENTITY"
@interface MAddCusInfoViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@end
@implementation MAddCusInfoViewController

//- (void)loadView
//{
//  [super loadView];
//  
//  self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//  self.scrollView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
//  self.scrollView.delegate = self;
//  
//  
//  self.inputTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
//  self.inputTableView.delegate = self;
//  self.inputTableView.dataSource = self;
//  
//  [self.view addSubview:self.inputTableView];
//  
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return 8;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  MAddCustomInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kADDCUSTOMINFOCELLIDENTITY];
//  if (infoCell == nil) {
//    infoCell = [[MAddCustomInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kADDCUSTOMINFOCELLIDENTITY];
//  }
//  return infoCell;
//}


@end
