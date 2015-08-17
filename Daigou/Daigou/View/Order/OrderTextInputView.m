//
//  OrderTextInputView.m
//  Daigou
//
//  Created by jin on 17/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderTextInputView.h"

@implementation OrderTextInputView

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    [self.orderCellDelegate clickEditingField:self];
    //TODO  MCustInfoViewController
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _EditPriceActionBlock(12);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.detailInfo setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
}

@end
