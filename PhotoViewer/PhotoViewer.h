//
//  PhotoViewerViewController.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoViewer;

@protocol PhotoViewerDelegate <NSObject>

- (void)dismissViewController;

- (NSUInteger)numberOfPhotos;
- (UIImage *)photoViewer: (PhotoViewer *)photoViewer thumbnailAtIndex: (NSUInteger)index;

@optional
// Uses photoViewer:photoAtIndex: first
- (UIImage *)photoViewer: (PhotoViewer *)photoViewer photoAtIndex: (NSUInteger)index;
// If can not find photoViewer:photoAtIndex:, then uses photoViewer:photoUrlAtIndex:
- (NSString *)photoViewer: (PhotoViewer *)photoViewer photoUrlAtIndex: (NSUInteger)index;

@end

@interface PhotoViewer : UIViewController

@property (nonatomic, weak) id <PhotoViewerDelegate> delegate;
@property (nonatomic) NSUInteger currentPageIndex;

- (id)initWithDelegate: (id <PhotoViewerDelegate>)delegate;
- (UIImage *)imageInPageAtIndex: (NSUInteger)index;
@end
