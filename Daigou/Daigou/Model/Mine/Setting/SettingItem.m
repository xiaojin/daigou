//
// Created by Kai Liao on 10/09/15.
// Copyright (c) 2015 dg. All rights reserved.
//

#import <ionicons/IonIcons.h>
#import "SettingItem.h"


@implementation SettingItem {

}

- (instancetype)initWithIcon:(IonIcons *)icon title:(NSString *)title controller:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.controller = controller;
    }

    return self;
}

+ (instancetype)itemWithIcon:(IonIcons *)icon title:(NSString *)title controller:(UIViewController *)controller {
    return [[self alloc] initWithIcon:icon title:title controller:controller];
}

@end