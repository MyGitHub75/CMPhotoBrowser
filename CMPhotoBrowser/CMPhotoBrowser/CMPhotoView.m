//
//  CMPhotoView.m
//  CMPhotoBrower
//
//  Created by pro on 16/4/20.
//  Copyright © 2016年 CM. All rights reserved.
//
#define screenSize [UIScreen mainScreen].bounds.size
#import "CMPhotoView.h"
#import "CMPhoto.h"
#import "UIImageView+WebCache.h"
#import "CMLoadingView.h"
#import "CMPhotoProgressHUD.h"
@interface CMPhotoView ()
/**
 *  展示图片控件
 */
@property(nonatomic, strong) UIImageView *imageView;

/**
 *  是否双触
 */
@property(nonatomic, assign)BOOL isDoubleTap;
@property(nonatomic, weak)UITapGestureRecognizer *doubleTap;
@property(nonatomic, weak)UITapGestureRecognizer *singleTap;

@end

@implementation CMPhotoView{
    CMLoadingView *_loadView;
    CMPhotoProgressHUD *_hud;
}

//构造函数
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces=NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //添加单触操作
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick)];
        _singleTap = singleTap;
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1.0;
        [self addGestureRecognizer:singleTap];
        //添加双触操作
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap = doubleTap;
        doubleTap.numberOfTapsRequired = 2.0;
        [self addGestureRecognizer:doubleTap];
        //防止双击操作被拦截；在这里为了避免为加载完图片时双击造成的bug（加载完图片会缩小）
        [_singleTap requireGestureRecognizerToFail:_doubleTap];
        
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapWithLongGuesture:)];
        [self addGestureRecognizer:longTap];
        
        _loadView = [[CMLoadingView alloc]init];
        [self addSubview:_loadView];
        
        _hud = [[CMPhotoProgressHUD alloc]init];
        [self addSubview:_hud];
    }
    return self;
}

-(void)dealloc{
    //清楚图片在存储里的缓存
    [[SDImageCache sharedImageCache]clearMemory];
}
//
-(void)setPhoto:(CMPhoto *)photo{
    _photo = photo;
    //重置scrollView属性，防止重用bug
 
    [_loadView stopAnimation];
    self.maximumZoomScale = 1;
    if (self.zoomScale != 1) {
        self.zoomScale = 1.0f;
        
    }
 
    [self showImage];
}

#pragma mark -展示每一页的图片
-(void)showImage{
    
    // 是否有缓存图片
    if([[SDImageCache sharedImageCache]diskImageExistsWithKey:_photo.srcImageUrl])
    {
        // 取消当前请求防止复用问题
        [_imageView sd_cancelCurrentImageLoad];
        
   
        //是否是起始浏览的照片
        if (_photo.firstShow) {
            _photo.firstShow = NO;
            //设置占位图片尺寸
            _imageView.frame = [_photo.placeholder.superview convertRect:_photo.placeholder.frame toView:nil];
   
            //调整图片位置 并设置动画效果
            [self adjustFrameWithAnimation:0.35];
        }else{
            [self adjustFrameWithAnimation:0];
        }
        
        return;
    }
    
    //没有缓存说明是第一次打开图片， 设置展位图片位置为中间
    CGFloat placeholderWitdh = _photo.placeholder.bounds.size.width;
    CGFloat placeholderHeight = _photo.placeholder.bounds.size.height;
    CGFloat placeholderY = (screenSize.height-placeholderWitdh)*0.5;
    CGFloat placeholderX = (screenSize.width- placeholderWitdh)*0.5;
    _imageView.frame = CGRectMake(placeholderX, placeholderY, placeholderWitdh, placeholderHeight);
    
    [_loadView startAnimation];
    
    if (_photo.firstShow) {
        _photo.firstShow = NO;
    }
    [self adjustFrameWithAnimation:0.35];
    
}

#pragma mark - 设置图片并设置动画
-(void)adjustFrameWithAnimation:(NSTimeInterval)index{
    
    __weak CMLoadingView *load = _loadView;

    [_imageView sd_setImageWithURL:[NSURL URLWithString:_photo.srcImageUrl] placeholderImage:_photo.placeholder.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [load stopAnimation];
        if (error) {
            [_hud showMessageWithText:error.localizedDescription];
            
            return ;
        }
        [UIView animateWithDuration:index animations:^{

            [self setImagePosition:image];
 
        }];
        
    }];
    
}

#pragma mark - 调整图片位置
- (void)setImagePosition:(UIImage *)image {
    CGSize size = [self imageSizeWithScreen:image];
    CGFloat x = (screenSize.width - size.width) * 0.5;
    CGFloat y = (screenSize.height - size.height) * 0.5;
    _imageView.frame = CGRectMake(x, y, size.width, size.height);
}

//适应屏幕尺寸
- (CGSize)imageSizeWithScreen:(UIImage *)image {
    CGSize size = screenSize;
    size.height = image.size.height * size.width / image.size.width;
    self.maximumZoomScale = 2.0;
    self.minimumZoomScale = 1.0;
    return size;
}



//- (void)reset
//{
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//   
//    _imageView.image = img;
//    _imageView.contentMode = UIViewContentModeScaleToFill;
//}
// 点击事件取消图片浏览
-(void)singleTapClick{
    _isDoubleTap = NO;
//
    [_loadView stopAnimation];
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.25 animations:^{
        self.contentOffset = CGPointZero;
        CGRect rect = [_photo.placeholder.superview convertRect:_photo.placeholder.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        _imageView.frame = rect;
        
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 发出通知去 dissmissViewController
        [[NSNotificationCenter defaultCenter]postNotificationName:@"touchit" object:self];
    });
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _isDoubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
//    if(self.zoomScale >= self.minimumZoomScale)
//    {
//        [self setZoomScale:self.minimumZoomScale animated:YES];
//    }
//    else
//    {
//        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
//        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
//        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
//    }
}

-(void)longTapWithLongGuesture:(UILongPressGestureRecognizer *)longGuesture{
    NSDictionary *picDic = [NSDictionary dictionaryWithObject:_imageView forKey:@"currentImageView"];
    if(longGuesture.state == UIGestureRecognizerStateBegan){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"longTap" object:self userInfo:picDic];
    }
}


#pragma mark - UIScollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = _imageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < CGRectGetWidth(self.frame)) {
        rect.origin.x = floorf((CGRectGetWidth(self.frame) - rect.size.width) / 2.0);
    }
    if (rect.size.height < CGRectGetHeight(self.frame)) {
        rect.origin.y = floorf((CGRectGetHeight(self.frame) - rect.size.height) / 2.0);
    }
    _imageView.frame = rect;
}


//懒加载图片控件
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:_photo.placeholder.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


@end
