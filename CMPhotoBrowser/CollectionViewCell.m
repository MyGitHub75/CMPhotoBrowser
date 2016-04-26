//
//  CollectionViewCell.m
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/20.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    _imageViews = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    _imageViews.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageViews];
}
@end
