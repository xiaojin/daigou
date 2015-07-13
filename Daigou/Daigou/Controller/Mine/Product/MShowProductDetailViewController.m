#import "MShowProductDetailViewController.h"
#import "BrandManagement.h"
#import "ProductCategoryManagement.h"
#import "Brand.h"
#import "ProductCategory.h"
#import "MShowDetailCell.h"
#import "MEditProductViewController.h"
@interface MShowProductDetailViewController()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *titleArray;
    NSMutableArray *valueArray;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *brands;
@property(nonatomic, strong)NSArray *categories;
@end
@implementation MShowProductDetailViewController
NSString *const mShowProductTableviewCell = @"MShowProductDetailCell ";

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        self.product = product;
    }
    return self;
}

- (void)addTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled  = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 0.01f)];
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editProductInfo)];
    self.navigationItem.rightBarButtonItem =editButton;
    self.title = @"详细信息";
}

- (void)editProductInfo {
    MEditProductViewController *editProductInfoViewController = [[MEditProductViewController alloc]initWithProduct:self.product];
    editProductInfoViewController.cellPlaceHolderValues = titleArray;
    editProductInfoViewController.cellContentValues = valueArray;
    [self.navigationController pushViewController:editProductInfoViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self fetchAllBrand];
    [self fetchAllCategory];
    titleArray = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    [self initValueForCell];
    [self.tableView reloadData];
}

- (NSString *)getBrandNameById:(NSInteger)bid {
    __block NSString *result =@"";
    [self.brands enumerateObjectsUsingBlock:^(Brand *obj, NSUInteger idx, BOOL *stop) {
        Brand *brand = obj;
        if ((idx+1) == bid) {
            result = brand.name;
        }
    }];
    return result;
}

- (NSString *)getCategoryNameById:(NSInteger)cateid {
    __block NSString *result =@"";
    [self.categories enumerateObjectsUsingBlock:^(ProductCategory *obj, NSUInteger idx, BOOL *stop) {
        ProductCategory *category = obj;
        if ((idx+1) == cateid) {
            result = category.name;
        }
    }];
    return result;
}

- (void)fetchAllBrand {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    self.brands = [brandManagement getBrand];
}


- (void)fetchAllCategory {
    ProductCategoryManagement *categoryManage = [ProductCategoryManagement shareInstance];
    self.categories = [categoryManage getCategory];
}

- (void) initValueForCell{
    [titleArray addObject:@"名字"];
    [valueArray addObject:self.product.name];
    [titleArray addObject:@"商品品牌"];
    NSString *brandName = [self getBrandNameById:self.product.brandid];
    [valueArray addObject:brandName];
    [titleArray addObject:@"产品分类"];
    NSString *categoryName = [self getCategoryNameById:self.product.categoryid];
    [valueArray addObject:categoryName];
    [titleArray addObject:@"型号"];
    [valueArray addObject:self.product.model];
    [titleArray addObject:@"条码"];
    [valueArray addObject:self.product.barcode];
    [titleArray addObject:@"重量"];
    [valueArray addObject:@(self.product.wight)];
    [titleArray addObject:@"检索码"];
    [valueArray addObject:self.product.quickid];
    [titleArray addObject:@"采购价格"];
    [valueArray addObject:@(self.product.costprice)];
    [titleArray addObject:@"出售价格"];
    [valueArray addObject:@(self.product.sellprice)];
    [titleArray addObject:@"功效"];
    [valueArray addObject:self.product.function];
    [titleArray addObject:@"卖点说明"];
    [valueArray addObject:self.product.sellpoint];
    [titleArray addObject:@"备注"];
    [valueArray addObject:self.product.note];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MShowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:mShowProductTableviewCell];
    if (cell==nil) {
        cell = [[MShowDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mShowProductTableviewCell];
    }
    NSString *cellValue = [[NSString alloc]initWithFormat:@"%@",valueArray[indexPath.row]];
    [cell updateCellWithTitle:titleArray[indexPath.row] detailInformation:cellValue];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}
@end
