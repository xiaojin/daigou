//
//  CommonDefines.h
//  Daigou
//
//  Created by jin on 25/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//


// execute a block only once using dispatch_once
#define once_only(BLOCK) ({ \
static dispatch_once_t oncetoken = 0; \
dispatch_once(&oncetoken, BLOCK); \
})

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
#define SYSTEMBLUE RGB(0,118,255)
#define PRODUCTTITLEFONT [UIFont systemFontOfSize:14.0f]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define PRODUCTFINFOTAGBEGIN 900000
