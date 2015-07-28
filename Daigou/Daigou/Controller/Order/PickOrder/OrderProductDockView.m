//
//  OrderProductDockView.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderProductDockView.h"
#import "OrderDockCell.h"
#import "CommonDefines.h"

@interface OrderProductDockView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSIndexPath *path;
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation OrderProductDockView
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(!_isSelected)
    {
        NSInteger selectedIndex = 0;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self tableView:self didSelectRowAtIndexPath:selectedIndexPath];
        _isSelected=YES;
    }
}

-(void)setDockArray:(NSMutableArray *)dockArray
{
    _dockArray=dockArray;
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dockArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDockCell *cell =[OrderDockCell cellWithTableView:tableView];
    cell.categoryText=_dockArray[indexPath.row][@"dockName"];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_path!=nil) {
        OrderDockCell *cell = (OrderDockCell *)[tableView cellForRowAtIndexPath:_path];
        cell.backgroundColor=[UIColor whiteColor];
        cell.category.textColor=[UIColor blackColor];
        cell.ViewShow.hidden=YES;
    }
    if ([_dockDelegate respondsToSelector:@selector(dockClickIndexRow:index:indexPath:)]) {
        [_dockDelegate dockClickIndexRow:_dockArray[indexPath.row][@"right"] index:_path indexPath:indexPath];
    }
    //取消选中颜色
    OrderDockCell *cell = (OrderDockCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.category.textColor=RGB(255, 127, 0);
    cell.backgroundColor=RGB(246, 246, 246);
    cell.ViewShow.hidden=NO;
    _path=indexPath;
}

@end
