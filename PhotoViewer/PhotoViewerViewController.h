//
//  PhotoViewerViewController.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoViewerViewController;

@protocol PhotoViewerDelegate <NSObject>

- (void)dismissViewController;

- (NSUInteger)numberOfPhotos;
- (UIImage *)photoViewer: (PhotoViewerViewController *)photoViewer thumbnailAtIndex: (NSUInteger)index;

@optional
// Uses photoViewer:photoAtIndex: first
- (UIImage *)photoViewer: (PhotoViewerViewController *)photoViewer photoAtIndex: (NSUInteger)index;
// If can not find photoViewer:photoAtIndex:, then uses photoViewer:photoUrlAtIndex:
- (NSString *)photoViewer: (PhotoViewerViewController *)photoViewer photoUrlAtIndex: (NSUInteger)index;

@end

@interface PhotoViewerViewController : UIViewController

@property (nonatomic, weak) id <PhotoViewerDelegate> delegate;
@property (nonatomic, readonly) NSUInteger currentPageIndex;

- (id)initWithDelegate: (id <PhotoViewerDelegate>)delegate;
- (void)firstShowPageAtIndex: (NSUInteger)index referenceImageView: (UIImageView *)imageView;

- (UIImage *)imageInPageAtIndex: (NSUInteger)index;

@end
