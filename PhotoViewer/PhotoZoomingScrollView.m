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



@end

@implementation PhotoZoomingScrollView

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = YES;
        self.userInteractionEnabled = YES;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 3.0;
        self.zoomScale = 1.0f;
        
        self.imageView = [[EGOImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
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
}

- (void)prepareForReuse
{
    self.tag = NSUIntegerMax;
    self.imageView.image = nil;
    self.zoomScale = 1.0;
}


- (void)display
{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    self.imageView.image = self.image;
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
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


@end
