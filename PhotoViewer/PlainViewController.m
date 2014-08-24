//
//  PlainViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-24.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PlainViewController.h"
#import "PhotoViewer.h"
#import "ImageZoomPresentAnimation.h"

@interface PlainViewController () <PhotoViewerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIImageView *imageViewLocal;
@property (nonatomic, strong) UIImageView *imageViewRemote;
@property (nonatomic, strong) PhotoViewer *photoViewer;

@end

@implementation PlainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageViewLocal = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.imageViewLocal.image = [UIImage imageNamed:@"0.jpg"];
    self.imageViewLocal.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewLocal.clipsToBounds = YES;
    self.imageViewLocal.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.imageViewLocal addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.imageViewLocal];
    
    self.imageViewRemote = [[UIImageView alloc] initWithFrame:CGRectMake(150, 300, 100, 100)];
    self.imageViewRemote.image = [UIImage imageNamed:@"3.jpg"];
    self.imageViewRemote.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewRemote.clipsToBounds = YES;
    self.imageViewRemote.userInteractionEnabled = YES;
    [self.view addSubview:self.imageViewRemote];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(tapAction:)];
    tapGestureR.numberOfTapsRequired = 1;
    
    [self.imageViewRemote addGestureRecognizer:tapGestureR];
}

- (void)tapAction: (UITapGestureRecognizer *)tapGesture
{
    self.photoViewer = [[PhotoViewer alloc] initWithDelegate:self];
    self.photoViewer.transitioningDelegate = self;
    if (tapGesture.view == self.imageViewLocal) {
        self.photoViewer.currentPageIndex = 0;
    } else
        self.photoViewer.currentPageIndex = 1;
    [self presentViewController:self.photoViewer animated:YES completion:nil];
}


- (CGRect)referenceImageViewFrame
{
    // Use currentPageIndex to decide which image view's frame should be returned
    if (self.photoViewer.currentPageIndex == 0) {
        return self.imageViewLocal.frame;
    } else if (self.photoViewer.currentPageIndex == 1) {
        return self.imageViewRemote.frame;
    }
    return CGRectZero;
}

#pragma mark - Transition delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:PhotoViewer.class]) {
        return [[ImageZoomPresentAnimation alloc] initWithReferenceImageViewFrame:[self referenceImageViewFrame]];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:PhotoViewer.class]) {
        return [[ImageZoomPresentAnimation alloc] initWithReferenceImageViewFrame:[self referenceImageViewFrame]];
    }
    return nil;
}


#pragma mark - PhotoViewer delegate
- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.photoViewer = nil;
    }];
}

- (NSUInteger)numberOfPhotos
{
    return 2;
}

- (UIImage *)photoViewer:(PhotoViewer *)photoViewer photoAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return self.imageViewLocal.image;
    }
    return nil;
}

- (NSString *)photoViewer:(PhotoViewer *)photoViewer photoUrlAtIndex:(NSUInteger)index
{
    if (index == 1) {
        return @"http://ww2.sinaimg.cn/bmiddle/a0c74f04jw1ejliay7n4rj20c80godi7.jpg";
    }
    return nil;
}

- (UIImage *)photoViewer:(PhotoViewer *)photoViewer thumbnailAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return self.imageViewLocal.image;
    } else if (index == 1) {
        return self.imageViewRemote.image;
    }
    return nil;
}

@end
