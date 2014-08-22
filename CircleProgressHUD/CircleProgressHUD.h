//
//  CircleProgressHUD.h
//  SDWebImagetest
//
//  Created by xuzhaocheng on 14-8-22.
//  Copyright (c) 2014年 louis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressHUD : UIView

@property (nonatomic) float progress;

- (id)initWithView:(UIView *)view;

- (void)fadeOutToRemoveWithDuration: (NSTimeInterval)duration completion: (void(^)())completion;
@end
