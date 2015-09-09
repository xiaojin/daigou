//
// Created by Kai Liao on 10/09/15.
// Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IonIcons;


@interface SettingItem : NSObject
    @property(nonatomic, strong) IonIcons *icon;
    @property(nonatomic, strong) NSString *title;
    @property(nonatomic, strong) UIViewController *controller;

- (instancetype)initWithIcon:(IonIcons *)icon title:(NSString *)title controller:(UIViewController *)controller;

+ (instancetype)itemWithIcon:(IonIcons *)icon title:(NSString *)title controller:(UIViewController *)controller;

@end