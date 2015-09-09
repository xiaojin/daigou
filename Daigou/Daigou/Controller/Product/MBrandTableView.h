//
//  MBrandTableView.h
//  Daigou
//
//  Created by jin on 9/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Brand;
@protocol MBrandTableViewDelegate<NSObject>
- (void)brandDidSelected:(Brand *)brand;
@end

@interface MBrandTableView : UIView
@property(nonatomic, assign)id<MBrandTableViewDelegate> delegate;
@property(nonatomic, strong) UITableView *brandTableView;

@end
