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
#import <Masonry/Masonry.h>
#import "CommonDefines.h"

@interface OrderBasketCell()
@property(nonatomic, retain)IBOutlet UILabel *lblTitle;
@property(nonatomic, retain)IBOutlet UITextField *countField;
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
        [self.contentView setBackgroundColor:RGB(238, 238, 238)];
        UIView *bgView = [[UIView alloc] init];
        [bgView setBackgroundColor:RGB(255, 255, 255)];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];
        
        
        
        UILabel *lblTitle = [[UILabel alloc]init];
        [lblTitle setFont:ProductTitleFont];
        [lblTitle setTextColor:RGB(115, 115, 115)];
        [lblTitle setNumberOfLines:0];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [bgView addSubview:lblTitle];
        self.lblTitle = lblTitle;
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.left.equalTo(bgView).with.offset(5);
            make.right.equalTo(bgView).with.offset(-45);
            make.bottom.equalTo(bgView);
        }];
        
        
        
        UIButton *editProduct = [[UIButton alloc]init];
        [editProduct setTitle:@"编辑" forState:UIControlStateNormal];
        [editProduct addTarget:self action:@selector(editProductInfo:) forControlEvents:UIControlEventTouchUpInside];
        [editProduct setTitleColor:RGB(115, 115, 115) forState:UIControlStateNormal];
        [bgView addSubview:editProduct];
        self.editButton = editProduct;
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.right.equalTo(bgView);
            make.left.equalTo(self.lblTitle.mas_right);
            make.bottom.equalTo(bgView);
        }];
        
        UIView *contentView = [[UIView alloc]init];
        [contentView setBackgroundColor:RGB(248, 248, 248)];
        [self.contentView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@92);
        }];
        
        UIImageView *imagePic = [[UIImageView alloc] init];
        [contentView addSubview:imagePic];
        self.imagePic = imagePic;
        [self.imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).with.offset(5);
            make.left.equalTo(contentView).with.offset(10);
            make.width.equalTo(@82);
            make.height.equalTo(@82);
        }];
        
//        UIView *showDetailView = [[UIView alloc] init];
//        showDetailView.hidden = YES;
//        [contentView addSubview:showDetailView];
//        [showDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.imagePic.mas_right).with.offset(5);
//            make.right.equalTo(contentView);
//            make.top.equalTo(contentView);
//            make.bottom.equalTo(contentView);
//        }];
        
        UIView *showEditView = [[UIView alloc] init];
        [showEditView setBackgroundColor:[UIColor clearColor]];
        showEditView.hidden = NO;
        [contentView addSubview:showEditView];
        [showEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagePic.mas_right).with.offset(5);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.bottom.equalTo(contentView);
        }];
        
        UIButton *addButton = [[UIButton alloc]init];
        [addButton addTarget:self action:@selector(addProductCount:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setImage:[IonIcons imageWithIcon:ion_plus_round size:20.0f color:[UIColor blackColor]] forState:UIControlStateNormal];
        [showEditView addSubview:addButton];
        self.addButton = addButton;

        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showEditView);
            make.top.equalTo(showEditView);
            make.width.equalTo(@35.0f);
            make.height.equalTo(self.addButton.mas_width);
        }];
        
        
        UITextField *countField = [[UITextField alloc]init];
        [countField setFont:ProductTitleFont];
        [countField setTextColor:RGB(115, 115, 115)];
        [showEditView addSubview:countField];
        [countField setKeyboardType:UIKeyboardTypeNumberPad];
        self.countField = countField;
        [countField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addButton.mas_right);
            make.top.equalTo(showEditView);
            make.height.equalTo(self.addButton.mas_height);
            make.width.equalTo(@45);
        }];
        
//
        UIButton *minButton = [[UIButton alloc]init];
        [minButton setBackgroundImage:[IonIcons imageWithIcon:ion_minus_round size:minButton.frame.size.width color:[UIColor blackColor]] forState:UIControlStateNormal];
        [showEditView addSubview:minButton];
        self.minusButton = minButton;
        [minButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countField.mas_right);
            make.top.equalTo(showEditView);
            make.width.equalTo(@35.0f);
            make.height.equalTo(self.minusButton.mas_width);
        }];
 
//

     
    }
    return  self;
}

- (void) showEditView {


}

- (void)setOrderBasketCellFrame:(OrderBasketCellFrame *)orderBasketCellFrame
{
    _orderBasketCellFrame = orderBasketCellFrame;
    [self updateFrame];
    [self updateData];
}

- (void)updateFrame
{
//    _lblTitle.frame = _orderBasketCellFrame.titleFrame;
//    _editButton.frame = _orderBasketCellFrame.editButtonFrame;
//    _addButton.frame = _orderBasketCellFrame.plusBtnFrame;
//    _minusButton.frame = _orderBasketCellFrame.minusLblFrame;
//    _countLbl.frame = _orderBasketCellFrame.countLblFrame;
//    _imagePic.frame = _orderBasketCellFrame.pictureFrame;
}

- (void)updateData
{
    OProductItem *productItem =  [_orderBasketCellFrame getOrderProductItem];
    Product *product = [_orderBasketCellFrame getProduct];
    _imagePic.image = [UIImage imageNamed:@"default.jpg"];
    [_lblTitle setText:[product name]];
    [_countField setText:[NSString stringWithFormat:@"%@", @([productItem amount])]];
    //TODO setProductImage
    
}



- (IBAction)addProductCount:(id)sender {


}

- (IBAction)editProductInfo:(id)sender {
    
    
}


@end
