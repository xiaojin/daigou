//
//  MCategoryTableView.h
//  Daigou
//
//  Created by jin on 9/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategory.h"
@protocol MCategoryTableViewDelegate<NSObject>
-(void)categoryDidSelected:(ProductCategory*)category;
@end

@interface MCategoryTableView : UIView
@property(nonatomic, assign)id<MCategoryTableViewDelegate> delegate;
@end
