//
//  OrderItemView.h
//  Daigou
//
//  Created by jin on 15/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItemView;
@protocol OrderCellDelegate <NSObject>
@optional
- (void)moveContentToActiveEditingField:(NSNumber *)cellIndex;
- (void)clickEditingField:(OrderItemView *)orderItem;
@end

@interface OrderItemView : UITableViewCell
@property(nonatomic, assign) id <OrderCellDelegate> orderCellDelegate;
@property(nonatomic, strong)UITextField *detailInfo;
@property(nonatomic, strong)UILabel *titleName;

- (void)updateCellWithTitle:(NSString*)titleName detailInformation:(NSString*)detailInfo;
@end
