//
//  OrderShareViewController.m
//  Daigou
//
//  Created by jin on 10/11/2015.
//  Copyright © 2015 dg. All rights reserved.
//

#import "OrderShareViewController.h"
#import "CommonDefines.h"
#import <Masonry/Masonry.h>
#import "BrandManagement.h"
#import "Brand.h"
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "OProductItem.h"
#import "OrderItemManagement.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Product.h"
#import "OProductItem.h"
#import "ProductManagement.h"
#import "UITextField+UITextFieldAccessory.h"
#import "JVFloatLabeledTextField.h"
#import "UIEditFieldView.h"
#import <ShareSDK/ShareSDK.h>

#define DiscountFONT  [UIFont systemFontOfSize:14.0f]
#define FLOADTINGFONTSIZE 14.0f
#define PADDING 5
#define kTabICONSIZE 26.0f
#define kICONCOLOR [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:144.0f/255.0f alpha:1.0f]
#define THIRDWITH (kWindowWidth-4*5)/3


@interface OrderShareViewController()<UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *subTotalField;
@property(nonatomic, strong)JVFloatLabeledTextField *deliveryFeeField;
@property(nonatomic, strong)JVFloatLabeledTextField *discountField;
@property(nonatomic, strong)JVFloatLabeledTextField *totalField;
@property(nonatomic, strong)JVFloatLabeledTextField *payStatysField;
@property(nonatomic, strong)JVFloatLabeledTextField *noteField;
@property(nonatomic, strong)JVFloatLabeledTextField *addresseField;
@property(nonatomic, strong)JVFloatLabeledTextField *receiverField;
@property(nonatomic, strong)JVFloatLabeledTextField *receiverIdField;
@property(nonatomic, strong)JVFloatLabeledTextField *contactPhoneField;
@property(nonatomic, strong)JVFloatLabeledTextField *postCodeField;
@end

@implementation OrderShareViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initContentView];
}

