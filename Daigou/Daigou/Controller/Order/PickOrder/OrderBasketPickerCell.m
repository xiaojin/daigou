//
//  OrderBasketPickerCell.m
//  Daigou
//
//  Created by jin on 1/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderBasketPickerCell.h"
#import "CommonDefines.h"
#import "ProductWithCount.h"
#import <Masonry/Masonry.h>

@interface OrderBasketPickerCell()
@property (weak ,nonatomic) UIImageView *prodImage;

@property (weak ,nonatomic) UILabel *prodName;

@property (weak ,nonatomic) UILabel *prodMoney;

@property (weak ,nonatomic) UILabel *prodQuantity;

@property (weak ,nonatomic) UIButton *minusLeft;

@property (weak ,nonatomic) UIButton *plusRight;

@property (assign ,nonatomic)NSInteger quantity;

@property (assign ,nonatomic) NSInteger cellIndex;
@end

@implementation OrderBasketPickerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *prodImage =[[UIImageView alloc]init];
        [self.contentView addSubview:prodImage];
        _prodImage=prodImage;
        
        UILabel *prodName =[[UILabel alloc]init];
        [self.contentView addSubview:prodName];
        _prodName=prodName;
        
        UILabel *prodMoney =[[UILabel alloc]init];
        [self.contentView addSubview:prodMoney];
        _prodMoney =prodMoney;
        
        UILabel *prodQuantity = [[UILabel alloc]init];
        [self.contentView addSubview:prodQuantity];
        _prodQuantity=prodQuantity;
        
        UIButton *minusLeft=[[UIButton alloc]init];
        [self.contentView addSubview:minusLeft];
        _minusLeft=minusLeft;
        
        UIButton *plusRight=[[UIButton alloc]init];
        [self.contentView addSubview:plusRight];
        _plusRight=plusRight;
        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,89.5,kWindowWidth,0.5}];
        viewShow.backgroundColor=[UIColor blackColor];
        viewShow.alpha=0.3;
        [self.contentView addSubview:viewShow];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void) setProductCount:(ProductWithCount *)productCount {
    _productCount=productCount;
//    NSString *prodImageString = _productCount.product.picture? _productCount.product.picture : @"default";
    NSString *prodImageString = @"default";
    _prodImage.image=[UIImage imageNamed:prodImageString];
    _prodImage.layer.masksToBounds=YES;
    [_prodImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.width.equalTo(_prodImage.mas_height);
    }];
    
    NSString *prodNameText =_productCount.product.name;
    _prodName.text=prodNameText;
    _prodName.font=Font(14);
    _prodName.numberOfLines=2;
    _prodName.textAlignment=NSTextAlignmentLeft;
    [_prodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_prodImage.mas_top);
        make.left.equalTo(_prodImage.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@35);
    }];
    
    NSString *prodMoneyText =[NSString stringWithFormat:@"$%.2f",_productCount.product.purchaseprice];
    _prodMoney.text=prodMoneyText;
    _prodMoney.font=Font(14);
    _prodMoney.textColor=RGB(255, 127, 0);
    [_prodMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_prodName.mas_bottom).with.offset(10);
        make.left.equalTo(_prodName.mas_left);
        make.height.equalTo(@35);
        make.right.equalTo(self.mas_centerX);
    }];


  

    //吧台减号
    _minusLeft.layer.masksToBounds=YES;
    _minusLeft.layer.cornerRadius=30/2;
    [_minusLeft setTitle:@"-" forState:UIControlStateNormal];
    [_minusLeft setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_minusLeft addTarget:self action:@selector(minusLeftClick) forControlEvents:UIControlEventTouchUpInside];
    _minusLeft.titleLabel.font=Font(13);
    _minusLeft.layer.borderWidth = 1;
    _minusLeft.layer.borderColor = [[UIColor redColor] CGColor];
    [_minusLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.top.equalTo(_prodMoney.mas_top);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    //label
    _prodQuantity.text= [NSString stringWithFormat:@"%ld" , _productCount.productNum];
    _prodQuantity.textAlignment=NSTextAlignmentCenter;
    _prodQuantity.font=Font(16);
    [_prodQuantity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minusLeft.mas_right).with.offset(10);
        make.top.equalTo(_prodMoney.mas_top);
        make.width.equalTo(@20);
        make.height.equalTo(@30);
    }];
    //吧台加号
    _plusRight.layer.masksToBounds=YES;
    _plusRight.layer.cornerRadius=30/2;
    [_plusRight setTitle:@"+" forState:UIControlStateNormal];
    [_plusRight setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_plusRight addTarget:self action:@selector(plusRightClick) forControlEvents:UIControlEventTouchUpInside];
    _plusRight.titleLabel.font=Font(13);
    _plusRight.layer.borderWidth = 1;
    _plusRight.layer.borderColor = [[UIColor redColor] CGColor];
    [_plusRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_prodQuantity.mas_right).with.offset(10);
        make.top.equalTo(_prodMoney.mas_top);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
}

-(void)plusRightClick
{
    int NumberInt =[_prodQuantity.text intValue];
    if (NumberInt ==99) {
        return;
    }
    ++NumberInt;
    
    _prodQuantity.text =[NSString stringWithFormat:@"%d",NumberInt];
    _quantity = [_prodQuantity.text integerValue];
    _productCount.productNum = _quantity;
   _TapActionBlock(_cellIndex ,_productCount);
}

-(void)minusLeftClick
{
    int NumberInt =[_prodQuantity.text intValue];
    if (NumberInt ==0) {
        return;
    }
    --NumberInt;
    _prodQuantity.text =[NSString stringWithFormat:@"%d",NumberInt];
    _quantity = [_prodQuantity.text integerValue];
    _productCount.productNum = _quantity;
    _TapActionBlock(_cellIndex ,_productCount);
    if (NumberInt ==0) {
        return;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withCellIndex:(NSInteger)index
{
    static NSString *ID = @"OrderBasketPickerCell";
    OrderBasketPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderBasketPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.cellIndex = index;
    }
    return cell;
}

@end
