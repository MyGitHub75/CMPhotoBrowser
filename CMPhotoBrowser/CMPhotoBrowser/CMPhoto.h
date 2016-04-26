//
//  CMPhoto.h
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/20.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMPhoto : NSObject
@property (nonatomic, copy)NSString *srcImageUrl;// 大图
@property (nonatomic, strong) UIImageView *placeholder;// 小图
@property (nonatomic, assign) BOOL firstShow; 
@property (nonatomic, assign) int index; // 索引
@end
