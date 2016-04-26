//
//  CMPhotoView.h
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/20.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMPhoto;

@interface CMPhotoView : UIScrollView <UIScrollViewDelegate>

/**
 *  图片模型
 */
@property (nonatomic,strong)CMPhoto *photo;

@end
