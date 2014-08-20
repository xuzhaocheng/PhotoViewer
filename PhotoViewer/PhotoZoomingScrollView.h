//
//  PhotoZoomingScrollView.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface PhotoZoomingScrollView : UIScrollView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) EGOImageView *imageView;
- (void)display;
- (void)prepareForReuse;
@end
