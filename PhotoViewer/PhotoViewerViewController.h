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

- (NSUInteger)numberOfPhotos;

@optional
- (UIImage *)photoViewer: (PhotoViewerViewController *)photoViewer thumbnailAtIndex: (NSUInteger)index;
- (UIImage *)photoViewer: (PhotoViewerViewController *)photoViewer photoAtIndex: (NSUInteger)index;
- (NSString *)photoViewer: (PhotoViewerViewController *)photoViewer photoUrlAtIndex: (NSUInteger)index;

@end

@interface PhotoViewerViewController : UIViewController

@property (nonatomic, weak) id <PhotoViewerDelegate> delegate;

- (id)initWithDelegate: (id <PhotoViewerDelegate>)delegate;
@end
