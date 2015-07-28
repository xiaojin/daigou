//
//  OrderDockCell.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderDockCell.h"
#import "CommonDefines.h"
@implementation OrderDockCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *categoryLbl =[[UILabel alloc]initWithFrame:(CGRect){0,0,75,50}];
        [self.contentView addSubview:categoryLbl];
        _category=categoryLbl;
        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,49.5,75,0.5}];
        viewShow.backgroundColor=[UIColor blackColor];
        viewShow.alpha=0.4;
        [self.contentView addSubview:viewShow];
        
        UIView *viewShow1 =[[UIView alloc]initWithFrame:(CGRect){0,0,2,50}];
        viewShow1.backgroundColor=RGB(255, 127, 0);
        [self.contentView addSubview:viewShow1];
        
        viewShow1.hidden=YES;
        _ViewShow=viewShow1;
    }
    return self;
}

-(void)setCategoryText:(NSString *)categoryText
{
    _category.text=categoryText;
    _category.textAlignment=NSTextAlignmentCenter;
    _category.font=Font(16);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderDockCell";
    OrderDockCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderDockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

@end
