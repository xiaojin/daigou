//
//  UISearchBar+UISearchBarAccessory.m
//  Daigou
//
//  Created by jin on 29/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "UISearchBar+UISearchBarAccessory.h"

@implementation UISearchBar (UISearchBarAccessory)

- (instancetype)initWithAccessory {
    if (self = [self init]) {
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
    [self.delegate searchBarSearchButtonClicked:self];
    [self resignFirstResponder];
}
@end
