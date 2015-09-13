//
//  DirectoryUtil.h
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryUtil : NSObject
+ (NSURL *)fileUrl:(NSString *)fileName;
+ (void)writeData:(id)data toFile:(NSString *)fileName;
@end
