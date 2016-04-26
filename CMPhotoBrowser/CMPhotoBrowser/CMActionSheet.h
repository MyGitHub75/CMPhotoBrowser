//
//  CMActionSheet.h
//  Living
//
//  Created by pro on 15/12/17.
//  Copyright (c) 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMActionSheet;

@protocol CMActionSheetDelegate <NSObject>

@optional

/**
 *  点击了 buttonIndex处 的按钮
 */
- (void)actionSheet:(CMActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CMActionSheet : UIView

/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param redButtonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)titles
                redButtonIndex:(NSInteger)buttonIndex
                      delegate:(id<CMActionSheetDelegate>)delegate;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param redButtonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     delegate:(id<CMActionSheetDelegate>)delegate;

/**
 *  显示 ActionSheet
 */
- (void)show;

@end
