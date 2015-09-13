//
//  OrderPhotoViewCell.h
//  Daigou
//
//  Created by jin on 12/09/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;
@protocol PhotoViewCellDelegate <NSObject>
- (void)deletePhoto:(Photo*) photo;
- (void)showPhoto:(Photo*)photo;
@end
@interface OrderPhotoViewCell : UICollectionViewCell
@property (nonatomic, strong)Photo *photo;
@property (nonatomic) BOOL readOnly;
@property(nonatomic, weak) id<PhotoViewCellDelegate> delegate;

- (void)startAnimation;
- (void)stopAnimation;
@end
