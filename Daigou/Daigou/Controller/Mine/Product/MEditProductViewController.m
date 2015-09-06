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
#import "Brand.h"
#import "ProductCategory.h"
#import "MShowProductDetailViewController.h"
#import "ProductCategoryManagement.h"
#import "BrandManagement.h"

#define TEXTFIELDFONTSIZE 16.0f
#define EDITPRODUCTVIEWTAG_START 52000
@interface MEditProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UIButton *agentButton;
    NSMutableArray *inputValue;
    CGSize keyboardSize;
    NSInteger pickerIndex;
    UIButton *clikedButton;
}
@property(nonatomic, strong)UITableView *editTableView;
@property(nonatomic, strong)Product *prodcut;
@property(nonatomic, strong)UIView *pickMainView;
@property(nonatomic, strong)UIPickerView *pickView;
@property(nonatomic, strong)NSArray *brands;
@property(nonatomic, strong)NSArray *productCategories;
@end

@implementation MEditProductViewController
NSString *const mEditProductDetailCellIdentify = @"MEditProductDetailCell";

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        self.prodcut = product;
        if (self.cellPlaceHolderValues == nil) {
            [self initPlaceHolderValues];
        }
        [self fetchAllBrand];
        [self fetchAllCategory];
    }
    return self;
}

- (void)fetchAllBrand {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    self.brands = [brandManagement getBrand];
}


- (void)fetchAllCategory {
    ProductCategoryManagement *categoryManage = [ProductCategoryManagement shareInstance];
    self.productCategories = [categoryManage getCategory];
}

- (void)initPlaceHolderValues {
    self.cellPlaceHolderValues = @[@"名字",@"商品品牌",@"产品分类",@"型号",@"条码",@"重量",@"检索码",@"采购价格",@"出售价格",@"功效",@"卖点说明",@"备注"];
    self.cellContentValues = [NSArray array];
}

- (void)loadView
{
    [super loadView];
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductInfo)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    self.title = @"修改信息";
    //[self hideTabBar:self.tabBarController];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self showTabBar:self.tabBarController];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self addTableVIew];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEditDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:mEditProductDetailCellIdentify];
    if (cell == nil) {
        cell = [[MEditDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mEditProductDetailCellIdentify];
    
        NSInteger length = [self.cellPlaceHolderValues count];
        NSString *textValue = @"";
        if ([self.cellContentValues count] > 0) {
            textValue = [[NSString alloc]initWithFormat:@"%@",self.cellContentValues[indexPath.row]?self.cellContentValues[indexPath.row] : @""];
        }
    if (indexPath.row == (length -1) || indexPath.row == (length -2) || indexPath.row == (length -3)) {
        UIPlaceHolderTextView *inputView = [[UIPlaceHolderTextView alloc] initWithFrame:cell.bounds];
        [inputView setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        inputView.placeholder = [self.cellPlaceHolderValues objectAtIndex:indexPath.row];
        [inputView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        inputView.text = textValue;
        inputView.tag = EDITPRODUCTVIEWTAG_START + indexPath.row;
        inputView.delegate = self;
        [cell.contentView addSubview:inputView];
    } else if (indexPath.row == 1 || indexPath.row == 2){
        UIButton *button = [[UIButton alloc]initWithFrame:cell.bounds];
        [button setTitle:textValue forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = EDITPRODUCTVIEWTAG_START + indexPath.row;
        [cell.contentView addSubview:button];
    }else {
        UITextField *inputText = [[UITextField alloc]initWithFrame:cell.bounds];
        inputText.placeholder = [self.cellPlaceHolderValues objectAtIndex:indexPath.row];
        [inputText setFont:[UIFont systemFontOfSize:TEXTFIELDFONTSIZE]];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [inputText setLeftViewMode:UITextFieldViewModeAlways];
        [inputText setLeftView:spacerView];
        [inputText setFrame:CGRectMake(0, 0, CGRectGetWidth(self.editTableView.frame),CGRectGetHeight(cell.frame))];
        NSInteger tag = EDITPRODUCTVIEWTAG_START + indexPath.row;
        inputText.tag = tag;
        inputText.text = textValue;
        inputText.delegate = self;
        //inputText.keyboardType = UIKeyboardTypeDecimalPad;
        [cell.contentView addSubview:inputText];
    }
        }
    return cell;
}

- (IBAction)showPickerView:(id)sender {
    UIButton *senderButton = sender;
    NSInteger index = senderButton.tag;
    clikedButton = senderButton;
    pickerIndex = index;
    [self.view endEditing:YES];
    [self addPickerView];
}

- (void)addPickerView{
    if (self.pickMainView == nil) {
        CGFloat pickerViewHeight = 300.0f;
        CGFloat offY = CGRectGetHeight(self.view.frame) - 300.0f;
        self.pickMainView = [[UIView alloc]initWithFrame:CGRectMake(0, offY, CGRectGetWidth(self.view.frame), pickerViewHeight)];
        [self.pickMainView setBackgroundColor:[UIColor whiteColor]];
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelPickerView) forControlEvents:UIControlEventTouchUpInside];
        [self.pickMainView addSubview:cancelButton];
        
        UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-60, 0, 60, 44)];
        [doneButton setTitle:@"确认" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(pickValue) forControlEvents:UIControlEventTouchUpInside];
        [self.pickMainView addSubview:doneButton];
        
        self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 300-44)];
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.pickView.hidden = NO;
        [self.pickMainView addSubview:self.pickView];
        [self.pickView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:self.pickMainView];
    }
    [self.pickView reloadAllComponents];
    self.pickMainView.hidden = NO;
}

