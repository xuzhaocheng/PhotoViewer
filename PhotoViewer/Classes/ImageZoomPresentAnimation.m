//
//  ImageZoomPresentAnimation.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ImageZoomPresentAnimation.h"
#import "PhotoViewer.h"

@interface ImageZoomPresentAnimation ()
@property (nonatomic, weak) UIImageView *referenceImageView;
@end

@implementation ImageZoomPresentAnimation


- (id)initWithReferenceImageView:(UIImageView *)refercenImageView
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
    PhotoViewer *toVC = (PhotoViewer *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    CGRect imageViewFrame = [containerView convertRect:self.referenceImageView.frame fromView:self.referenceImageView.superview];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = self.referenceImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    
    [containerView addSubview:imageView];
    containerView.backgroundColor = [UIColor blackColor];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect imageViewFinalFrame = [self resizeImage:imageView.image forRect:finalFrame];
    
    [fromVC.view removeFromSuperview];
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
                         [containerView addSubview:toVC.view];
                         [transitionContext completeTransition:YES];
                     }];
    
}

- (void)animateZoomOutTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PhotoViewer *fromVC = (PhotoViewer *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    containerView.backgroundColor = [UIColor blackColor];
    containerView.alpha = 1;
    
    toVC.view.alpha = 0;
    [fromVC.view removeFromSuperview];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    ///// Important!!!!
    toVC.view.frame = finalFrame;
    ////////
    
    [transitionContext.containerView addSubview:toVC.view];
    [transitionContext.containerView sendSubviewToBack:toVC.view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self.referenceImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = [self resizeImage:imageView.image forRect:finalFrame];
    
    CGRect imageViewFrame = [toVC.view convertRect:self.referenceImageView.frame fromView:self.referenceImageView.superview];
    
    if ([toVC isKindOfClass:[UINavigationController class]]) {
       UIViewController *currentVC = [((UINavigationController *)toVC).viewControllers lastObject];
        [currentVC.view addSubview:imageView];
    } else {
        [toVC.view addSubview:imageView];
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.view.alpha = 1.0;
                         imageView.frame = imageViewFrame;
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
    
    imageSize.width = minScale * imageSize.width;
    imageSize.height = minScale * imageSize.height;
    
    return CGRectMake(floor((rect.size.width - imageSize.width) / 2),
                                            floor((rect.size.height - imageSize.height) / 2),
                                            imageSize.width, imageSize.height);
}

@end
