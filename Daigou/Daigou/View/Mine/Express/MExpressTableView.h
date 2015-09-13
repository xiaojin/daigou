//
//  MExpressTableView.h
//  Daigou
//
//  Created by jin on 13/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Express;
@protocol MExpressTableViewDelegate<NSObject>
- (void)expressDidSelected:(Express *)express;
@end
@interface MExpressTableView : UIView
@property(nonatomic, assign)id<MExpressTableViewDelegate> delegate;
@property(nonatomic, strong) UITableView *expressTableView;
@end
