#import <UIKit/UIKit.h>
#import "ProductItemFrame.h"
@interface ProductItemCell : UITableViewCell
@property (nonatomic, strong) ProductItemFrame *status;
+ (instancetype) NewsWithCell:(UITableView *)tableview;
@end
