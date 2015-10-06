//
//  AddNewProcurementViewController.h
//  Daigou
//
//  Created by jin on 5/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddNewProcurementViewControllerDelegate
- (void)didFinishAddNewProcurement;
@end

@interface AddNewProcurementViewController : UIViewController
@property (nonatomic, weak)id<AddNewProcurementViewControllerDelegate> delegate;
@end
