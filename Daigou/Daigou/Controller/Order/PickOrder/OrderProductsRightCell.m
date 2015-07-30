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

-(void)setRightData:(Product *)rightData
{
    
    _rightData=rightData;
    _prodImage.frame=(CGRect){5,15,65,65};
    NSString *prodImageString = _rightData.picture? _rightData.picture : @"default";
    _prodImage.image=[UIImage imageNamed:prodImageString];
    _prodImage.layer.masksToBounds=YES;
    _prodImage.layer.cornerRadius=6;
    _imageShow.frame=(CGRect){0,65-10,65,10};
    
    if (YES) {
        _imageShow.hidden=NO;
        _imageShow.text=@"7折";
        _imageShow.textColor=[UIColor whiteColor];
        _imageShow.font=Font(10);
        _imageShow.textAlignment=NSTextAlignmentCenter;
        _imageShow.backgroundColor=RGB(255, 127, 0);
    }
//    }else
//    {
//        _imageShow.hidden=YES;
//    }
    
    
    
    
    NSString *prodNameText =_rightData.name;
    CGRect prodNameRect =[prodNameText boundingRectWithSize:CGSizeMake(kWindowWidth-75-CGRectGetMaxX(_prodImage.frame)-10, 35) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName, nil] context:nil];
    
    _prodName.text=prodNameText;
    _prodName.font=Font(14);
    _prodName.numberOfLines=2;
    _prodName.textAlignment=NSTextAlignmentJustified;
    _prodName.frame =(CGRect){{CGRectGetMaxX(_prodImage.frame)+5,10},prodNameRect.size};
    
    NSString *prodMoneyText =[NSString stringWithFormat:@"$%.2f",_rightData.sellprice];
    CGSize prodMoneySize =[prodMoneyText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName, nil]];
    _prodMoney.text=prodMoneyText;
    _prodMoney.font=Font(14);
    _prodMoney.textColor=RGB(255, 127, 0);
    _prodMoney.frame =(CGRect){{CGRectGetMaxX(_prodImage.frame),CGRectGetMaxY(_prodImage.frame)-prodMoneySize.height-prodMoneySize.height*0.5},prodMoneySize};
    
    if(_rightData.agentprice!=0.0f)
    {
        _prodMoneyOriginalPrice.hidden=NO;
        NSString *prodMoneyOriginalPriceText =[NSString stringWithFormat:@"代理价:%.2f",_rightData.agentprice];
        CGSize prodMoneyOriginalPriceSize =[prodMoneyOriginalPriceText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
        _prodMoneyOriginalPrice.text=prodMoneyOriginalPriceText;
        _prodMoneyOriginalPrice.font=Font(11);
        _prodMoneyOriginalPrice.textColor=[UIColor lightGrayColor];
        _prodMoneyOriginalPrice.frame=(CGRect){{CGRectGetMaxX(_prodImage.frame),CGRectGetMaxY(_prodMoney.frame)+3},prodMoneyOriginalPriceSize};
    }else
    {
        _prodMoneyOriginalPrice.hidden=YES;
        
    }
    //吧台加号
    _plusRight.frame=(CGRect){kWindowWidth-75-10 -30,90-40,30,30};
    _plusRight.layer.masksToBounds=YES;
    _plusRight.layer.cornerRadius=30/2;
    [_plusRight setTitle:@"+" forState:UIControlStateNormal];
    [_plusRight setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_plusRight addTarget:self action:@selector(plusRightClick) forControlEvents:UIControlEventTouchUpInside];
    _plusRight.titleLabel.font=Font(13);
    _plusRight.layer.borderWidth = 1;
    _plusRight.layer.borderColor = [[UIColor redColor] CGColor];
    //吧台减号
    _minusLeft.frame=(CGRect){kWindowWidth-75 -10 -30 -30 - 30 ,90-40,30,30};
    _minusLeft.layer.masksToBounds=YES;
    _minusLeft.layer.cornerRadius=30/2;
    [_minusLeft setTitle:@"-" forState:UIControlStateNormal];
    [_minusLeft setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_minusLeft addTarget:self action:@selector(minusLeftClick) forControlEvents:UIControlEventTouchUpInside];
    _minusLeft.titleLabel.font=Font(13);
    _minusLeft.layer.borderWidth = 1;
    _minusLeft.layer.borderColor = [[UIColor redColor] CGColor];
    
    CGFloat W =(kWindowWidth-75-10 -30)-CGRectGetMaxX(_minusLeft.frame);
    _prodQuantity.frame=(CGRect){CGRectGetMaxX(_minusLeft.frame),90-40,W,30};
    _prodQuantity.text=@"0";
    _prodQuantity.textAlignment=NSTextAlignmentCenter;
    _prodQuantity.font=Font(16);
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
    _TapActionBlock(_quantity,_rightData.saleprice ,_rightData.pid);
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
    _TapActionBlock(_quantity,_rightData.saleprice ,_rightData.pid);
    if (NumberInt ==0) {
        return;
    }
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
