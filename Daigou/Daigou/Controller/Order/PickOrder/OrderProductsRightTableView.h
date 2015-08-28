//
//  OrderProductsRightTableView.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@protocol RightTableViewDelegate <NSObject>

-(void)quantity:(NSInteger)quantity money:(NSInteger)money product:(Product *)product;

@end

@interface OrderProductsRightTableView : UITableView
@property (nonatomic ,strong) NSArray *rightArray;
@property (nonatomic ,weak) id<RightTableViewDelegate>rightDelegate;

@end
