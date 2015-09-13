//
//  DirectoryUtil.m
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "DirectoryUtil.h"

@implementation DirectoryUtil
static NSURL *_applicationDataDirectory;

+ (void)writeData:(id)data toFile:(NSString *)fileName {
    NSData *dataToWrite = [NSJSONSerialization dataWithJSONObject:data options:0 error:NULL];
    [dataToWrite writeToFile:[DirectoryUtil fileUrl:fileName].path atomically:YES];
}

+ (NSURL *)applicationDataDirectory {
    if (!_applicationDataDirectory || ![[NSFileManager defaultManager] fileExistsAtPath:_applicationDataDirectory.path]) {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSFileManager *fm = [NSFileManager defaultManager];
        // Find the application support directory in the home directory.
        NSArray *appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                            inDomains:NSUserDomainMask];
        if ([appSupportDir count] > 0) {
            // Append the bundle ID to the URL for the
            // Application Support directory
            NSURL *dirPath = [appSupportDir[0] URLByAppendingPathComponent:bundleID];
            
            if (![fm fileExistsAtPath:[dirPath path]]) {
                // If the directory does not exist, this method creates it.
                // This method call works in OS X 10.7 and later only.
                NSError *theError = nil;
                if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES attributes:nil error:&theError]) {
                    if (!(theError.code == 516 && [theError.domain isEqualToString:NSCocoaErrorDomain])) {
                        NSLog(@"Error creating Application Support Directory: %@, %@", dirPath, theError);
                        
                        return nil;
                    }
                }
            }
            _applicationDataDirectory = dirPath;
        }
    }
    return _applicationDataDirectory;
}

+ (NSURL *)fileUrl:(NSString *)fileName {
    return [[DirectoryUtil applicationDataDirectory] URLByAppendingPathComponent:fileName];
}


@end
