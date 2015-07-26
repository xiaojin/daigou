//
//  OrderBasketCell.m
//  Daigou
//
//  Created by jin on 18/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//
#import "OrderBasketCell.h"
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "OrderBasketCellFrame.h"
#import "Product.h"
@interface OrderBasketCell()
@property(nonatomic, retain)IBOutlet UILabel *lblTitle;
@property(nonatomic, retain)IBOutlet UILabel *countLbl;
@property(nonatomic, retain)IBOutlet UIImageView *imagePic;
@property(nonatomic, retain)IBOutlet UIButton *editButton;
@property(nonatomic, retain)IBOutlet UIButton *addButton;
@property(nonatomic, retain)IBOutlet UIButton *minusButton;

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
        [lblTitle setFont:ProductTitleFont];
        [lblTitle setTextColor:[UIColor colorWithRed:36.0f/255.0f green:51.0f/255.0f blue:108.0f/255.0f alpha:1.0f]];
        [lblTitle setNumberOfLines:0];
        [self addSubview:lblTitle];
        self.lblTitle = lblTitle;
        
        UIButton *editProduct = [[UIButton alloc]init];
        [editProduct setTitle:@"编辑" forState:UIControlStateNormal];
        [editProduct addTarget:self action:@selector(editProductInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editProduct];
        self.editButton = editProduct;
        
        
        UIButton *addButton = [[UIButton alloc]init];
        [addButton addTarget:self action:@selector(addProductCount:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setBackgroundImage:[IonIcons imageWithIcon:ion_plus_round size:addButton.frame.size.width color:[UIColor blackColor]] forState:UIControlStateNormal];
        [self addSubview:addButton];
        self.addButton = addButton;
        
        UIButton *minButton = [[UIButton alloc]init];
        [minButton setBackgroundImage:[IonIcons imageWithIcon:ion_minus_round size:minButton.frame.size.width color:[UIColor blackColor]] forState:UIControlStateNormal];
        [self addSubview:minButton];
        self.minusButton = minButton;
        
        UILabel *countLbl = [[UILabel alloc]init];
        [countLbl setFont:ProductTitleFont];
        [countLbl setTextColor:[UIColor colorWithRed:36.0f/255.0f green:51.0f/255.0f blue:108.0f/255.0f alpha:1.0f]];
        [countLbl setNumberOfLines:0];
        [self addSubview:countLbl];
        self.countLbl = countLbl;
        

        UIImageView *imagePic = [[UIImageView alloc] init];
        [self addSubview:imagePic];
        self.imagePic = imagePic;
    }
    return  self;
}

- (void)setOrderBasketCellFrame:(OrderBasketCellFrame *)orderBasketCellFrame
{
    _orderBasketCellFrame = orderBasketCellFrame;
    [self updateFrame];
    [self updateData];
}

- (void)updateFrame
{
    _lblTitle.frame = _orderBasketCellFrame.titleFrame;
    _editButton.frame = _orderBasketCellFrame.editButtonFrame;
    _addButton.frame = _orderBasketCellFrame.plusBtnFrame;
    _minusButton.frame = _orderBasketCellFrame.minusLblFrame;
    _countLbl.frame = _orderBasketCellFrame.countLblFrame;
    _imagePic.frame = _orderBasketCellFrame.pictureFrame;
}

- (void)updateData
{
    OProductItem *productItem =  [_orderBasketCellFrame getOrderProductItem];
    Product *product = [_orderBasketCellFrame getProduct];
    _imagePic.image = [UIImage imageNamed:@"default.jpg"];
    [_lblTitle setText:[product name]];
    [_countLbl setText:[NSString stringWithFormat:@"%@", @([productItem amount])]];
    //TODO setProductImage
    
}



- (IBAction)addProductCount:(id)sender {


}

- (IBAction)editProductInfo:(id)sender {
    
    
}


@end
