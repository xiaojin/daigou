#import "MProductCatalogViewController.h"
#import "ProductManagement.h"
#import "Product.h"
#import "ProductItemCell.h"
#import "Brand.h"
#import "BrandManagement.h"
#import "ProductCategory.h"
#import "ProductCategoryManagement.h"
#import "DropDownListView.h"
#import "ErrorHelper.h"
#import "MShowProductDetailViewController.h"
#import "MEditProductViewController.h"
@interface MProductCatalogViewController ()<UITableViewDataSource,UITableViewDelegate,DropDownChooseDataSource,DropDownChooseDelegate>
@property(nonatomic, strong) UITableView *productTableView;
@property(nonatomic, strong) NSMutableArray *productFrameItems;
@property(nonatomic, strong) NSArray *chooseArray;
@property(nonatomic, strong) NSArray *brands;
@property(nonatomic, strong) NSArray *categories;
@end

@implementation MProductCatalogViewController
const float categroyViewPaddingTop = 60.0f;
const float categoryViewHeight = 40.0f;
- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchAllProduct];
    self.productTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.productTableView.dataSource = self;
    self.productTableView.delegate = self;
    self.productTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.productTableView.bounds.size.width, 0.01f)];
    [self.view addSubview:self.productTableView];
    [self.productTableView setContentInset:UIEdgeInsetsMake(categoryViewHeight, 0, 0, 0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProduct)];
    [self showProductCategoryView];
    [self.productTableView reloadData];
}


- (void)showProductCategoryView {
    self.brands = [[NSArray alloc] initWithArray:[self fetchAllBrand]];
    NSMutableArray *brandNames = [NSMutableArray array];
    [brandNames addObject:@"所有"];
    for (Brand *brand in self.brands) {
        [brandNames addObject:brand.name];
    }
    self.categories = [[NSArray alloc] initWithArray:[self fetchAllCategory]];
    NSMutableArray *categoryNames = [NSMutableArray array];
    [categoryNames addObject:@"所有"];
    for (ProductCategory *category in self.categories) {
        [categoryNames addObject:category.name];
    }
    self.chooseArray = @[categoryNames, brandNames ];
    DropDownListView *dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, categroyViewPaddingTop, self.view.frame.size.width, categoryViewHeight) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
}

- (NSArray *)fetchAllBrand {
    BrandManagement *brandManagement = [BrandManagement shareInstance];
    return [brandManagement getBrand];
}

- (NSArray *)fetchAllCategory {
    ProductCategoryManagement *categoryManage = [ProductCategoryManagement shareInstance];
    return [categoryManage getCategory];
}

- (void)initProductFrameItemsWithProducts:(NSArray *)products {
    self.productFrameItems = [NSMutableArray array];
    for (Product *productItem in products) {
        ProductItemFrame *itemFrame = [[ProductItemFrame alloc]initFrameWithProduct:productItem withViewFrame:self.view.bounds];
        [self.productFrameItems addObject:itemFrame];
    }
}

- (void)fetchAllProduct {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    self.productFrameItems = [NSMutableArray array];
    NSArray *products = [productManagement getProduct];
    [self initProductFrameItemsWithProducts:products];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DropDownListDelegate
- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    NSArray *products = [NSArray array];
    if (index == 0) {
        products = [productManagement getProduct];
    } else {
        if (section == 0) {
            //category
            ProductCategory *category = self.categories[index-1];
            products = [productManagement getProductByCategory:category];
        } else {
            //brand
            Brand *brand = self.brands[index-1];
            products = [productManagement getProductByBrand:brand];
        }
    }
    [self initProductFrameItemsWithProducts:products];
    if ([products count] ==0) {
        [ErrorHelper showErrorAlertWithTitle:@"查询结果" message:@"查不到此类产品"];
    }
    [self.productTableView reloadData];

}

#pragma mark - DropDownlistDataSource

- (NSInteger)numberOfSections {
    return [self.chooseArray count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.chooseArray[section];
    return [items count];
}

- (NSString *)titleInSection:(NSInteger)section index:(NSInteger)index {
    return self.chooseArray[section][index];
}

- (NSInteger)defaultShowSection:(NSInteger)section {
    return 0;
}

#pragma mark - Product

- (void)addNewProduct {
    Product *product = [[Product alloc]init];
    MEditProductViewController *editProductViewController = [[MEditProductViewController alloc]initWithProduct:product];
    [self.navigationController pushViewController:editProductViewController animated:YES];
}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productFrameItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemCell * cell = [ProductItemCell NewsWithCell:tableView];
    ProductItemFrame *newItem = self.productFrameItems[indexPath.row];
    cell.productFrame = newItem;
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemFrame *itemFrame =self.productFrameItems[indexPath.row];
    return itemFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MShowProductDetailViewController *showDetailViewController = [[MShowProductDetailViewController alloc]initWithProduct:[(ProductItemFrame *)self.productFrameItems[indexPath.row] getProduct]];
    [self.navigationController pushViewController:showDetailViewController animated:YES];
}
@end
