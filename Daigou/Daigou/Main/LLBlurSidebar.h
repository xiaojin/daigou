//
//  LLBlurSidebar.h
//  Gaoguan
//
//  Created by lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LLBlurSidebar : UIViewController

@property (nonatomic, retain) UIView* contentView; // 所有要显示的子控件全添加到这里
@property (nonatomic, assign) BOOL isSidebarShown;

/**
 * @brief 当有pan事件时调用，传入UIPanGestureRecognizer
 */
- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;

/**
 * @brief 执行显示/隐藏Sidebar
 */
- (void)showHideSidebar;

/** 
 * @brief 需要时可以在子类中用
 */
- (void)sidebarDidShown;

/**
 * @brief 设置侧栏的背景色，参数为16进制0xffffff的形式
 */
- (void)setBgRGB:(long)rgb;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
