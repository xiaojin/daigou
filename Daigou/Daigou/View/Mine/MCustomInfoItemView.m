//
//  MCustomInfoItemView.m
//  Daigou
//
//  Created by jin on 27/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MCustomInfoItemView.h"
@interface MCustomInfoItemView()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *titleEditField;
@property(nonatomic,strong)NSString *myTitle;
@end
@implementation MCustomInfoItemView
- (instancetype)initWIthTypeTitle:(NSString *)title viewSize:(CGSize)size{
  self = [super init];
  if (self) {
    self.myTitle = title;
    self.viewSize = size;
    [self createEditInfoItemView];
  }
  return self;
}

- (void)createEditInfoItemView{
  self.titleLabel = [UILabel alloc]initWithFrame:<#(CGRect)#>

}


@end
