//
//  UIEditFieldView.h
//  Daigou
//
//  Created by jin on 13/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+UITextFieldAccessory.h"
#import "JVFloatLabeledTextField.h"

@interface UIEditFieldView : UIView
@property (nonatomic, strong) JVFloatLabeledTextField *textField;
@property (nonatomic, assign) BOOL dollarSign;
@property (nonatomic, strong) NSString *dollarCharacter;
- (instancetype)initWithSize:(CGSize)frameSize withController:(UIViewController *)controlller withPlaceHolder:(NSString *)placeHolder;
@end
