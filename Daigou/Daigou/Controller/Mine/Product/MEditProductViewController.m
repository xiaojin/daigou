//
//  MEditProductViewController.m
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditProductViewController.h"
#import "Product.h"
#import "MEditDetailCell.h"
#import "UIPlaceHolderTextView.h"
#import "ProductManagement.h"
#define TEXTFIELDFONTSIZE 16.0f
#define EDITPRODUCTVIEWTAG_START 52000
@interface MEditProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UIButton *agentButton;
    NSMutableArray *inputValue;
    CGSize keyboardSize;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)Product *prodcut;

@end

@implementation MEditProductViewController
NSString *const mEditProductDetailCellIdentify = @"MEditProductDetailCell";

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        self.prodcut = product;
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"修改信息";
 
}

- (void)addTableVIew {
    self.editTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.editTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.editTableView.delegate = self;
    self.editTableView.dataSource = self;
    self.editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.editTableView.allowsSelection = NO;
    [self.view addSubview:self.editTableView];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self addTableVIew];
}

- (void)addPickerView{
    CGFloat pickerViewHeight = 150.0f;
    CGFloat offY = CGRectGetHeight(self.view.frame) - 150.0f;
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, offY, CGRectGetWidth(self.view.frame), pickerViewHeight)];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.hidden = NO;
    [self.view addSubview:pickView];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEditDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:mEditProductDetailCellIdentify];
    if (cell == nil) {
        cell = [[MEditDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mEditProductDetailCellIdentify];
    }
    NSInteger length = [self.cellContentValues count];
    NSString *textValue = [[NSString alloc]initWithFormat:@"%@",self.cellContentValues[indexPath.row]];
    if (indexPath.row == (length -1) || indexPath.row == (length -2) || indexPath.row == (length -3)) {
        UIPlaceHolderTextView *inputView = [[UIPlaceHolderTextView alloc] initWithFrame:cell.bounds];
        [inputView setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        inputView.placeholder = [self.cellPlaceHolderValues objectAtIndex:indexPath.row];
        [inputView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        inputView.text = textValue;
        inputView.tag = EDITPRODUCTVIEWTAG_START + indexPath.row;
        inputView.delegate = self;
        [cell.contentView addSubview:inputView];
    } else {
        UITextField *inputText = [[UITextField alloc]initWithFrame:cell.bounds];
        inputText.placeholder = [self.cellPlaceHolderValues objectAtIndex:indexPath.row];
        [inputText setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [inputText setLeftViewMode:UITextFieldViewModeAlways];
        [inputText setLeftView:spacerView];
        [inputText setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        NSInteger tag = EDITPRODUCTVIEWTAG_START + indexPath.row;
        textValue = textValue;
        inputText.tag = tag;
        inputText.text = textValue;
        inputText.delegate = self;
        [cell.contentView addSubview:inputText];
    }
    return cell;
}
#pragma mark - UINotification

- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [self.editTableView contentInset];
        edgeInsets.bottom = 0;
        [self.editTableView setContentInset:edgeInsets];
        edgeInsets = [self.editTableView scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [self.editTableView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

#pragma mark - ScrollTableViewWhenKeyboard 
- (void)moveContentToActiveEditingField:(NSInteger) index {
    CGFloat kbHeight = keyboardSize.height;
    [UIView animateWithDuration:0.1 animations:^{
        UIEdgeInsets edgeInsets = [self.editTableView contentInset];
        edgeInsets.bottom = kbHeight;
        [self.editTableView setContentInset:edgeInsets];
        edgeInsets = [self.editTableView scrollIndicatorInsets];
        edgeInsets.bottom = kbHeight;
        [self.editTableView setScrollIndicatorInsets:edgeInsets];
        [self.editTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellPlaceHolderValues count];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSInteger index = textView.tag - EDITPRODUCTVIEWTAG_START;
    [self moveContentToActiveEditingField:index];
    NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if (textView.tag == 51002) {
//        _customInfo.address = textView.text;
//    } else if(textView.tag == 51005){
//        _customInfo.note = textView.text;
//    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger index = textField.tag - EDITPRODUCTVIEWTAG_START;
    [self moveContentToActiveEditingField:index];
    if (textField.tag == 52001 || textField.tag == 52002) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField.tag == 51000) {
//        _customInfo.name = textField.text;
//    } else if(textField.tag == 51001){
//        _customInfo.email = textField.text;
//    } else if(textField.tag == 51003){
//        _customInfo.idnum = textField.text;
//    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.brands.count;
}
#pragma mark - UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {


}

#pragma mark - SaveProductInfo
- (void)saveProductInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    
    if ([_prodcut.name isEqualToString:@""] || _prodcut.pid == 0 || _prodcut.categoryid == 0) {
        return;
    }
    ProductManagement *prodcutManager = [ProductManagement shareInstance];
    BOOL result = [prodcutManager updateProduct:_prodcut];
    if (result) {
//        NSArray *controllers = self.navigationController.childViewControllers;
//        NSInteger length = [controllers count];
//        if ([[controllers objectAtIndex:length-2] isKindOfClass:[MShowCustomDetailViewController class]]) {
//            MShowCustomDetailViewController *showDetailView =  (MShowCustomDetailViewController *)[controllers lastObject];
//            showDetailView.customInfo = _customInfo;
//        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
