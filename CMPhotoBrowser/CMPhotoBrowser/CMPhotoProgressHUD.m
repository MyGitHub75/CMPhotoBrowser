//
//  CMPhotoProgressHUD.m
//  CMPhotoBrower
//
//  Created by pro on 16/4/25.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CMPhotoProgressHUD.h"

@interface CMPhotoProgressHUD ()

@property (nonatomic,strong)UILabel *remindLabel;
@property (nonatomic,strong)UIView *maskView;
@end

@implementation CMPhotoProgressHUD

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createRemindView];
    }
    return self;
}

- (void)createRemindView
{
    self.alpha = 0;
    
    _maskView = [[UIView alloc]init];
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5f;
    _maskView.layer.cornerRadius = 5.0f;
    _maskView.layer.masksToBounds = YES;
    [self addSubview:_maskView];
    
    _remindLabel = [[UILabel alloc]init];
    _remindLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _remindLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _remindLabel.textColor = [UIColor whiteColor];
    [self addSubview:_remindLabel];
}

- (void)showMessageWithText:(NSString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_remindLabel.font} context:nil];
    CGSize size = textRect.size;
    
    _maskView.frame = [self setCenteFramerWithSize:CGSizeMake(size.width + 20, size.height + 40)];
     ;
    _remindLabel.frame = [self setCenteFramerWithSize:size];
    _remindLabel.text = text;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:1.0];
}


- (void)hide
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        
    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}


- (CGRect)setCenteFramerWithSize:(CGSize)size
{
    CGRect rect = CGRectMake((CGRectGetWidth(self.frame) - size.width) / 2, (CGRectGetHeight(self.frame) - size.height) / 2, size.width, size.height);
    return rect;
}
@end
