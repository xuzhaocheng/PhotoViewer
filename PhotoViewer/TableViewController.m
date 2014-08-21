//
//  TableViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#import "PhotoViewerViewController.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate, PhotoViewerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TableViewCell *selectedCell;

@end

@implementation TableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // You should give the right frame of reference
    // So PhotoViewer can show with animation correctly
    UIImageView *referenceImageView = [[UIImageView alloc] initWithImage:imageView.image];
    referenceImageView.frame = [self.view convertRect:imageView.frame fromView:cell];
    referenceImageView.contentMode = UIViewContentModeScaleAspectFill;
    referenceImageView.clipsToBounds = YES;

    PhotoViewerViewController *pvc = [[PhotoViewerViewController alloc] initWithDelegate:self];
    // Tell PhotoViewer photo in which index you want to show first
    // If referenceImageView is set to nil, showing with no animation
    [pvc firstShowPageAtIndex:imageView.tag - 1 referenceImageView:referenceImageView];
    [self presentViewController:pvc animated:NO completion:nil];
}

#pragma mark - PhotoViewer delegate
- (NSUInteger)numberOfPhotos
{
    return self.selectedCell.imageViews ? self.selectedCell.imageViews.count : 0;
}

- (UIImage *)photoViewer:(PhotoViewerViewController *)photoViewer photoAtIndex:(NSUInteger)index
{
    if (!self.selectedCell.imageViews || index >= self.selectedCell.imageViews.count) {
        return nil;
    }
    return ((UIImageView *)self.selectedCell.imageViews[index]).image;
}

- (UIImage *)photoViewer:(PhotoViewerViewController *)photoViewer thumbnailAtIndex:(NSUInteger)index
{
    if (!self.selectedCell.imageViews || index >= self.selectedCell.imageViews.count) {
        return nil;
    }
    return ((UIImageView *)self.selectedCell.imageViews[index]).image;
}


@end
