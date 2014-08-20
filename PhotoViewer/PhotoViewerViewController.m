//
//  PhotoViewerViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PhotoViewerViewController.h"
#import "PhotoZoomingScrollView.h"


#import "EGOImageView.h"

#define PADDING     10.0

@interface PhotoViewerViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *recyclePages;

@end

@implementation PhotoViewerViewController
{
    NSUInteger _currentPageIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate: (id <PhotoViewerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.recyclePages = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectIntegral(CGRectMake(-PADDING, 0, self.view.bounds.size.width + 2 * PADDING, self.view.bounds.size.height))];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = [self contentSizeForScrollView];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayPhotoAtIndex:_currentPageIndex];
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
    page.tag = index + 1;
    [page display];
    [self.scrollView addSubview:page];
}

- (PhotoZoomingScrollView *)dequeueRecyclePage
{
    PhotoZoomingScrollView *page = [self.recyclePages anyObject];
    if (!page) {
        page = [[PhotoZoomingScrollView alloc] init];
    } else {
        [self.recyclePages removeObject:page];
    }
    return page;
}


#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (_currentPageIndex == currentPage) {
        return;
    }
    _currentPageIndex = currentPage;
    
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
