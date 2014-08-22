//
//  CircleProgressHUD.m
//  SDWebImagetest
//
//  Created by xuzhaocheng on 14-8-22.
//  Copyright (c) 2014年 louis. All rights reserved.
//

#import "CircleProgressHUD.h"

#define SIDE_LENGTH     30.f

@implementation CircleProgressHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.progress= 0;
    }
    return self;
}

- (id)initWithView: (UIView *)view
{
    CGRect frame = CGRectMake((view.bounds.size.width - SIDE_LENGTH) / 2, (view.bounds.size.height - SIDE_LENGTH) / 2, SIDE_LENGTH,SIDE_LENGTH);
    return [self initWithFrame:frame];
}

- (void)setProgress:(float)progress
{
    if (progress > 1) {
        _progress = 1;
    }
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath *background = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [[UIColor colorWithWhite:0.3 alpha:0.8] setFill];
    [background fill];
    [background addClip];
    
    UIBezierPath *circleBgPath = [UIBezierPath bezierPath];
    circleBgPath.lineWidth = 3.f;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (self.bounds.size.width - circleBgPath.lineWidth) / 2 - 3;
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = 2 * (float)M_PI + startAngle;
    [circleBgPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor colorWithWhite:0.1 alpha:0.8] setStroke];
    [circleBgPath stroke];
    
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    progressPath.lineWidth = circleBgPath.lineWidth;
    progressPath.lineCapStyle = kCGLineCapRound;

    endAngle = self.progress * 2 * (float)M_PI + startAngle;
    [progressPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor whiteColor] setStroke];
    [progressPath stroke];

}

- (void)fadeOutToRemoveWithDuration: (NSTimeInterval)duration completion: (void(^)())completion
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}


@end