- (void)initContentView {
    _contentView = [[UIView alloc] init];
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-70);
    }];
    
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    NSString *customName = [self getCustomInfo:_orderItem.clientid];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = MONEYSYMFONT;
    titleLbl.textColor = TITLECOLOR;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    [titleLbl setText:customName];
    [_contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).with.offset(10);
        make.right.equalTo(_contentView).with.offset(-5);
        make.left.equalTo(_contentView).with.offset(5);
        make.height.equalTo(@22);
    }];
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).with.offset(5);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    NSInteger height = 0;
    NSArray *allkeys = [_prodList allKeys];
    NSInteger contentHeight = 0;
    UILabel *brandTitle = nil;
    for (int i = 0; i< [allkeys count]; i++) {
        height += contentHeight;
        NSArray *productList = [_prodList objectForKey:allkeys[i]];
        OProductItem *prodItem = [productList objectAtIndex:0];
        Product *product = [self getProductWithProductId:prodItem.productid];
        NSString *URLString =  [IMAGEURL stringByAppendingString:[NSString stringWithFormat:@"%@.png", product.uid]];
        UIImageView *prodImage = [[UIImageView alloc] init];
        [prodImage sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"default"]];
        [_contentView addSubview:prodImage];
        [prodImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(div1.mas_bottom).with.offset(15*(i+1)+height);
            make.left.equalTo(self.view).with.offset(10);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        
        NSString *prodName = [NSString stringWithFormat:@"%@", product.name];
        NSString *sellPrice = [NSString stringWithFormat:@"出售价格¥: %.2f 数量: %ld\n",product.sellprice, [productList count]];
        NSString *brandName = [self getBrandById:product.brandid];
        NSString *brandString = [NSString stringWithFormat:@"%@ \n", brandName];
        NSString *storage = [NSString stringWithFormat:@"用法说明: %@ \n", product.usage?product.usage : @""];
        
        NSString *contentString = [NSString stringWithFormat:@"%@%@%@%@",prodName,sellPrice, brandString, storage];
        
        brandTitle = [[UILabel alloc] init];
        brandTitle.font = MONEYSYMFONT;
        brandTitle.textColor = TITLECOLOR;
        brandTitle.textAlignment = NSTextAlignmentLeft;
        brandTitle.lineBreakMode = NSLineBreakByWordWrapping;
        brandTitle.numberOfLines = 0;
        [brandTitle setText:contentString];
        CGSize brandTitleSize = [self initSizeWithText:contentString withSize:CGSizeMake(self.view.frame.size.width-120, MAXFLOAT) withFont:MONEYSYMFONT];
        [_contentView addSubview:brandTitle];
        [brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(prodImage.mas_top);
            make.right.equalTo(self.view).with.offset(-15);
            make.left.equalTo(prodImage.mas_right).with.offset(10);
            make.height.equalTo(@(brandTitleSize.height+20));
        }];
        contentHeight = brandTitleSize.height > 100? brandTitleSize.height : 100;
    }
    
    UILabel *orderLbl = [[UILabel alloc] init];
    orderLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    orderLbl.textColor = TITLECOLOR;
    orderLbl.textAlignment = NSTextAlignmentLeft;
    [orderLbl setText:@"订单价格"];
    [_contentView addSubview:orderLbl];
    
    [orderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentHeight == 0 ? div1.mas_bottom : brandTitle.mas_bottom).with.offset(10);
        make.right.equalTo(_contentView).with.offset(-5);
        make.left.equalTo(_contentView).with.offset(5);
        make.height.equalTo(@22);
    }];
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderLbl.mas_bottom).with.offset(5);
        make.left.right.equalTo(_contentView);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    UIEditFieldView *subTotalTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake(THIRDWITH, 45) withController:self withPlaceHolder: @"小计"];
    subTotalTextView.dollarCharacter = @"¥";
    [subTotalTextView.textField setText:[NSString stringWithFormat:@"%.2f",_orderItem.subtotal]];
    _subTotalField = subTotalTextView.textField;
    [_contentView addSubview:subTotalTextView];
    [subTotalTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(div2.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(THIRDWITH));
        make.height.equalTo(@45);
    }];
    
    
    UIEditFieldView *deliverTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake(THIRDWITH, 45) withController:self withPlaceHolder: @"运费"];
    deliverTextView.dollarCharacter = @"¥";
    _deliveryFeeField = deliverTextView.textField;
    _deliveryFeeField.text = [NSString stringWithFormat:@"%.2f",_orderItem.delivery];
    [_contentView addSubview:deliverTextView];
    [deliverTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTotalTextView.mas_top);
        make.left.equalTo(subTotalTextView.mas_right).with.offset(PADDING);
        make.width.equalTo(@(THIRDWITH));
        make.bottom.equalTo(subTotalTextView.mas_bottom);
    }];
    
    UIEditFieldView *discountTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake(THIRDWITH, 45) withController:self withPlaceHolder: @"优惠"];
    discountTextView.dollarCharacter = @"¥";
    _discountField = discountTextView.textField;
    _discountField.text = [NSString stringWithFormat:@"%.2f",_orderItem.discount];
    [_contentView addSubview:discountTextView];
    [discountTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deliverTextView.mas_top);
        make.left.equalTo(deliverTextView.mas_right).with.offset(PADDING);
        make.width.equalTo(@(THIRDWITH));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *totalTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"总价"];
    totalTextView.dollarCharacter = @"¥";
    _totalField = totalTextView.textField;
    _totalField.text = [NSString stringWithFormat:@"%.2f",_orderItem.totoal];
    [_contentView addSubview:totalTextView];
    [totalTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(discountTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *payStatusTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"付款信息"];
    _payStatysField = payStatusTextView.textField;
    _payStatysField.text = [self updatePaymentStatus];
    [_contentView addSubview:payStatusTextView];
    [payStatusTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *noteTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"备注"];
    _noteField = noteTextView.textField;
    _noteField.text = [NSString stringWithFormat:@"%@",_orderItem.note];
    [_contentView addSubview:noteTextView];
    [noteTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payStatusTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UILabel *deliveryLbl = [[UILabel alloc] init];
    deliveryLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    deliveryLbl.textColor = TITLECOLOR;
    deliveryLbl.textAlignment = NSTextAlignmentLeft;
    [deliveryLbl setText:@"快递信息"];
    [_contentView addSubview:deliveryLbl];
    [deliveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextView.mas_bottom).with.offset(30);
        make.right.equalTo(_contentView).with.offset(-5);
        make.left.equalTo(_contentView).with.offset(5);
        make.height.equalTo(@22);
    }];
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deliveryLbl.mas_bottom).with.offset(5);
        make.left.right.equalTo(_contentView);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    UIEditFieldView *addressTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"地址"];
    _addresseField = addressTextView.textField;
    _addresseField.text = [NSString stringWithFormat:@"%@",_orderItem.address];
    [_contentView addSubview:addressTextView];
    [addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(div3.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *receiverTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"收件人"];
    _receiverField = receiverTextView.textField;
    _receiverField.text = [NSString stringWithFormat:@"%@",_orderItem.reviever];
    [_contentView addSubview:receiverTextView];
    [receiverTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *receiverIdTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"身份证号"];
    _receiverIdField = receiverIdTextView.textField;
    _receiverIdField.text = [NSString stringWithFormat:@"%@",_orderItem.idnum];
    [_contentView addSubview:receiverIdTextView];
    [receiverIdTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiverTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *contactPhoneTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"联系电话"];
    _contactPhoneField = contactPhoneTextView.textField;
    _receiverIdField.text = [NSString stringWithFormat:@"%@",_orderItem.phonenumber];
    [_contentView addSubview:contactPhoneTextView];
    [contactPhoneTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiverIdTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    UIEditFieldView *postCodeTextView = [[UIEditFieldView alloc] initWithSize:CGSizeMake((kWindowWidth-2*PADDING), 45) withController:self withPlaceHolder: @"邮政编码"];
    _postCodeField = postCodeTextView.textField;
    _receiverIdField.text = [NSString stringWithFormat:@"%@",_orderItem.postcode];
    [_contentView addSubview:postCodeTextView];
    [postCodeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactPhoneTextView.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(_contentView).with.offset(PADDING);
        make.width.equalTo(@(kWindowWidth-2*PADDING));
        make.height.equalTo(@45);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(postCodeTextView.mas_bottom).with.offset(20);
    }];
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_shareButton setTitle:@"分享订单" forState:UIControlStateNormal];
    [_shareButton setBackgroundColor:LIGHTGRAYCOLOR];
    [_shareButton.layer setCornerRadius:0.8];
    [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_shareButton addTarget:self action:@selector(shareOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(5);
        make.right.equalTo(self.view).with.offset(-5);
        make.bottom.equalTo(self.view).with.offset(-15);
    }];
    

}
- (void) shareOrder {

    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_scrollView.contentSize);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"产品详情"
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"代购管家"
                                                  url:@"http://www.idgb.co/"
                                          description:_orderItem.reviever
                                            mediaType:SSPublishContentMediaTypeImage];
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

- (NSString *)updatePaymentStatus {
    if (_orderItem.payDate != 0) {
        return @"已付款";
    }
    return @"未付款";
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (NSString *)getBrandById:(NSInteger)brandId {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    Brand *brand = [brandManagement getBrandById:brandId];
    return brand.name;
}

- (NSString *)getCustomInfo:(NSInteger)clientId {
    CustomInfoManagement *customManagement = [CustomInfoManagement shareInstance];
    CustomInfo *customInfo = [customManagement getCustomInfoById:clientId];
    return customInfo.name;
}

//- (void)getProductWithOrderId:(NSInteger)oid{
//    OrderItemManagement *itemManagement = [OrderItemManagement shareInstance];
//    NSArray *productItems = [itemManagement getOrderProductsByOrderId:oid];
//}

- (Product *)getProductWithProductId:(NSInteger)pid {
    ProductManagement *prodManagement = [ProductManagement shareInstance];
    return [prodManagement getProductById:pid];
}

@end
