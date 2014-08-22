//
//  UIImageView+ProgressHUDForSDWebImage.m
//  SDWebImagetest
//
//  Created by xuzhaocheng on 14-8-22.
//  Copyright (c) 2014年 louis. All rights reserved.
//

#import "UIImageView+ProgressHUDForSDWebImage.h"

@implementation UIImageView (ProgressHUDForSDWebImage)

- (void)pHUD_setImageWithURL:(NSURL *)url
{
    [self pHUD_setImageWithURL:url
              placeholderImage:nil
                       options:0
                      progress:nil
                     completed:nil];
}

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self pHUD_setImageWithURL:url
              placeholderImage:placeholder
                       options:0
                      progress:nil
                     completed:nil];
}

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self pHUD_setImageWithURL:url
              placeholderImage:placeholder
                       options:options
                      progress:nil
                     completed:nil];
}

- (void)pHUD_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
{
    [self pHUD_setImageWithURL:url
              placeholderImage:nil
                       options:0
                      progress:nil
                     completed:completedBlock];
}

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    [self pHUD_setImageWithURL:url
              placeholderImage:placeholder
                       options:0
                      progress:nil
                     completed:completedBlock];
}

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock
{
    [self pHUD_setImageWithURL:url
              placeholderImage:placeholder
                       options:options
                      progress:nil
                     completed:completedBlock];
}

- (void)pHUD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    CircleProgressHUD *hud = [[CircleProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        hud.progress= receivedSize / (float)expectedSize;
                        if (progressBlock) {
                            progressBlock(receivedSize, expectedSize);
                        }
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (completedBlock) {
                            completedBlock(image, error, cacheType, imageURL);
                        }
                        hud.progress = 1;
                        [hud fadeOutToRemove];
                    }];
}

@end
