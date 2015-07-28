//
//  OrderProductDockView.h
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DockTableViewDelegate <NSObject>
- (void)dockClickIndexRow:(NSMutableArray *)row index:(NSIndexPath *)index indexPath:(NSIndexPath *)indexPath;
@end

@interface OrderProductDockView : UITableView

@property(nonatomic, strong)NSMutableArray *dockArray;
@property(nonatomic, weak)id <DockTableViewDelegate> dockDelegate;

@end
