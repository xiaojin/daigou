//
//  CommonDefines.h
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//


// execute a block only once using dispatch_once
#import <libextobjc/EXTScope.h>


#define once_only(BLOCK) ({ \
static dispatch_once_t oncetoken = 0; \
dispatch_once(&oncetoken, BLOCK); \
})
#define IOS8_OR_ABOVE [[[UIDevice currentDevice] systemVersion] integerValue] >= 8.0
#define DATABASE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"daigou.db"];
#define RGB(r,g,b) [UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0f alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0f alpha:a]
#define kWindowWidth                        ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#define Font(F) [UIFont systemFontOfSize:(F)]
#define CARTPRODUCTSCACHE @"CARTPRODUCTSCACHE"
#define THEMECOLOR [UIColor colorWithRed:241.0f/255.0 green:109.0f/255.0 blue:52.0f/255.0f alpha:1.0]
#define ORDERDETAILTAG 90000
#define SCROLL_VIEW_HEIGHT 44
#define ORIANGECOLOR RGB(255, 85, 3)
#define TITLECOLOR RGB(89, 89, 89)
#define GRAYCOLOR RGB(45,45,45)
#define LIGHTGRAYCOLOR RGB(200,200,200)
#define SYSTEMBLUE RGB(0,118,255)
#define PRODUCTTITLEFONT [UIFont systemFontOfSize:14.0f]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define PRODUCTFINFOTAGBEGIN 900000
#define PRODUCTDETAILIVIEW 800000
#define NEWPROCUREMENTTAG 700000
#define EXCHANGERATE 5.0
#define kJVFieldFontSize  14.0f
#define kJVFieldFloatingLabelFontSize  11.0f
#define kJVFieldMarginTop 10.0f
#define MONEYSYMFONT [UIFont systemFontOfSize:14.0f]
#define FONTCOLOR  [UIColor darkGrayColor]
#define LINECOLOR  [UIColor darkGrayColor]
#define kLINEHEIGHT 1.0f


//PURCHASED = 0,
//UNDISPATCH = 10,
//SHIPPED = 20,
//DELIVERD = 30,
//DONE = 40

#define PURCHASEDTITLE @"采购中"
#define UNDISPATCHTITLE @"待发货"
#define SHIPPEDTITLE @"已发货"
#define DELIVERDTITLE @"已收获"
#define DONETITLE @"已完成"

#define PHOTOURLS @"photourls"

#define IMAGEURL @"http://7xlkb6.com1.z0.glb.clouddn.com/image/"