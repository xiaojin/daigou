//
//  OrderProductsRightCell.m
//  Daigou
//
//  Created by jin on 28/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderProductsRightCell.h"
#import "CommonDefines.h"
#import "Product.h"

@interface OrderProductsRightCell()
@property (weak ,nonatomic) UIImageView *prodImage;

@property (weak ,nonatomic) UILabel *imageShow;

@property (weak ,nonatomic) UILabel *prodName;

@property (weak ,nonatomic) UILabel *prodMoney;

@property (weak ,nonatomic) UILabel *prodQuantity;

@property (weak ,nonatomic) UIButton *minusLeft;

@property (weak ,nonatomic) UIButton *plusRight;

@property (weak ,nonatomic) UILabel *prodMoneyOriginalPrice;

@property (weak ,nonatomic) UIView *prodMoneyOriginalPriceShow;

@property (assign ,nonatomic)NSInteger quantity;

@property (nonatomic, strong)UIButton *addToCart;
@end

@implementation OrderProductsRightCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *prodImage =[[UIImageView alloc]init];
        [self.contentView addSubview:prodImage];
        _prodImage=prodImage;
        
        UILabel *imageShow =[[UILabel alloc]init];
        [prodImage addSubview:imageShow];
        _imageShow=imageShow;
        
        UILabel *prodName =[[UILabel alloc]init];
        [self.contentView addSubview:prodName];
        _prodName=prodName;
        
        UILabel *prodMoney =[[UILabel alloc]init];
        [self.contentView addSubview:prodMoney];
        _prodMoney =prodMoney;
        
        UILabel *prodMoneyOriginalPrice =[[UILabel alloc]init];
        [self.contentView addSubview:prodMoneyOriginalPrice];
        _prodMoneyOriginalPrice=prodMoneyOriginalPrice;
        
        UIView *prodMoneyOriginalPriceShow =[[UIView alloc]init];
        [self.contentView addSubview:prodMoneyOriginalPriceShow];
        _prodMoneyOriginalPriceShow=prodMoneyOriginalPriceShow;
        
        UIButton *addCartView = [[UIButton alloc]init];
        [self.contentView addSubview:addCartView];
        _addToCart = addCartView;
        
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

-(void)setProduct:(Product *)rightData
{
    
    _product=rightData;
    _prodImage.frame=(CGRect){10,10,75,75};
    NSString *prodImageString = ([_product.picture isEqualToString:@""] || _product.picture == nil)? @"default" : _product.picture;
    _prodImage.image=[UIImage imageNamed:prodImageString];
    _prodImage.layer.masksToBounds=YES;
    _prodImage.layer.cornerRadius=2;
    _imageShow.frame=(CGRect){0,70-10,75,10};
    
//    if (YES) {
//        _imageShow.hidden=NO;
//        _imageShow.text=@"7折";
//        _imageShow.textColor=[UIColor whiteColor];
//        _imageShow.font=Font(10);
//        _imageShow.textAlignment=NSTextAlignmentCenter;
//        _imageShow.backgroundColor=RGB(255, 127, 0);
//    }
//    }else
//    {
        _imageShow.hidden=YES;
//    }
    
    
    
    
    NSString *prodNameText =_product.name;
    CGRect prodNameRect =[prodNameText boundingRectWithSize:CGSizeMake(kWindowWidth-CGRectGetMaxX(_prodImage.frame)-10, 35) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName, nil] context:nil];
    
    _prodName.text=prodNameText;
    _prodName.font=Font(14);
    _prodName.numberOfLines=2;
    _prodName.textAlignment=NSTextAlignmentJustified;
    _prodName.frame =(CGRect){{CGRectGetMaxX(_prodImage.frame)+5,10},prodNameRect.size};
    
    NSString *prodMoneyText =[NSString stringWithFormat:@"$%.2f",_product.sellprice];
    CGSize prodMoneySize =[prodMoneyText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName, nil]];
    _prodMoney.text=prodMoneyText;
    _prodMoney.font=Font(14);
    _prodMoney.textColor=RGB(255, 127, 0);
    _prodMoney.frame =(CGRect){{CGRectGetMinX(_prodName.frame),CGRectGetMaxY(_prodImage.frame)-prodMoneySize.height-prodMoneySize.height},prodMoneySize};
    
    if(_product.agentprice!=0.0f)
    {
        _prodMoneyOriginalPrice.hidden=NO;
        NSString *prodMoneyOriginalPriceText =[NSString stringWithFormat:@"代理价:%.2f",_product.agentprice];
        CGSize prodMoneyOriginalPriceSize =[prodMoneyOriginalPriceText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
        _prodMoneyOriginalPrice.text=prodMoneyOriginalPriceText;
        _prodMoneyOriginalPrice.font=Font(11);
        _prodMoneyOriginalPrice.textColor=[UIColor lightGrayColor];
        _prodMoneyOriginalPrice.frame=(CGRect){{CGRectGetMinX(_prodName.frame),CGRectGetMaxY(_prodMoney.frame)+3},prodMoneyOriginalPriceSize};
    }else
    {
        _prodMoneyOriginalPrice.hidden=YES;
        
    }
    
    [_addToCart setFrame:CGRectMake(kWindowWidth-100, 60, 80, 26)];
    [_addToCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addToCart setBackgroundColor:RGB(255, 127, 0)];
    [_addToCart setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    _addToCart.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_addToCart addTarget:self action:@selector(addToCartAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addToCartAction
{
    _TapActionBlock(1,_product.saleprice ,_product);
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderProductsRightCell";
    OrderProductsRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderProductsRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
@end
