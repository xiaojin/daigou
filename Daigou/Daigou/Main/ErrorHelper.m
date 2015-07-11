#import "ErrorHelper.h"

@implementation ErrorHelper

+ (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles: nil];
    alertView.tag = kGeneralErrorTag;

    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}

+ (void)showRetryAlertWithTitle:(NSString *)title message:(NSString *)message tag:(ErrorAlertViewTag)tag delegate:(id)delegate retryBtnText:(NSString *)retryBtnText {
    if(!retryBtnText) {
        retryBtnText = @"重试";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:retryBtnText, nil];

    alertView.tag = tag;

    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}


+ (BOOL)isCredentialsError:(id)error {
    return ((NSError *) error).domain != NSURLErrorDomain;
}

@end
