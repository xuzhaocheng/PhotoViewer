//
//  TableViewCell.h
//  PhotoViewer
//
//  Created by xuzhaocheng on 14-8-21.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCell;
@protocol TableViewCellDelegate <NSObject>

- (void)tableViewCell: (TableViewCell *)cell didClickImageView: (UIImageView *)imageView;

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, weak) id <TableViewCellDelegate> delegate;

@property (nonatomic, readonly, strong) NSArray *imageViews;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier images:(NSArray *)images;
- (void)setImages:(NSArray *)images;
@end
