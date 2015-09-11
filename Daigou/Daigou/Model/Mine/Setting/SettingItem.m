//
// Created by Kai Liao on 10/09/15.
// Copyright (c) 2015 dg. All rights reserved.
//

#import <ionicons/IonIcons.h>
#import "SettingItem.h"


@implementation SettingItem {

}

- (instancetype)initWithIcon:(IonIcons *)icon title:(NSString *)title controller:(Class)controllerClass {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.controllerClass = controllerClass;
    }

    return self;
}

+ (instancetype)itemWithIcon:(IonIcons *)icon title:(NSString *)title controller:(Class)controllerClass {
    return [[self alloc] initWithIcon:icon title:title controller:controllerClass];
}


@end