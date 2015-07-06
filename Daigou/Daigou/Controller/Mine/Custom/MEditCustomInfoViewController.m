//
//  MEditCustomInfoViewController.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditCustomInfoViewController.h"
#import "UIPlaceHolderTextView.h"
#import "CustomInfo.h"
#import "MEditCustomDetailCell.h"
#import "CustomInfoManagement.h"
#import "MShowCustomDetailViewController.h"
#define TEXTFIELDFONTSIZE 16.0f
@interface MEditCustomInfoViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>{
    NSMutableArray *placeHolderValue;
    UIButton *agentButton;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)CustomInfo *customInfo;
@end


@implementation MEditCustomInfoViewController

NSString *const tableviewCellIdentity = @"MEditCustomDetailCell";

- (instancetype)initWithCustom:(CustomInfo*)custom {
    if (self = [super init]) {
        self.customInfo = custom;
        [self initTableViewCellValue];
        self.editTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:self.editTableView];
        self.editTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
        self.editTableView.delegate = self;
        self.editTableView.dataSource = self;
        self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.editTableView.allowsSelection = NO;
        self.editTableView.scrollEnabled = NO;
   }
    return self;
}

- (void)loadView
{
    [super loadView];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveCustomInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"修改信息";

}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
}

- (void)viewDidLoad{
    [super viewDidLoad];

}
- (void)initTableViewCellValue {
    placeHolderValue = [NSMutableArray array];
    [placeHolderValue addObject:@"姓名"];
    [placeHolderValue addObject:@"邮箱"];
    [placeHolderValue addObject:@"地址"];
    [placeHolderValue addObject:@"身份证"];
    [placeHolderValue addObject:@"代理"];
    [placeHolderValue addObject:@"备注"];
}

-(IBAction)showAgent:(id)sender{
    UIActionSheet *agent = [[UIActionSheet alloc]initWithTitle:@"代理" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [agent showInView:self.view];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEditCustomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:tableviewCellIdentity];
    if (cell == nil) {
        cell = [[MEditCustomDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableviewCellIdentity];
    }
    if (indexPath.row == 2) {
        UIPlaceHolderTextView *addressInputView = [[UIPlaceHolderTextView alloc] initWithFrame:cell.bounds];
        [addressInputView setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        addressInputView.placeholder = [placeHolderValue objectAtIndex:indexPath.row];
        [addressInputView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        addressInputView.text = self.customInfo.address;
        addressInputView.tag = 51002;
        addressInputView.delegate = self;
        [cell.contentView addSubview:addressInputView];
    } else if (indexPath.row == 4){
        agentButton = [[UIButton alloc]initWithFrame:cell.bounds];
        [agentButton addTarget:self action:@selector(showAgent:) forControlEvents:UIControlEventTouchUpInside];
        [agentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [agentButton.titleLabel setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        agentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        agentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [agentButton setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        NSString *agentTitle = @"否";
        if (_customInfo.agent == 0) {
            agentTitle = @"否";
        } else if (_customInfo.agent == 1){
            agentTitle = @"是";
        }
        [agentButton setTitle:agentTitle forState:UIControlStateNormal];
        agentButton.tag = 51004;
        [cell.contentView addSubview:agentButton];
    } else if(indexPath.row == 5){
        UIPlaceHolderTextView *noteInputView = [[UIPlaceHolderTextView alloc]initWithFrame:cell.bounds];
        noteInputView.placeholder = [placeHolderValue objectAtIndex:indexPath.row];
        [noteInputView setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        [noteInputView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        noteInputView.text = _customInfo.note;
        noteInputView.tag = 51005;
        noteInputView.delegate = self;
        [cell.contentView addSubview:noteInputView];
    } else {
        UITextField *inputText = [[UITextField alloc]initWithFrame:cell.bounds];
        inputText.placeholder = [placeHolderValue objectAtIndex:indexPath.row];
        [inputText setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [inputText setLeftViewMode:UITextFieldViewModeAlways];
        [inputText setLeftView:spacerView];
        [inputText setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        NSString *textValue = @"";
        NSInteger tag = 0;
        switch (indexPath.row) {
            case 0:
                textValue = self.customInfo.name;
                tag = 51000;
                break;
            case 1:
                textValue = _customInfo.email;
                tag = 51001;
                break;
            case 3:
                textValue = _customInfo.idnum;
                tag = 51003;
                break;
            default:
                break;
        }
        inputText.tag = tag;
        inputText.text = textValue;
        inputText.delegate = self;
        [cell.contentView addSubview:inputText];
    }
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [placeHolderValue count];
}

#pragma mark - UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _customInfo.agent = 1;
    } else {
        _customInfo.agent = 0;
    }
    agentButton.titleLabel.text = _customInfo.agent ? @"是":@"否";
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 51002) {
        _customInfo.address = textView.text;
    } else if(textView.tag == 51005){
        _customInfo.note = textView.text;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 51000) {
        _customInfo.name = textField.text;
    } else if(textField.tag == 51001){
        _customInfo.email = textField.text;
    } else if(textField.tag == 51003){
        _customInfo.idnum = textField.text;
    }
}

#pragma mark - SaveCustomInfo
- (void)saveCustomInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    if ([_customInfo.name isEqualToString:@""] || _customInfo.name == nil) {
        return;
    }
    CustomInfoManagement *customManager = [CustomInfoManagement shareInstance];
    BOOL result = [customManager updateCustomInfo:_customInfo];
    if (result) {
        NSArray *controllers = self.navigationController.childViewControllers;
        NSInteger length = [controllers count];
        if ([[controllers objectAtIndex:length-2] isKindOfClass:[MShowCustomDetailViewController class]]) {
            MShowCustomDetailViewController *showDetailView =  (MShowCustomDetailViewController *)[controllers lastObject];
            showDetailView.customInfo = _customInfo;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end