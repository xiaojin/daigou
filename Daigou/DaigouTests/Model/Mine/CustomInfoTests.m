//
//  CustomInfoTests.m
//  Daigou
//
//  Created by jin on 5/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CustomInfoManagement.h"
#import "CustomInfo.h"
@interface CustomInfoTests : XCTestCase

@end

@implementation CustomInfoTests{
    CustomInfoManagement *customManage;
}

- (void)setUp {
    [super setUp];
    customManage = [CustomInfoManagement shareInstance];

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

- (void)testQueryCustomInfo {
    NSArray *customes = [customManage getCustomInfo];
    XCTAssertGreaterThan([customes count], 0,@"There should be more than 1 customer in the database");
}

- (void)testUpdateCustomInfo {
    CustomInfo *custom = [[CustomInfo alloc]init];
    [custom setCid:1];
    [custom setName:@"James"];
    [custom setEmail:@"123@163.com"];
    BOOL result = [customManage updateCustomInfo:custom];
    XCTAssertTrue(result,@"should update the custominfo successfully");
    
}

- (void)testInsertCustomInfo{
    //NSArray *customes = [customManage getCustomInfo];
    CustomInfo *custom = [[CustomInfo alloc]init];
    [custom setName:@"Lani"];
    [custom setEmail:@"Lani@163.com"];
    BOOL result = [customManage updateCustomInfo:custom];
    XCTAssertTrue(result,@"should insert the custominfo successfully");
}

@end
