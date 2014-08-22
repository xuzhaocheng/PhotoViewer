//
//  TableViewCell.m
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "TableViewCell.h"


@interface TableViewCell ()

@property (nonatomic, strong, readwrite) NSArray *imageViews;

@end

@implementation TableViewCell

- (NSInteger)numberOfImagesInRow {    return 3;   }
- (CGFloat)imageSideLenght {    return 40.f;   }
- (CGFloat)horizontalPadding
{
    return (self.bounds.size.width - [self numberOfImagesInRow] * [self imageSideLenght]) / ([self numberOfImagesInRow] + 1);
}

- (CGFloat)verticalPadding { return 10.f; }

- (void)setImages:(NSArray *)images
{
    
    if (!images || images.count != self.imageViews.count) {
        return;
    }
    
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        ((UIImageView *)self.imageViews[idx]).image = image;
    }];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier images:(NSArray *)images
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake([self horizontalPadding] + ([self imageSideLenght] + [self horizontalPadding]) * (idx % [self numberOfImagesInRow]),
                                                 [self verticalPadding] + ([self imageSideLenght] + [self verticalPadding]) * (idx / [self numberOfImagesInRow]),
                                                 [self imageSideLenght], [self imageSideLenght])];
            imageView.image = image;
            imageView.tag = idx + 1;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            tapGesture.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tapGesture];
            
            [self addSubview:imageView];
            [tmp addObject:imageView];
        }];
        self.imageViews = tmp;
        
        CGRect frame = self.frame;
        frame.size.height = [self verticalPadding] + ceil(images.count / (float)[self numberOfImagesInRow]) * ([self verticalPadding] + [self imageSideLenght]);
        self.frame = frame;
        
    }
    return self;
}

- (void)handleSingleTap: (UITapGestureRecognizer *)tapGesture
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didClickImageView:)]) {
        [_delegate tableViewCell:self didClickImageView:(UIImageView *)tapGesture.view];
    }
}

@end
