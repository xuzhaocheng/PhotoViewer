//
//  ImageZoomPresentAnimation.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageZoomPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>
- (id)initWithReferenceImageView: (UIImageView *)refercenImageView;
@end
