//
//  MEditCustomDetailCell.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditCustomDetailCell.h"
#define CUSTOMINFOTITLEWIDTH 80.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGRIGHT 20.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 16.0f
@interface MEditCustomDetailCell()
@property(nonatomic, strong)UILabel *titleName;
@property(nonatomic, strong)UILabel *detailInfo;
@end

@implementation MEditCustomDetailCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *seperateCell = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame)-1, CGRectGetWidth(self.frame), 1)];
    [seperateCell setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:seperateCell];
}
@end