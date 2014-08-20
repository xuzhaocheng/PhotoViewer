//
//  ViewController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-20.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewerViewController.h"

@interface ViewController () <PhotoViewerDelegate>

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [button setTitle:@"click me" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click
{
    PhotoViewerViewController *vc = [[PhotoViewerViewController alloc] initWithDelegate:self];
    [self presentViewController:vc animated:NO completion:nil];
}

- (NSUInteger)numberOfPhotos
{
    return 3;
}

- (UIImage *)photoViewer:(PhotoViewerViewController *)photoViewer photoAtIndex:(NSUInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%lu.jpg", (unsigned long)index]];
}



@end