- (void) cancelPickerView {
    self.pickMainView.hidden = YES;
}

- (void)pickValue {
    NSInteger pickedIndex = [self.pickView selectedRowInComponent:0];
    NSString *title = @"";
    if (clikedButton.tag == 52001) {
        title = [(Brand *)self.brands[pickedIndex] name];
        self.prodcut.brandid = [(Brand *)self.brands[pickedIndex] bid];
    } else {
        title = [(ProductCategory *)self.productCategories[pickedIndex] name];
        self.prodcut.categoryid = [(ProductCategory *)self.productCategories[pickedIndex] cateid];
    }
    [clikedButton setTitle:title forState:UIControlStateNormal];
    self.pickMainView.hidden = YES;

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
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
     self.pickMainView.hidden = YES;
    NSInteger index = textView.tag - EDITPRODUCTVIEWTAG_START;
    [self moveContentToActiveEditingField:index];
    NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 52009:
            self.prodcut.function = textView.text;
            break;
        case 52010:
            self.prodcut.sellprice = [textView.text floatValue];
            break;
        case 52011:
            self.prodcut.note = textView.text;
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
     self.pickMainView.hidden = YES;
    NSInteger index = textField.tag - EDITPRODUCTVIEWTAG_START;
    [self moveContentToActiveEditingField:index];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 52000:
            self.prodcut.name = textField.text;
            break;
        case 52003:
            self.prodcut.model = textField.text;
            break;
        case 52004:
            self.prodcut.barcode = textField.text;
            break;
        default:
            break;
    }
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
    NSString *returnValue = @"";
    if (pickerIndex == 52001) {
        Brand *mybrand = (Brand *)self.brands[row];
        returnValue = [mybrand name];
    } else if(pickerIndex == 52002) {
        ProductCategory *category = (ProductCategory *)self.productCategories[row];
        returnValue = category.name;
    }
    return returnValue;
}



#pragma mark - SaveProductInfo
- (void)saveProductInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    if ([_prodcut.name isEqualToString:@""] || _prodcut.brandid == 0 || _prodcut.categoryid == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"填写信息" message:@"请填写商品名字, 品牌, 类别" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    ProductManagement *prodcutManager = [ProductManagement shareInstance];
    BOOL result = [prodcutManager updateProduct:_prodcut];
    if (result) {
        NSArray *controllers = self.navigationController.childViewControllers;
        NSInteger length = [controllers count];
        if ([[controllers objectAtIndex:length-2] isKindOfClass:[MShowProductDetailViewController class]]) {
            MShowProductDetailViewController *showDetailView =  (MShowProductDetailViewController *)[controllers objectAtIndex:(length-2)];
            showDetailView.product = self.prodcut;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - hideTabBar
// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setHidden:YES];
//            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setHidden:NO];

            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}
@end
