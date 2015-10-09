//
//  SellInfo.m
//  Daigou
//
//  Created by jin on 9/10/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "SellInfo.h"

@implementation SellInfo
- (NSArray * )sellToArray {
    NSArray *result = @[self.storename?self.storename :[NSNull null],
                        self.slogon?self.slogon :[NSNull null],
                        self.name?self.name:[NSNull null],
                        self.ename?self.ename:[NSNull null],
                        self.email?self.email :[NSNull null],
                        self.phonenum?self.postcode : [NSNull null],
                        self.idnum?self.idnum :[NSNull null],
                        self.address?self.address :[NSNull null],
                        self.postcode?self.postcode :[NSNull null],
                        self.bankinfo?self.bankinfo :[NSNull null],
                        @(self.region)?@(self.region) :[NSNull null],
                        @(self.syncDate)?@(self.syncDate) :[NSNull null]];
    return result;

}
@end
