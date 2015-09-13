//
//  MCustInfoViewController.h
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomInfo;
@protocol MCustInfoViewControllerDelegate<NSObject>
- (void)didSelectCustomInfo:(CustomInfo *)customInfo;
@end

@interface MCustInfoViewController : UITableViewController
@property (nonatomic,weak)id<MCustInfoViewControllerDelegate> customDelegate;
@end
