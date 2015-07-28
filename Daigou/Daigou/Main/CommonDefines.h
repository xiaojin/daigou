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
#define kWindowWidth                        ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#define Font(F) [UIFont systemFontOfSize:(F)]