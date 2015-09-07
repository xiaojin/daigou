//
//  UIProductInfoEditViewController.m
//  Daigou
//
//  Created by jin on 8/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UIProductInfoEditViewController.h"
#import "UIPlaceHolderTextView.h"

@interface UIProductInfoEditViewController ()
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)UIPlaceHolderTextView *contentTextView;

@end

@implementation UIProductInfoEditViewController

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        _content = content;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    _contentTextView = [[UIPlaceHolderTextView alloc]init];
    [_contentTextView setBackgroundColor:[UIColor whiteColor]];
    _contentTextView.font = [UIFont systemFontOfSize:14.0f];
    _contentTextView.placeholder = @"编辑信息";
    _contentTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self.view addSubview:_contentTextView];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
