#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    kGeneralErrorTag,
    kSitesDownloadErrorTag
} ErrorAlertViewTag;

@interface ErrorHelper : NSObject

+ (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showRetryAlertWithTitle:(NSString *)title message:(NSString *)message tag:(ErrorAlertViewTag)tag delegate:(id)delegate retryBtnText:(NSString *)retryBtnText;
+ (BOOL)isCredentialsError:(id)error;

@end
