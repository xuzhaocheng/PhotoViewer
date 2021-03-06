//
//  PhotoViewerViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PhotoViewer.h"
#import "PhotoZoomingScrollView.h"

#define PADDING     10.0

@interface PhotoViewer () <UIScrollViewDelegate, PhotoZoomingScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageController;

@property (nonatomic, strong) NSMutableSet *recyclePages;

@end

@implementation PhotoViewer
{
    BOOL _shouldHideStatusBar;
    BOOL _scrollingLocked;
    
    NSUInteger _supportedInterfaceOrientations;
}

#pragma mark - Life Cycle
- (id)initWithDelegate: (id <PhotoViewerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
        self.recyclePages = [[NSMutableSet alloc] init];
        _shouldHideStatusBar = NO;
    }
    return self;
}


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectIntegral(CGRectMake(-PADDING, 0, self.view.bounds.size.width + 2 * PADDING, self.view.bounds.size.height))];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = [self contentSizeForScrollView];
    [self.view addSubview:self.scrollView];

    if ([self numberOfPhotos] > 1) {
        self.pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 20)];
        self.pageController.numberOfPages = [self numberOfPhotos];
        self.pageController.currentPage = _currentPageIndex;
        [self.view insertSubview:self.pageController aboveSubview:self.scrollView];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _shouldHideStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [self displayPhotoAtIndex:_currentPageIndex];
    [self moveToPageAtIndex:_currentPageIndex];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _shouldHideStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    [UIViewController attemptRotationToDeviceOrientation];
}


#pragma mark - Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return _supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _scrollingLocked = NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _scrollingLocked = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareForRotation];
}

- (void)prepareForRotation
{
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = CGRectMake(-PADDING, 0, self.view.bounds.size.width + 2 * PADDING, self.view.bounds.size.height);
    
    for (NSInteger i = 0; i < [self numberOfPhotos]; i++) {
        if ([self.scrollView viewWithTag:i+1]) {
            PhotoZoomingScrollView *view = (PhotoZoomingScrollView *)[self.scrollView viewWithTag:i+1];
            view.frame = CGRectMake(i * self.scrollView.frame.size.width + PADDING, 0, bounds.size.width, bounds.size.height);
            [view display];
        }
    }
    
    self.scrollView.contentSize = [self contentSizeForScrollView];
    self.scrollView.contentOffset = CGPointMake(self.currentPageIndex * self.scrollView.bounds.size.width, 0);
    
    if (self.pageController) {
        self.pageController.frame = CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 20);
    }
}


#pragma mark - Appearence
- (BOOL)prefersStatusBarHidden
{
    return _shouldHideStatusBar;
}


#pragma mark - Methods

- (UIImage *)imageInPageAtIndex:(NSUInteger)index
{
    PhotoZoomingScrollView *page = (PhotoZoomingScrollView *)[self.scrollView viewWithTag:_currentPageIndex + 1];
    return page.showingImage;
}

#pragma mark - Helpers
- (void)moveToPageAtIndex: (NSUInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * index, 0)];
}

#pragma mark - Properties
- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    if (currentPageIndex < [self numberOfPhotos]) {
        _currentPageIndex = currentPageIndex;
        self.pageController.currentPage = currentPageIndex;
    }
}


#pragma mark - Paging
- (void)displayPhotoAtIndex: (NSUInteger)index
{
    [self addPhotoToPageAtIndex:index];
    if ((NSInteger)index - 1 >= 0) [self addPhotoToPageAtIndex:index - 1];
    if (index + 1 < [self numberOfPhotos]) [self addPhotoToPageAtIndex:index + 1];
}

- (void)addPhotoToPageAtIndex: (NSUInteger)index
{
    if ([self.scrollView viewWithTag:index + 1]) {
        [((PhotoZoomingScrollView *)[self.scrollView viewWithTag:index + 1]) display];
        return;
    }
    
    PhotoZoomingScrollView *page = [self dequeueRecyclePage];
    page.frame = CGRectMake(index * self.scrollView.frame.size.width + PADDING, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    page.image = [self photoAtIndex:index];
    page.imageUrl = [self photoUrlAtIndex:index];
    page.thumbnail = [self thumbnailAtIndex:index];
    page.tag = index + 1;
    [page display];
    
    [self.scrollView addSubview:page];
}

- (PhotoZoomingScrollView *)dequeueRecyclePage
{
    PhotoZoomingScrollView *page = [self.recyclePages anyObject];
    if (!page) {
        page = [[PhotoZoomingScrollView alloc] init];
        page.tapDelegate = self;
    } else {
        [self.recyclePages removeObject:page];
    }
    return page;
}


#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollingLocked)   return;
    
    NSInteger currentPage = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    if (_currentPageIndex == currentPage) {
        return;
    }
    self.currentPageIndex = currentPage;
    
    // remove all pages except -1 0 +1 pages
    for (NSInteger i = 0; i < [self numberOfPhotos]; i++) {
        if ([scrollView viewWithTag:i+1] && (i < currentPage - 1 || i > currentPage + 1)) {
            PhotoZoomingScrollView *recycleView = (PhotoZoomingScrollView *)[scrollView viewWithTag:i+1];
            [recycleView prepareForReuse];
            [self.recyclePages addObject:recycleView];
            [recycleView removeFromSuperview];
        }
    }
    
    [self displayPhotoAtIndex:currentPage];
    NSLog(@"current page: %ld", (long)currentPage);
}

#pragma mark - PhotoZoomingScrollView delegate
- (void)tapToDismiss
{
    if ([_delegate respondsToSelector:@selector(dismissViewController)]) {
        [_delegate dismissViewController];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Frame

- (CGSize)contentSizeForScrollView
{
    return CGSizeMake([self numberOfPhotos] * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
}

#pragma mark - Data
- (NSUInteger)numberOfPhotos
{
    if ([_delegate respondsToSelector:@selector(numberOfPhotos)]) {
        return [_delegate numberOfPhotos];
    }
    return 0;
}

- (UIImage *)photoAtIndex: (NSUInteger)index
{
    if ([_delegate respondsToSelector:@selector(photoViewer:photoAtIndex:)]) {
        return [_delegate photoViewer:self photoAtIndex:index];
    }
    return nil;
}

- (NSURL *)photoUrlAtIndex: (NSUInteger)index
{
    if ([_delegate respondsToSelector:@selector(photoViewer:photoUrlAtIndex:)]) {
        return [NSURL URLWithString:[_delegate photoViewer:self photoUrlAtIndex:index]];
    }
    return nil;
}

- (UIImage *)thumbnailAtIndex: (NSUInteger)index
{
    if ([_delegate respondsToSelector:@selector(photoViewer:thumbnailAtIndex:)]) {
        return [_delegate photoViewer:self thumbnailAtIndex:index];
    }
    return nil;
}



@end
