#import <UIKit/UIKit.h>
#import "ProductItemFrame.h"
@interface ProductItemCell : UITableViewCell
@property (nonatomic, strong) ProductItemFrame *productFrame;
+ (instancetype) NewsWithCell:(UITableView *)tableview;
@end
