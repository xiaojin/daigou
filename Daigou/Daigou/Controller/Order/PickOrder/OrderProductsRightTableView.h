//
//  OrderProductsRightTableView.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RightTableViewDelegate <NSObject>

-(void)quantity:(NSInteger)quantity money:(NSInteger)money key:(NSInteger )key;

@end

@interface OrderProductsRightTableView : UITableView
@property (nonatomic ,strong) NSMutableArray *rightArray;
@property (nonatomic ,weak) id<RightTableViewDelegate>rightDelegate;

@end
