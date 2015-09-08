//
//  UIScanViewController.h
//  Daigou
//
//  Created by jin on 8/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
@protocol UIScanViewControllerDelegate<NSObject>
- (void)didFinishedReadingQR:(NSString *)string;

@end
@interface UIScanViewController : UIViewController
@property (nonatomic, assign) BOOL isQR;
@property(nonatomic, assign)id<UIScanViewControllerDelegate>delegate;
@end
