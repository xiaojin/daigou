//
//  UIProductInfoEditViewController.h
//  Daigou
//
//  Created by jin on 8/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIProductInfoEditViewControllerDelegate<NSObject>
-(void)didFinishEditing:(NSString *)content withTag:(NSInteger)tag;
@end
@interface UIProductInfoEditViewController : UIViewController
@property(nonatomic, assign)id<UIProductInfoEditViewControllerDelegate> delegate;
- (instancetype)initWithContent:(NSString *)content withTextFieldTag:(NSInteger)tag;
@end
