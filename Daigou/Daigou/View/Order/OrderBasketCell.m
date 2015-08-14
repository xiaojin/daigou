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
#import "UILabelStrikeThrough.h"

#define ORIANGECOLOR RGB(255, 85, 3)
#define TITLECOLOR RGB(115, 115, 115)
@interface OrderBasketCell() <UITextFieldDelegate>{
    BOOL editStatus;
}
@property(nonatomic, strong) UILabel *lblTitle;
@property(nonatomic, strong) UITextField *countField;
@property(nonatomic, strong) UIImageView *imagePic;
@property(nonatomic, strong) UIButton *editButton;
@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UIButton *minusButton;
@property(nonatomic, strong) UIView *showEditView;
@property(nonatomic, strong) UIView *showDetailView;

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
        [lblTitle setTextColor:TITLECOLOR];
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
        [editProduct.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [editProduct addTarget:self action:@selector(editProductInfo:) forControlEvents:UIControlEventTouchUpInside];
        [editProduct setTitleColor:TITLECOLOR forState:UIControlStateNormal];
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
        
        UIView *showDetailView = [[UIView alloc] init];
        showDetailView.hidden = NO;
        [contentView addSubview:showDetailView];
        [showDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagePic.mas_right).with.offset(5);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.bottom.equalTo(contentView);
        }];
        
        UILabel *salePrice = [[UILabel alloc]init];
        [salePrice setTextColor:ORIANGECOLOR];
        salePrice.font = [UIFont systemFontOfSize:13.0f];
        [salePrice setTextAlignment:NSTextAlignmentLeft];
        [salePrice setText:@"$29"];
        [showDetailView addSubview:salePrice];
        [salePrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showDetailView);
            make.bottom.equalTo(showDetailView);
            make.height.equalTo(@25);
            make.width.equalTo(@45);
        }];
        
        UILabelStrikeThrough *refPrice = [[UILabelStrikeThrough alloc]init];
        refPrice.isWIthStrikeThrough = YES;
        [refPrice setTextColor:[UIColor lightGrayColor]];
        [refPrice setFont:[UIFont systemFontOfSize:11.0f]];
        [refPrice setTextAlignment:NSTextAlignmentLeft];
        [refPrice setText:@"$39"];
        [showDetailView addSubview:refPrice];
        [refPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(salePrice.mas_right);
            make.bottom.equalTo(showDetailView);
            make.height.equalTo(@25);
            make.width.equalTo(@45);
        }];
        
        UILabel *prodCount = [[UILabel alloc]init];
        [prodCount setTextColor:TITLECOLOR];
        [prodCount setFont:[UIFont systemFontOfSize:13.0f]];
        [prodCount setTextAlignment:NSTextAlignmentLeft];
        [prodCount setText:@"x12"];
        [showDetailView addSubview:prodCount];
        [prodCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(showDetailView).with.offset(-10);
            make.bottom.equalTo(showDetailView);
            make.height.equalTo(@25);
            make.width.equalTo(@45);
        }];
        self.showDetailView = showDetailView;

        
        UIView *showEditView = [[UIView alloc] init];
        [showEditView setBackgroundColor:[UIColor clearColor]];
        showEditView.hidden = YES;
        [contentView addSubview:showEditView];
        [showEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imagePic.mas_right).with.offset(5);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.bottom.equalTo(contentView);
        }];

        
        UIButton *minusButton = [[UIButton alloc]init];
        [minusButton addTarget:self action:@selector(minusProductCount:) forControlEvents:UIControlEventTouchUpInside];
        [minusButton setImage:[IonIcons imageWithIcon:ion_minus_round size:18.0f color:RGB(115, 115, 115)] forState:UIControlStateNormal];
        [showEditView addSubview:minusButton];
        self.minusButton = minusButton;

        [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showEditView);
            make.top.equalTo(showEditView);
            make.width.equalTo(@45.0f);
            make.height.equalTo(self.minusButton.mas_width);
        }];
        
        UIView *minBtnlineView = [[UIView alloc] init];
        minBtnlineView.backgroundColor = [UIColor whiteColor];
        [self.minusButton addSubview:minBtnlineView];
        [minBtnlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.minusButton);
            make.top.equalTo(self.minusButton).with.offset(6);
            make.bottom.equalTo(self.minusButton).with.offset(-6);
            make.width.equalTo(@2);
        }];
        
        
        UITextField *countField = [[UITextField alloc]init];
        countField.delegate = self;
        [countField setFont:ProductTitleFont];
        [countField setTextColor:RGB(48, 48, 48)];
        [countField setTextAlignment:NSTextAlignmentCenter];
        [showEditView addSubview:countField];
        [countField setKeyboardType:UIKeyboardTypeNumberPad];
        self.countField = countField;
        [countField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.minusButton.mas_right);
            make.top.equalTo(showEditView);
            make.height.equalTo(self.minusButton.mas_height);
            make.width.equalTo(@65);
        }];
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)],
                               nil];
        [numberToolbar sizeToFit];
        countField.inputAccessoryView = numberToolbar;
        
