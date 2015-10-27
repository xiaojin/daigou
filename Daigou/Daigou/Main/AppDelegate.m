//
//  AppDelegate.m
//  Daigou
//
//  Created by jin on 13/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "AppDelegate.h"
#import "DGViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initShareSDK];
  // Override point for customization after application launch.
    return YES;
}

- (void)initShareSDK {
    [ShareSDK registerApp:@"b9bf1bef062c"];

    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"188502484"
                                appSecret:@"835cf260c6e21c3d38df53907e6a0ff0"
                              redirectUri:@"http://www.idgb.co/"
                              weiboSDKCls:[WeiboSDK class]];
    
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"1104855803"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
