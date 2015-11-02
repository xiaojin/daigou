//
//  UISelectContainerViewController.m
//  Daigou
//
//  Created by jin on 9/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UISelectContainerViewController.h"
#import <Masonry/Masonry.h>

@interface UISelectContainerViewController ()
@property(nonatomic, strong)UIView *subView;
@end

@implementation UISelectContainerViewController

- (instancetype)initWithSubView:(UIView *)subView {
    if (self = [super init]) {
        _subView = subView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addSubview:_subView];
    [_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
