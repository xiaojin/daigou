//
//  DateUtil.h
//  Daigou
//
//  Created by jin on 7/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>
#define knewsTimeFormat @"yyyyMMddHHmmss" //你要传过来日期的格式
#define kLocaleIdentifier @"en_US"
@interface DateUtil : NSObject
- (NSString *)newsTime:(NSString *)newsTimes;
@end
