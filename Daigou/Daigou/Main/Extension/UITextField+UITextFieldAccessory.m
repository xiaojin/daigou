//
//  UITextField+UITextFieldAccessory.m
//  Daigou
//
//  Created by jin on 15/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UITextField+UITextFieldAccessory.h"

@implementation UITextField (UITextFieldAccessory)


- (instancetype) initHasAccessory {
    if (self = [super init]) {
        [self addAccessoryView];
    }
    return self;
}


- (void) addAccessoryView {
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screen.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.inputAccessoryView = numberToolbar;
}

- (void)doneWithNumberPad {
    [self resignFirstResponder];
}

@end
