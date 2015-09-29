//
//  OrderItemTest.m
//  Daigou
//
//  Created by jin on 19/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OrderItem.h"
#import "OrderItemManagement.h"
@interface OrderItemTest : XCTestCase
@property(nonatomic ,strong) OrderItem *orderItem;
@property(nonatomic, strong) OrderItemManagement *orderItemManagement;
@end

@implementation OrderItemTest

- (void)setUp {
    [super setUp];
    self.orderItem = [[OrderItem alloc]init];
    self.orderItemManagement = [OrderItemManagement shareInstance];
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

- (void)testQueryOrderItem {
    NSArray *orderItems = [self.orderItemManagement getOrderItems];
    XCTAssertGreaterThan([orderItems count], 0,@"There should be more than 1 product in the database");
}
//
//- (void)testUpdateOrderItem {
//    self.product = [[Product alloc]init];
//    [self.product setPid:21];
//    [self.product setName:@"香蕉船防晒+运动系列SPF50+按压"];
//    [self.product setProdDescription:@"这是一个很好的产品"];
//    [self.product setCategoryid:9];
//    [self.product setBrandid:10];
//    BOOL result = [self.productManage updateProduct:self.product];
//    XCTAssertTrue(result,@"should update the productInfo successfully");
//    
//}
//
- (void)testInsertOrderItem {
    self.orderItem = [[OrderItem alloc]init];
    [self.orderItem setClientid:1];
    [self.orderItem setStatu:0];
    [self.orderItem setExpressid:1];
    [self.orderItem setParentoid:12];
    [self.orderItem setAddress:@"North Sydney"];
    [self.orderItem setTotoal:123.0];
    [self.orderItem setDiscount:20.0f];
    [self.orderItem setDelivery:12.0f];
    [self.orderItem setSubtotal:120.0f];
    [self.orderItem setProfit:50.0f];
    [self.orderItem setCreatDate:123123123];
    [self.orderItem setShipDate:9123102312];
    [self.orderItem setDeliverDate:123123123];
    [self.orderItem setNote:@"这是一个很好的产品"];
    BOOL result = [self.orderItemManagement updateOrderItem:self.orderItem];
    XCTAssertTrue(result,@"should insert the product successfully");
}

- (void)testGroupOrderProductItem {
    NSArray *gourpOrderItems = [self.orderItemManagement getOrderItemsGroupbyProductidByOrderId:1];
    
    XCTAssertTrue([gourpOrderItems[0] isKindOfClass:[NSDictionary class]],@"should be a dictionary");
}

- (void)testAllGroupOrderProductItem {
    NSArray *gourpOrderItems = [self.orderItemManagement getAllOrderProducts];
    
    NSArray *fitlerOrderItems = [gourpOrderItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"statu = 0"]];
    XCTAssertTrue([gourpOrderItems[0] isKindOfClass:[NSDictionary class]],@"should be a dictionary");
}

//- (void)testGetOrderProductByprocumentStatus {
//    NSArray *oriderProducts = [self.orderItemManagement getprocurementProductItemsByStatus:OrderProduct];
//    NSArray *unOrderProducts = [self.orderItemManagement getprocurementProductItemsByStatus:UnOrderProduct];
//    XCTAssertGreaterThan([oriderProducts count], 0,@"There should be more than 1 product in the database");
//    XCTAssertGreaterThan([unOrderProducts count], 0,@"There should be more than 1 product in the database");
//
//
//}

//- (void)testgetProductByBrand {
//    Brand *brand = [Brand new];
//    brand.bid = 10;
//    NSArray *products = [self.productManage getProductByBrand:brand];
//    XCTAssertNotNil(products , @"There should be more than 1 product in the database");
//}
//
//- (void)testgetProductByCategory {
//    ProductCategory *productCategory = [ProductCategory new];
//    productCategory.cateid = 9;
//    NSArray *products = [self.productManage getProductByCategory:productCategory];
//    XCTAssertNotNil(products , @"There should be more than 1 product in the database");
//}

@end
