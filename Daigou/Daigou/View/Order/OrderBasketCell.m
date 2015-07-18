//
//  OrderBasketCell.m
//  Daigou
//
//  Created by jin on 18/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
#define NewsTitleFont [UIFont systemFontOfSize:15.0f]
#define NewsTextFont [UIFont systemFontOfSize:10.0f]
#import "OrderBasketCell.h"
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>

@interface OrderBasketCell()
@property(nonatomic, retain)IBOutlet UILabel *lblTitle;
@property(nonatomic, retain)IBOutlet UILabel *lblText;
@end

@implementation OrderBasketCell
+ (instancetype) OrderWithCell:(UITableView *)tableview;
{
    static NSString *identity =@"orderBasketCell";
    OrderBasketCell * cell = [tableview dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[OrderBasketCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lblTitle = [[UILabel alloc]init];
        [lblTitle setFont:NewsTitleFont];
        [lblTitle setTextColor:[UIColor colorWithRed:36.0f/255.0f green:51.0f/255.0f blue:108.0f/255.0f alpha:1.0f]];
        [lblTitle setNumberOfLines:0];
        [self addSubview:lblTitle];
        self.lblTitle = lblTitle;
        
        UILabel *lblText = [[UILabel alloc]init];
        [lblText setFont:NewsTextFont];
        [lblText setNumberOfLines:0];
        [self addSubview:lblText];
        self.lblText = lblText;
        
        UIButton *addButton = [[UIButton alloc]init];
        [addButton addTarget:self action:@selector(addProductCount:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setBackgroundImage:[IonIcons imageWithIcon:ion_plus_round size:addButton.frame.size.width color:[UIColor blackColor]] forState:UIControlStateNormal];
        [self addSubview:addButton];
        
        UIButton *minButton = [[UIButton alloc]init];
        [minButton setBackgroundImage:[IonIcons imageWithIcon:ion_minus_round size:minButton.frame.size.width color:[UIColor blackColor]] forState:UIControlStateNormal];
        [self addSubview:minButton];
        
        UILabel *countLbl = [[UILabel alloc]init];
        [self addSubview:countLbl];
        
        UIButton *editButton = [[UIButton alloc]init];
        [self addSubview:editButton];
        
    }
    return  self;
}

- (IBAction)addProductCount:(id)sender {


}


@end
