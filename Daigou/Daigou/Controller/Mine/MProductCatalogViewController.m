#import "MProductCatalogViewController.h"
#import "ProductManagement.h"
#import "Product.h"
#import "ProductItemCell.h"

@interface MProductCatalogViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *productTableView;
@property(nonatomic, strong) NSMutableArray *productFrameItems;
@end

@implementation MProductCatalogViewController

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchAllProduct];
    self.productTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.productTableView.dataSource = self;
    self.productTableView.delegate = self;
    [self.view addSubview:self.productTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProduct)];
    // Do any additional setup after loading the view.
}

- (NSArray *)fetchAllProduct {
    ProductManagement *productManagement = [ProductManagement shareInstance];
    self.productFrameItems = [NSMutableArray array];
    NSArray *products = [productManagement getProduct];
    //self.productFrameItems =
    for (Product *productItem in products) {
        ProductItemFrame *itemFrame = [[ProductItemFrame alloc]initFrameWithProduct:productItem withViewFrame:self.view.bounds];
        //itemFrame setPro
        [self.productFrameItems addObject:itemFrame];
        
    }
    return self.productFrameItems;
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

@end
