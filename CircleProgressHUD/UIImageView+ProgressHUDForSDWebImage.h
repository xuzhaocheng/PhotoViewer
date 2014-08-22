//
//  UIImageView+ProgressHUDForSDWebImage.h
//  SDWebImagetest
//
//  Created by xuzhaocheng on 14-8-22.
//  Copyright (c) 2014年 louis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "CircleProgressHUD.h"

@interface UIImageView (ProgressHUDForSDWebImage)

- (void)pHUD_setImageWithURL:(NSURL *)url;

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

- (void)pHUD_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

@end
