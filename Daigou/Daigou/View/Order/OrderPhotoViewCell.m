//
//  OrderPhotoViewCell.m
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderPhotoViewCell.h"
#import "Photo.h"
#import "CommonDefines.h"
#import <UIAlertView-Blocks/RIButtonItem.h>
#import <UIAlertView-Blocks/UIActionSheet+Blocks.h>

@implementation OrderPhotoViewCell {
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, 70, 70);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet:)];
        singleTap.cancelsTouchesInView = NO;
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_imageView addGestureRecognizer:singleTap];
        _imageView.userInteractionEnabled = YES;
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 70, 70);
        _activityView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageView];
        
        _readOnly = NO;
    }
    
    return self;
}

- (void)showActionSheet:(id)deletePhoto {
    
    if (_readOnly) {
        [_delegate showPhoto:_photo];
        return;
    }
    if (IOS8_OR_ABOVE) {
        [self menuDeletePhotoiOS8AndAbove];
    } else {
        [self menuDeletePhotoBelowiOS8];
    }
}

- (void)menuDeletePhotoiOS8AndAbove {
    __weak Photo *weakPhoto = _photo;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction * action) {
                                                               [_delegate deletePhoto:weakPhoto];
                                                           }];
    UIAlertAction* viewPhotoBtn = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [_delegate showPhoto:weakPhoto];
                                                         }];
    __weak id weakSelf = self;
    [alert addAction:viewPhotoBtn];
    [alert addAction:destructiveBtn];
    alert.popoverPresentationController.sourceRect = _imageView.frame;
    alert.popoverPresentationController.sourceView = weakSelf;
    
    [[[[[[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers] lastObject] visibleViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)menuDeletePhotoBelowiOS8 {
    RIButtonItem *destructiveBtn = [RIButtonItem itemWithLabel:@"删除" action:^{
        [_delegate deletePhoto:_photo];
    }];
    RIButtonItem *viewImageBtn = [RIButtonItem itemWithLabel:@"查看" action:^{
        [_delegate showPhoto:_photo];
    }];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     cancelButtonItem:[RIButtonItem itemWithLabel:@"取消"]
                                                destructiveButtonItem: destructiveBtn
                                                     otherButtonItems:viewImageBtn, nil];
    
    [actionSheet showFromRect:_imageView.frame inView:self animated:YES];
}

- (void)startAnimation {
    [self addSubview:_activityView];
    [_activityView startAnimating];
}

- (void)stopAnimation {
    [_activityView removeFromSuperview];
    [_activityView stopAnimating];
}

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    if (photo.image) {
        _imageView.image = photo.image;
    } else {
        _imageView.image = nil;
    }
}

@end
