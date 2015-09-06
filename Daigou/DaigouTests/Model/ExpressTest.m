//
//  ExpressTest.m
//  Daigou
//
//  Created by jin on 6/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Express.h"
#import "ExpressManagement.h"

@interface ExpressTest : XCTestCase
@property(nonatomic, strong)Express *express;
@property(nonatomic, strong)ExpressManagement *expressManagement;
@end

@implementation ExpressTest

- (void)setUp {
    [super setUp];
    self.express = [[Express alloc]init];
    self.expressManagement = [ExpressManagement shareInstance];
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

- (void)testQueryExpress {
    NSArray *expressItem = [self.expressManagement getExpress];
    XCTAssertGreaterThan([expressItem count],0, @"There should be more than 1 express in the database");
}

@end
