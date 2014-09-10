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
{
    BOOL _isWebImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _isWebImage = NO;
    self.title = @"Table View";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableView data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Local Images";
    } else if (section == 1) {
        return @"Web Images";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IdentifierCell = @"IdentifierCell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    
    if (indexPath.section == 0) {
        [imageArr addObject:[UIImage imageNamed:@"0.jpg"]];
        [imageArr addObject:[UIImage imageNamed:@"1.jpg"]];
        [imageArr addObject:[UIImage imageNamed:@"2.jpg"]];
        if (!cell) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell images:imageArr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        } else {
            [cell setImages:imageArr];
        }
    } else {
        [imageArr addObject:[UIImage imageNamed:@"3.jpg"]];
        [imageArr addObject:[UIImage imageNamed:@"4.jpg"]];
        [imageArr addObject:[UIImage imageNamed:@"5.jpg"]];
        if (!cell) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell images:imageArr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        } else {
            [cell setImages:imageArr];
        }
    }
    cell.tag = indexPath.section;
    
    return cell;
    
}




#pragma mark - TableViewCell delegate
- (void)tableViewCell:(TableViewCell *)cell didClickImageView:(UIImageView *)imageView
{
    self.selectedCell = cell;
    _isWebImage = cell.tag == 0 ? NO : YES;
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
    
    if (_isWebImage) {
        return nil;
    }
    
    return ((UIImageView *)self.selectedCell.imageViews[index]).image;
}

- (NSString *)photoViewer:(PhotoViewer *)photoViewer photoUrlAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return @"http://ww2.sinaimg.cn/bmiddle/a0c74f04jw1ejliay7n4rj20c80godi7.jpg";
    } else if (index == 1) {
        return @"http://ww1.sinaimg.cn/bmiddle/a0c74f04jw1ejliaydh3ij20c80gogo3.jpg";
    } else if (index == 2) {
        return @"http://ww3.sinaimg.cn/bmiddle/a0c74f04jw1ejliaygqzzj20c80goq53.jpg";
    }
    
    return nil;
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


// Using convertRect:fromView: to calculate new frame
- (CGRect)referenceImageViewFrame
{
    UIImageView *currentImageView = [self currentCellImageViewAtIndex:self.pvc.currentPageIndex];
    return [self.view convertRect:currentImageView.frame fromView:self.selectedCell];
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
