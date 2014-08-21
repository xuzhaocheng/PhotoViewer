//
//  PhotoZoomingScrollView.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PhotoZoomingScrollView.h"
#import "EGOImageView.h"

@interface PhotoZoomingScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) EGOImageView *imageView;
@property (nonatomic, readwrite, getter = isLoading) BOOL loading;

@end

@implementation PhotoZoomingScrollView
{
    BOOL _isNeedCenter;
}

#pragma mark - Properties
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.loading = NO;
}

- (UIImage *)showingImage
{
    if (self.image) {
        return self.image;
    } else if (self.imageView.image) {
        return self.imageView.image;
    } else {
        return self.thumbnail;
    }
}



#pragma mark - Set up
- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = YES;
        self.userInteractionEnabled = YES;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 3.0;
        self.zoomScale = 1.0f;
        self.loading = YES;
        _isNeedCenter = YES;
        
        self.imageView = [[EGOImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.backgroundColor = [UIColor redColor];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [self.imageView addGestureRecognizer:singleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
        [self addSubview:self.imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundViewTap)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
         NSLog(@"w: %f, h: %f", self.bounds.size.width, self.bounds.size.height);
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isNeedCenter) {
        // Center the image as it becomes smaller than the size of the screen
        CGSize boundsSize = self.bounds.size;
        CGRect frameToCenter = self.imageView.frame;
        
        // Horizontally
        if (frameToCenter.size.width < boundsSize.width) {
            frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
        } else {
            frameToCenter.origin.x = 0;
        }
        
        // Vertically
        if (frameToCenter.size.height < boundsSize.height) {
            frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
        } else {
            frameToCenter.origin.y = 0;
        }
        
        // Center
        if (!CGRectEqualToRect(self.imageView.frame, frameToCenter))
            self.imageView.frame = frameToCenter;
    } else {
        _isNeedCenter = YES;
    }
}

- (void)prepareForReuse
{
    self.tag = NSUIntegerMax;
    self.imageView.image = nil;
    self.zoomScale = 1.0;
}

#pragma mark - Set up

- (void)display
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    if (self.image) {
        self.imageView.image = self.image;
        self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    } else {
        self.imageView.placeholderImage = self.thumbnail;
        [self.imageView setImageURL:self.imageUrl];
        self.imageView.frame = CGRectMake(0, 0, self.thumbnail.size.width, self.thumbnail.size.height);
    }
    
    self.contentSize = self.imageView.frame.size;
    
    [self setMinMaxZoomScale];
    
    if (self.imageUrl) {
        self.imageView.placeholderImage = self.thumbnail;
        [self.imageView setImageURL:self.imageUrl];
    } else {
        self.imageView.image = self.image;
    }
    [self setNeedsLayout];
}


- (void)setMinMaxZoomScale
{
    self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
	CGFloat maxScale = 3;
    
    // Image is smaller than screen so no zooming!
	if (xScale >= 1 && yScale >= 1) {
		minScale = 1.0;
	}
    
    self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
    self.zoomScale = self.minimumZoomScale;
    
}


#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Tap Action
- (void)handleBackgroundViewTap
{
    if ([_tapDelegate respondsToSelector:@selector(tapToDismiss)]) {
        [_tapDelegate tapToDismiss];
    }
}

- (void)handleDoubleTap: (UIGestureRecognizer *)tapGesture
{
    if (self.zoomScale != self.minimumZoomScale) {
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		// Zoom in to twice the size
        CGPoint touchPoint = [tapGesture locationInView:self.imageView];
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];
        
	}
}

- (void)handleSingleTap: (UIGestureRecognizer *)tapGesture
{
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        if ([_tapDelegate respondsToSelector:@selector(tapToDismiss)]) {
            [_tapDelegate tapToDismiss];
        }
    }
}

#pragma mark - Animation
- (void)animationFromRect:(CGRect)rect
{
    CGRect finalFrame = self.imageView.frame;
    self.imageView.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = finalFrame;
    }];
}

- (void)animationToRect:(CGRect)rect completion:(void(^)())block
{
    _isNeedCenter = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished && block) {
            block();
        }
    }];

}

@end
