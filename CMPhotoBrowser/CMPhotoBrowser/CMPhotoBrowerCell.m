//
//  CMPhotoBrowerCell.m
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/20.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import "CMPhotoBrowerCell.h"
#import "CMPhotoView.h"
#import "CMPhoto.h"



@interface CMPhotoBrowerCell()
@property(nonatomic, strong)CMPhotoView *photoView;
@end

@implementation CMPhotoBrowerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.photoView];
    }
    return self;
}

//设置数据
-(void)setPhoto:(CMPhoto *)photo{
    _photo = photo;
    _photoView.photo = photo;
     
}

//懒加载
-(CMPhotoView *)photoView{
    if (_photoView == nil) {
        _photoView = [[CMPhotoView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _photoView;
}
@end
