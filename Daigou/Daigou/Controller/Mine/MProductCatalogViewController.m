#import "MProductCatalogViewController.h"
#import "ProductManagement.h"
#import "Product.h"
#import "ProductItemCell.h"

@interface MProductCatalogViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *productTableView;
@property(nonatomic, strong) NSArray *products;
@end

@implementation MProductCatalogViewController

- (void)loadView{
    self.productTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.productTableView.dataSource = self;
    self.productTableView.delegate = self;
    [self.view addSubview:self.productTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProduct)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)fetchAllProduct {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    self.products = [productManagement getProduct];
    return self.products;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Product

- (void)addNewProduct {

}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.products count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemCell * cell = [ProductItemCell NewsWithCell:tableView];
    ProductItemFrame *newItem = self.products[indexPath.row];
    cell.status = newItem;
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemFrame *itemFrame =self.products[indexPath.row];
    return itemFrame.cellHeight;
}

@end
