//
//  UIProductInfoEditViewController.m
//  Daigou
//
//  Created by jin on 8/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UIProductInfoEditViewController.h"
#import "UIPlaceHolderTextView.h"

@interface UIProductInfoEditViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)UIPlaceHolderTextView *contentTextView;
@property(nonatomic, assign)NSInteger tag;

@end

@implementation UIProductInfoEditViewController

- (instancetype)initWithContent:(NSString *)content withTextFieldTag:(NSInteger)tag{
    if (self = [super init]) {
        _content = content;
        _tag = tag;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    _contentTextView = [[UIPlaceHolderTextView alloc]init];
    [_contentTextView setBackgroundColor:[UIColor whiteColor]];
    _contentTextView.font = [UIFont systemFontOfSize:14.0f];
    _contentTextView.placeholder = @"编辑信息";
    _contentTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    _contentTextView.text = _content;
    [self.view addSubview:_contentTextView];

    
    // Do any additional setup after loading the view.
}

- (void)initNavigationBar{
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)doneButtonClick {
    [_contentTextView resignFirstResponder];
    [_delegate didFinishEditing: _contentTextView.text withTag:_tag];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_contentTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
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
