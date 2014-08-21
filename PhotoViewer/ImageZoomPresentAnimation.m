//
//  ImageZoomPresentAnimation.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ImageZoomPresentAnimation.h"
#import "PhotoViewerViewController.h"

@interface ImageZoomPresentAnimation ()
@property (nonatomic, strong) UIImageView *referenceImageView;
@end

@implementation ImageZoomPresentAnimation


- (id)initWithReferenceImageView: (UIImageView *)refercenImageView
{
    self = [super init];
    if (self) {
        self.referenceImageView = refercenImageView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.45f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC.isBeingPresented) {
        [self animateZoomInTransition:transitionContext];
    } else {
        [self animateZoomOutTransition:transitionContext];
    }
}

- (void)animateZoomInTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PhotoViewerViewController *toVC = (PhotoViewerViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.referenceImageView.frame];
    imageView.image = self.referenceImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:imageView];
    containerView.backgroundColor = [UIColor blackColor];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect imageViewFinalFrame = [self resizeImage:self.referenceImageView.image forRect:finalFrame]; //CGRectMake(floor((finalFrame.size.width - imageSize.width) / 2),
                                   //floor((finalFrame.size.height - imageSize.height) / 2),
                                   //imageSize.width, imageSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVC.view.alpha = 0;
                         imageView.frame = imageViewFinalFrame;
                     } completion:^(BOOL finished) {
                         fromVC.view.alpha = 1;
                         [imageView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    
}

- (void)animateZoomOutTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PhotoViewerViewController *fromVC = (PhotoViewerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    toVC.view.alpha = 0;
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView sendSubviewToBack:toVC.view];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [fromVC imageInPageAtIndex:fromVC.currentPageIndex];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    imageView.frame = [self resizeImage:imageView.image forRect:finalFrame];
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    transitionContext.containerView.alpha = 1;
    [transitionContext.containerView addSubview:imageView];
    
    [fromVC.view removeFromSuperview];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.view.alpha = 1.0;
                         imageView.frame = self.referenceImageView.frame;
                     } completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];

    

}

- (CGRect)resizeImage:(UIImage *)image forRect: (CGRect)rect
{
    CGSize imageSize = image.size ;
    CGFloat xScale = rect.size.width / imageSize.width;
    CGFloat yScale = rect.size.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    if (minScale > 1) {
        minScale = 1;
    }
    imageSize.width = minScale * imageSize.width;
    imageSize.height = minScale * imageSize.height;
    
    return CGRectMake(floor((rect.size.width - imageSize.width) / 2),
                                            floor((rect.size.height - imageSize.height) / 2),
                                            imageSize.width, imageSize.height);
}

@end
