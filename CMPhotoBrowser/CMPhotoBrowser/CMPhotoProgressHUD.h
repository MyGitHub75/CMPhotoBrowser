//
//  CMPhotoProgressHUD.h
//  CMPhotoBrower
//
//  Created by pro on 16/4/25.
//  Copyright © 2016年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMPhotoProgressHUD : UIView
/**
 *  展示信息
 *
 *  @param text 要显示的文字
 */
- (void)showMessageWithText:(NSString *)text;
/**
 *  隐藏
 */
- (void)hide;
@end
