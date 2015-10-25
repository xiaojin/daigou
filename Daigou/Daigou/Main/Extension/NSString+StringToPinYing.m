//
//  NSString+StringToPinYing.m
//  Daigou
//
//  Created by jin on 25/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "NSString+StringToPinYing.h"

@implementation NSString (StringToPinYing)
- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    mutableString = [NSMutableString stringWithString:[mutableString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return mutableString;
}
@end
