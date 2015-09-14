//
//  MExpressManagementViewController.h
//  Daigou
//
//  Created by jin on 14/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Express;
@protocol MExpressManagementViewControllerDelegate<NSObject>
- (void)expressDidSelected:(Express *)express;
@end
@interface MExpressManagementViewController : UIViewController
@property(nonatomic, weak)id<MExpressManagementViewControllerDelegate> expressDelegate;
@end
