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
