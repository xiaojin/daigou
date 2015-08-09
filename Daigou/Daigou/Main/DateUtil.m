//
//  DateUtil.m
//  Daigou
//
//  Created by jin on 7/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil


// 发布时间
- (NSString *)newsTime:(NSDate *)dateTime;
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = knewsTimeFormat;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];

    NSDate *date = dateTime;
    NSDate *now = [NSDate date];
    
    // 比较帖子发布时间和当前时间
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    
    NSString *format;
    if (interval <= 60) {
        format = @"刚刚";
    } else if(interval <= 60*60){
        format = [NSString stringWithFormat:@"发布于前%.f分钟", interval/60];
    } else if(interval <= 60*60*24){
        format = [NSString stringWithFormat:@"发布于前%.f小时", interval/3600];
    } else if (interval <= 60*60*24*7){
        format = [NSString stringWithFormat:@"发布于前%d天", (int)interval/(60*60*24)];
    } else if (interval > 60*60*24*7 & interval <= 60*60*24*30 ){
        format = [NSString stringWithFormat:@"发布于前%d周", (int)interval/(60*60*24*7)];
    }else if(interval > 60*60*24*30 ){
        format = [NSString stringWithFormat:@"发布于前%d月", (int)interval/(60*60*24*30)];
    }
    
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}
@end
