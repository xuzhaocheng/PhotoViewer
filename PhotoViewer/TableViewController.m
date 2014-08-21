//
//  TableViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#import "PhotoViewer.h"

#import "ImageZoomPresentAnimation.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, PhotoViewerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TableViewCell *selectedCell;

@property (nonatomic, strong) PhotoViewer *pvc;
@end

@implementation TableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Table View";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierCell = @"IdentifierCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    [imageArr addObject:[UIImage imageNamed:@"0.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"1.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"2.jpg"]];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell images:imageArr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    return cell;
    
}


#pragma mark - TableViewCell delegate
- (void)tableViewCell:(TableViewCell *)cell didClickImageView:(UIImageView *)imageView
{
    self.selectedCell = cell;

    self.pvc = [[PhotoViewer alloc] initWithDelegate:self];
    self.pvc.transitioningDelegate = self;
    self.pvc.currentPageIndex = imageView.tag - 1;
    
    [self presentViewController:self.pvc animated:YES completion:nil];
}

#pragma mark - Dismiss 
- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.pvc = nil;
    }];
}

#pragma mark - PhotoViewer delegate
- (NSUInteger)numberOfPhotos
{
    return self.selectedCell.imageViews ? self.selectedCell.imageViews.count : 0;
}

- (UIImage *)photoViewer:(PhotoViewer *)photoViewer photoAtIndex:(NSUInteger)index
{
    if (!self.selectedCell.imageViews || index >= self.selectedCell.imageViews.count) {
        return nil;
    }
    return ((UIImageView *)self.selectedCell.imageViews[index]).image;
}

- (UIImage *)photoViewer:(PhotoViewer *)photoViewer thumbnailAtIndex:(NSUInteger)index
{
    if (!self.selectedCell.imageViews || index >= self.selectedCell.imageViews.count) {
        return nil;
    }
    return ((UIImageView *)self.selectedCell.imageViews[index]).image;
}


#pragma mark - Transition delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:PhotoViewer.class]) {
        return [[ImageZoomPresentAnimation alloc] initWithReferenceImageView:[self referenceImageView]];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:PhotoViewer.class]) {
        
        return [[ImageZoomPresentAnimation alloc] initWithReferenceImageView:[self referenceImageView]];
    }
    return nil;
}

- (UIImageView *)referenceImageView
{
    UIImageView *currentImageView = [self currentCellImageViewAtIndex:self.pvc.currentPageIndex];
    UIImageView *referenceImageView = [[UIImageView alloc] initWithImage:currentImageView.image];
    referenceImageView.frame = [self.view convertRect:currentImageView.frame fromView:self.selectedCell];
    referenceImageView.contentMode = UIViewContentModeScaleAspectFill;
    referenceImageView.clipsToBounds = YES;
    return referenceImageView;
}

#pragma mark - Helpers
- (UIImageView *)currentCellImageViewAtIndex: (NSUInteger)index
{
    if (!self.selectedCell || index >= self.selectedCell.imageViews.count) {
        return nil;
    }
    return self.selectedCell.imageViews[index];
}
                                           
                                    

@end
