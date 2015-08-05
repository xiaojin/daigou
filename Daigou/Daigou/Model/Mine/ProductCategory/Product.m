//
//  Product.m
//  Daigou
//
//  Created by jin on 9/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "Product.h"

@implementation Product

- (NSArray *)productToArray {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@(self.categoryid)];
    [result addObject:self.name?self.name : @""];
    [result addObject:self.model?self.model : @""];
    [result addObject:@(self.brandid)];
    
    [result addObject:self.barcode?self.barcode : @""];
    [result addObject:self.quickid?self.quickid : @""];
    [result addObject:self.picture?self.picture : @""];
    [result addObject:@(self.onshelf)?@(self.onshelf) : @(0)];
    [result addObject:@(self.rrp)?@(self.rrp) :@(0.0f)];
    
    [result addObject:@(self.purchaseprice)?@(self.purchaseprice) : @(0.0f)];
    [result addObject:@(self.costprice)?@(self.costprice) : @(0.0f)];
    [result addObject:@(self.lowestprice)?@(self.lowestprice) : @(0.0f)];
    [result addObject:@(self.agentprice)?@(self.agentprice) : @(0.0f)];
    
    [result addObject:@(self.saleprice)?@(self.saleprice) : @(0.0f)];
    [result addObject:@(self.sellprice)?@(self.sellprice) : @(0.0f)];
    [result addObject:@(self.wight)?@(self.wight) : @(0.0f)];
    [result addObject:self.prodDescription?self.prodDescription : @""];
    
    [result addObject:@(self.want)?@(self.want) :@(0.0f)];
    [result addObject:self.avaibility?self.avaibility : @""];
    [result addObject:self.function?self.function : @""];
    [result addObject:self.sellpoint?self.sellpoint : @""];
    
    [result addObject:self.note?self.note : @""];
    [result addObject:self.ename?self.ename : @""];

    return result;
}
- (void)setName:(NSString *)name {
    _name = name ? name : @"";
}

- (void)setCategoryid:(NSInteger)categoryid {

    _categoryid = categoryid ? categoryid : 0;

}

- (void)setModel:(NSString *)model {
    _model = model ? model :@"";
}


- (void)setBarcode:(NSString *)barcode {
    _barcode = barcode ? barcode  :@"";
}

- (void)setQuickid:(NSString *)quickid {
    _quickid = quickid ? quickid  :@"";

}

- (void)setPicture:(NSString *)picture {
    _picture = picture ? picture :@"";
}

- (void)setRrp:(float)rrp {
    _rrp = rrp ? rrp :0.0f;

}

- (void)setOnshelf:(NSInteger)onshelf {
    _onshelf = onshelf ? onshelf : 0;
}

- (void)setPurchaseprice:(float)purchaseprice {
    _purchaseprice = purchaseprice ? purchaseprice :0.0f;

}

- (void)setCostprice:(float)costprice {
    _costprice = costprice ? costprice :0.0f;

}

- (void)setLowestprice:(float)lowestprice {
    _lowestprice = lowestprice ? lowestprice :0.0f;

}

- (void)setAgentprice:(float)agentprice {
    _agentprice = agentprice ? agentprice :0.0f;

}

- (void)setSaleprice:(float)saleprice {
    _saleprice = saleprice ? saleprice :0.0f;

}

- (void)setSellprice:(float)sellprice {
    _sellprice = sellprice ? sellprice :0.0f;

}
- (void)setWight:(float)wight {
    _wight = wight ? wight :0.0f;

}

- (void)setProdDescription:(NSString *)prodDescription {
    _prodDescription = prodDescription ? prodDescription :@"";

}

- (void)setWant:(NSInteger)want {
    _want = want ? want :0;

}

- (void)setAvaibility:(NSString *)avaibility {
    _avaibility = avaibility ? avaibility :@"";

}

- (void)setFunction:(NSString *)function {
    _function = function ? function :@"";

}

- (void)setSellpoint:(NSString *)sellpoint {
    _sellpoint = sellpoint ? sellpoint :@"";

}

- (void)setNote:(NSString *)note {
    _note = note ? note :@"";

}

- (void)setEname:(NSString *)ename {
    _ename = ename ? ename :@"";
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.pid forKey:@"pid"];
    [aCoder encodeInteger:self.categoryid forKey:@"categoryid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.model forKey:@"model"];
    [aCoder encodeInteger:self.brandid forKey:@"brandid"];
    [aCoder encodeObject:self.barcode forKey:@"barcode"];
    [aCoder encodeObject:self.quickid forKey:@"quickid"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
    [aCoder encodeInteger:self.onshelf forKey:@"onshelf"];
    [aCoder encodeFloat:self.rrp forKey:@"rrp"];
    [aCoder encodeFloat:self.purchaseprice forKey:@"purchaseprice"];
    [aCoder encodeFloat:self.costprice forKey:@"costprice"];
    [aCoder encodeFloat:self.lowestprice forKey:@"lowestprice"];
    [aCoder encodeFloat:self.agentprice forKey:@"agentprice"];
    [aCoder encodeFloat:self.saleprice forKey:@"saleprice"];
    [aCoder encodeFloat:self.sellprice forKey:@"sellprice"];
    [aCoder encodeFloat:self.wight forKey:@"wight"];
    [aCoder encodeObject:self.prodDescription forKey:@"prodDescription"];
    [aCoder encodeInteger:self.want forKey:@"want"];
    [aCoder encodeObject:self.avaibility forKey:@"avaibility"];
    [aCoder encodeObject:self.function forKey:@"function"];
    [aCoder encodeObject:self.sellpoint forKey:@"sellpoint"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.ename forKey:@"ename"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.pid = [aDecoder decodeIntegerForKey:@"pid"];
        self.categoryid = [aDecoder decodeIntegerForKey:@"categoryid"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.model = [aDecoder decodeObjectForKey:@"model"];
        self.brandid = [aDecoder decodeIntegerForKey:@"brandid"];
        self.barcode = [aDecoder decodeObjectForKey:@"barcode"];
        self.quickid = [aDecoder decodeObjectForKey:@"quickid"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
        self.onshelf = [aDecoder decodeIntegerForKey:@"onshelf"];
        self.rrp = [aDecoder decodeFloatForKey:@"rrp"];
        self.purchaseprice = [aDecoder decodeFloatForKey:@"purchaseprice"];
        self.costprice = [aDecoder decodeFloatForKey:@"costprice"];
        self.lowestprice = [aDecoder decodeFloatForKey:@"lowestprice"];
        self.agentprice = [aDecoder decodeFloatForKey:@"agentprice"];
        self.saleprice = [aDecoder decodeFloatForKey:@"saleprice"];
        self.sellprice = [aDecoder decodeFloatForKey:@"sellprice"];
        self.wight = [aDecoder decodeFloatForKey:@"wight"];
        self.prodDescription = [aDecoder decodeObjectForKey:@"prodDescription"];
        self.want = [aDecoder decodeIntegerForKey:@"want"];
        self.avaibility = [aDecoder decodeObjectForKey:@"avaibility"];
        self.function = [aDecoder decodeObjectForKey:@"function"];
        self.sellpoint = [aDecoder decodeObjectForKey:@"sellpoint"];
        self.note = [aDecoder decodeObjectForKey:@"note"];
        self.ename = [aDecoder decodeObjectForKey:@"ename"];
    }
    return self;
}

@end
