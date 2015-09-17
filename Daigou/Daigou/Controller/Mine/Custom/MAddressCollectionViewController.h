//
//  MAddressCollectionViewController.h
//  Daigou
//
//  Created by jin on 16/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomInfo;
@protocol MAddressCollectionViewControllerDelegate <NSObject>
- (void)addressDidSelect:(NSString *)address;
@end
@interface MAddressCollectionViewController : UIViewController
- (instancetype)initWithCustomInfo:(CustomInfo *)customInfo;
@property(nonatomic,weak)id<MAddressCollectionViewControllerDelegate>delegate;
@end
