//
//  CustomNavigationController.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-9-19.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *topVC = [self topViewController];
    return [topVC supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [[self topViewController] shouldAutorotate];
}

@end
