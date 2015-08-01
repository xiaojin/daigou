//
//  OrderProductsRightTableView.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderProductsRightTableView.h"
#import "OrderProductsRightCell.h"
#import "CommonDefines.h"
@interface OrderProductsRightTableView()<UITableViewDelegate, UITableViewDataSource>
@end
@implementation OrderProductsRightTableView
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _rightArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderProductsRightCell *cell =[OrderProductsRightCell cellWithTableView:tableView];
    cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,Product *product){
        if ([self.rightDelegate respondsToSelector:@selector(quantity:money:product:)]) {
            [self.rightDelegate quantity:pageIndex money:money product:product];
        }
        
    };
    cell.backgroundColor=RGB(246, 246, 246);
    cell.product=_rightArray[indexPath.row];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
