PhotoViewer
===========
PhotoViewer provides a method for displaying images from Web or local file.
it includes SDWebImage so it has features that SDWebImage has.

How to Install
===========
Just draging class files to your project.

Usage
===========
Getting start with PhotoViewer is dead simple. Just initialize it with delegate. Like this:
  self.pvc = [[PhotoViewer alloc] initWithDelegate:self];

If you want to display a specific index of photo when PhotoViewer shows, you should assign a number to "currentPageIndex", Like this:
  self.pvc.currentPageIndex = 3;

PhotoViewr provides view controller Animated transition if implements transitionDelegate of PhotoViewer class. Like this:
  self.pvc.transitioningDelegate = self;

Then you must implement:
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

PhotoViewer has several delegate methods:

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
  
PhotoViewer will call photoViewer:photoAtIndex: first. If it can't get a UIImage Object, then it calls photoViewer:photoUrlAtIndex: .
thumnail is used as placeholder when downloading images from Internet and used for view controller transition.



  
