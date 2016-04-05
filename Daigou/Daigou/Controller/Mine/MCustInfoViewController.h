#import <UIKit/UIKit.h>

@class CustomInfo;
@protocol MCustInfoViewControllerDelegate<NSObject>
- (void)didSelectCustomInfo:(CustomInfo *)customInfo;
@end

@interface MCustInfoViewController : UITableViewController
@property (nonatomic,weak)id<MCustInfoViewControllerDelegate> customDelegate;
@end
