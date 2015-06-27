//
//  MCustomInfoItemView.h
//  Daigou
//
//  Created by jin on 27/06/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//


/**
 *  TODO ADD UILABLE, UITEXTFILED
 *
 *  @param nonatomic <#nonatomic description#>
 *  @param assign    <#assign description#>
 *
 *  @return <#return value description#>
 */
#import <UIKit/UIKit.h>

@interface MCustomInfoItemView : UIView
@property(nonatomic,assign)CGSize viewSize;

- (instancetype)initWIthTypeTitle:(NSString *)title viewSize:(CGSize)size;
@end