//
        UIButton *addButton = [[UIButton alloc]init];
        [addButton addTarget:self action:@selector(addProductCount:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setImage:[IonIcons imageWithIcon:ion_plus_round size:18.0f color:RGB(115, 115, 115)] forState:UIControlStateNormal];
        [showEditView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countField.mas_right);
            make.top.equalTo(showEditView);
            make.width.equalTo(@45.0f);
            make.height.equalTo(addButton.mas_width);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [addButton addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addButton);
            make.top.equalTo(addButton).with.offset(6);
            make.bottom.equalTo(addButton).with.offset(-6);
            make.width.equalTo(@2);
        }];
        self.addButton = addButton;
 
//
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setBackgroundColor:ORIANGECOLOR];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [showEditView addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addButton.mas_right).with.offset(30);
            make.top.equalTo(showEditView);
            make.bottom.equalTo(showEditView);
            make.right.equalTo(showEditView);
        }];
        
        UIView *otherView = [[UIView alloc]init];
        [otherView setBackgroundColor:[UIColor whiteColor]];
        [showEditView addSubview:otherView];
        [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(showEditView);
            make.top.equalTo(self.minusButton.mas_bottom);
            make.trailing.equalTo(self.addButton.mas_trailing);
            make.height.equalTo(@2);
        }];
        self.showEditView = showEditView;
     
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
    [self.countField resignFirstResponder];
    NSString *countString = [self.countField text];
    NSInteger count = countString.integerValue;
    if (count > 98 || count == 99) {
        count = 99;
    } else {
        count = count + 1;
    }
    [self.countField setText:[NSString stringWithFormat:@"%ld",(long)count]];
}

- (IBAction)minusProductCount:(id)sender {
    [self.countField resignFirstResponder];
    NSString *countString = [self.countField text];
    NSInteger count = countString.integerValue;
    if (count < 1 || count == 1) {
        count = 0;
    } else {
        count = count - 1;
    }
    [self.countField setText:[NSString stringWithFormat:@"%ld",(long)count]];
}

- (IBAction)editProductInfo:(id)sender {
    [self.countField resignFirstResponder];
    if (!editStatus) {
        editStatus = YES;
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        self.showDetailView.hidden = YES;
        self.showEditView.hidden = NO;
    } else {
        editStatus = NO;
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.showDetailView.hidden = NO;
        self.showEditView.hidden = YES;

    }
}

#pragma mark - UITextFieldDelege

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _EditQuantiyActionBlock(12);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *countString = [textField text];
    NSInteger count = countString.integerValue;
    if (count > 98 ) {
        count = 99;
    } else if(count == 0) {
        count = 0;
    }
    [self.countField setText:[NSString stringWithFormat:@"%ld",(long)count]];
}

- (void) doneWithNumberPad {
    [self.countField resignFirstResponder];
}

@end
