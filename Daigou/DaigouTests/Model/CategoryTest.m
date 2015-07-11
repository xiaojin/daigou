//
//  CategoryTest.m
//  Daigou
//
//  Created by jin on 11/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ProductCategory.h"
#import "ProductCategoryManagement.h"
@interface CategoryTest : XCTestCase
@property(nonatomic ,strong) ProductCategory *category;
@property(nonatomic, strong) ProductCategoryManagement *categoryManagement;
@end

@implementation CategoryTest

- (void)setUp {
    [super setUp];
    self.categoryManagement = [ProductCategoryManagement shareInstance];
    self.category = [[ProductCategory alloc]init];
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

- (void)testQueryCategory {
    NSArray *categories = [self.categoryManagement getCategory];
    XCTAssertGreaterThan([categories count], 0,@"There should be more than 1 product in the database");
}
@end
