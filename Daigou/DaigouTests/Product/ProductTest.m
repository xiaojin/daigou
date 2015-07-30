//
//  ProductTest.m
//  Daigou
//
//  Created by jin on 10/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>
#import "Product.h"
#import "ProductManagement.h"
#import "Brand.h"
#import "ProductCategory.h"
@interface ProductTest : XCTestCase
@property(nonatomic, strong)ProductManagement *productManage;
@property(nonatomic, strong)Product *product;
@end

@implementation ProductTest

- (void)setUp {
    [super setUp];
    self.productManage = [ProductManagement shareInstance];
    self.product = [[Product alloc]init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testQueryProduct {
    NSArray *prodcuts = [self.productManage getProduct];
    XCTAssertGreaterThan([prodcuts count], 0,@"There should be more than 1 product in the database");
}

- (void)testUpdateProduct {
    self.product = [[Product alloc]init];
    [self.product setPid:21];
    [self.product setName:@"香蕉船防晒+运动系列SPF50+按压"];
    [self.product setProdDescription:@"这是一个很好的产品"];
    [self.product setCategoryid:9];
    [self.product setBrandid:10];
    BOOL result = [self.productManage updateProduct:self.product];
    XCTAssertTrue(result,@"should update the productInfo successfully");
    
}

- (void)testInsertProduct {
    self.product = [[Product alloc]init];
    [self.product setName:@"香蕉船防晒+运动系列SPF250+按压"];
    [self.product setProdDescription:@"这是一个很好的产品"];
    [self.product setCategoryid:9];
    [self.product setBrandid:10];
    [self.product setQuickid:@"123"];
    [self.product setEname:@"123123"];
    BOOL result = [self.productManage updateProduct:self.product];
    XCTAssertTrue(result,@"should insert the product successfully");
}

- (void)testgetProductByBrand {
    Brand *brand = [Brand new];
    brand.bid = 10;
    NSArray *products = [self.productManage getProductByBrand:brand];
    XCTAssertNotNil(products , @"There should be more than 1 product in the database");
}

- (void)testgetProductByCategory {
    ProductCategory *productCategory = [ProductCategory new];
    productCategory.cateid = 9;
    NSArray *products = [self.productManage getProductByCategory:productCategory];
    XCTAssertNotNil(products , @"There should be more than 1 product in the database");
}

@end
