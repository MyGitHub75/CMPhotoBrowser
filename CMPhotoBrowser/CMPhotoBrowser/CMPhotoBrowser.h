//
//  CMPhotoBrowser.h
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/26.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPhotoBrowser : UIViewController

/**
 *  所有的图片对象(CMPhoto)
 */
@property (nonatomic, strong) NSArray *photos;

/**
 *  当前展示的图片索引
 */
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

/**
 *  显示
 */
- (void)show;

@end
