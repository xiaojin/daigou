//
//  UIPickerViewCell.m
//  Daigou
//
//  Created by jin on 9/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UIPickerViewCell.h"
#import <Masonry/Masonry.h>

@interface UIPickerViewCell ()

@end

@implementation UIPickerViewCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _pickView = [[UIPickerView alloc]init];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:_pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //self.contentView addSubview:[]
}
@end
