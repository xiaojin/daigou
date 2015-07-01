//
//  MShowCustomDetailCell.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MShowCustomDetailCell.h"
#define CUSTOMINFOTITLEWIDTH 80.0f
#define CONTENTPADDINGLEFT 10.0f
#define CONTENTPADDINGRIGHT 20.0f
#define LEABELINPUTFIELDGAPPING 10.0f
#define FONTSIZE 16.0f
@interface MShowCustomDetailCell()
@property(nonatomic, strong)UILabel *titleName;
@property(nonatomic, strong)UILabel *detailInfo;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *value;
@end

@implementation MShowCustomDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.titleName = [[UILabel alloc]initWithFrame:CGRectMake(CONTENTPADDINGLEFT, 0, CUSTOMINFOTITLEWIDTH, CGRectGetHeight(self.contentView.frame))];
  self.titleName.font = [UIFont systemFontOfSize:FONTSIZE];
  self.titleName.textColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:1.0f];
  self.titleName.textAlignment = NSTextAlignmentLeft;
  [self.contentView addSubview:self.titleName];
  
  CGFloat textFieldX = CGRectGetWidth(self.titleName.frame) + CONTENTPADDINGLEFT+ LEABELINPUTFIELDGAPPING;
  CGFloat textFieldwith = CGRectGetWidth(self.contentView.frame) - textFieldX- CONTENTPADDINGRIGHT;
  self.detailInfo = [[UILabel alloc]initWithFrame:CGRectMake(textFieldX , 0, textFieldwith, CGRectGetHeight(self.contentView.frame))];
  self.detailInfo.font = [UIFont systemFontOfSize:FONTSIZE];
  self.detailInfo.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
  self.detailInfo.textAlignment = NSTextAlignmentLeft;
  self.detailInfo.lineBreakMode = NSLineBreakByTruncatingTail;
  [self.contentView addSubview:self.detailInfo];
  UIView *seperateCell = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame)-1, CGRectGetWidth(self.frame), 1)];
  [seperateCell setBackgroundColor:[UIColor lightGrayColor]];
  [self addSubview:seperateCell];
  self.titleName.text = _title;
  self.detailInfo.text = _value;
  NSLog(@"%@",NSStringFromCGSize(self.frame.size));
}
- (void)updateCellWithTitle:(NSString*)titleName detailInformation:(NSString*)detailInfo{
    self.title =titleName;
    self.value = detailInfo;

}

@end
