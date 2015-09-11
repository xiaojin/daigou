//
// Created by Kai Liao on 10/09/15.
// Copyright (c) 2015 dg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IonIcons;


@interface SettingItem : NSObject
    @property(nonatomic, strong) NSString *icon;
    @property(nonatomic, strong) NSString *title;
    @property(nonatomic, strong) Class controllerClass;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title controller:(Class)controller;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title controller:(Class)controllerClass;



@end