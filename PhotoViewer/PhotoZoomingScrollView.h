//
//  PhotoZoomingScrollView.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoZoomingScrollViewDelegate <NSObject>
- (void)tapToDismiss;
@end

@interface PhotoZoomingScrollView : UIScrollView

@property (nonatomic, weak) id <PhotoZoomingScrollViewDelegate> tapDelegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSURL *imageUrl;


@property (nonatomic, getter = isLoading, readonly) BOOL loading;

- (void)display;
- (void)prepareForReuse;

- (UIImage *)showingImage;
@end
