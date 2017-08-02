//
//  CMPhotoBrowser.m
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/26.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import "CMPhotoBrowser.h"
#import "CMPhotoBrowerCell.h"
#import "CMPhoto.h"
#import "CMActionSheet.h"
#import "CMPhotoProgressHUD.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define CMBrowseSpace 30
static NSString * const CMReuseIdentifier = @"CMPhotoBrowerCell";
@interface CMPhotoBrowser ()<UICollectionViewDelegate, UICollectionViewDataSource, CMActionSheetDelegate>

@end

@implementation CMPhotoBrowser{
    
    UICollectionView *_collectionView;
    
    /**
     *  要保存的图片控件
     */
    UIImageView *_saveImageView;
    
    /**
     * 提示层
     */
    CMPhotoProgressHUD *_hud;
    
    UIPageControl *_padgeControl;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [self setupAddObserve];
    
}

//监听通知
-(void)setupAddObserve{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissVC) name:CMPhotoViewDismissViewNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(longTapWithInfo:) name:CMPhotoViewLongTapNotification object:nil];
}

-(void)setupUI{
    //self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 每行的间距
    flowLayout.minimumLineSpacing = 0;
    
    CGRect rect = self.view.bounds;
    rect.size.width = self.view.bounds.size.width + CMBrowseSpace;
    _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerClass:[CMPhotoBrowerCell class] forCellWithReuseIdentifier:CMReuseIdentifier];
    _collectionView.contentOffset = CGPointMake(_currentPhotoIndex * (screenWidth + CMBrowseSpace), 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView reloadData];
    
    [self setUpPageControl];
    
    _hud = [[CMPhotoProgressHUD alloc]init];
    [self.view addSubview:_hud];
}

//设置UIPageControl显示照片数量
- (void)setUpPageControl
{
    _padgeControl = [[UIPageControl alloc] init];
    _padgeControl.numberOfPages = self.photos.count;
    _padgeControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _padgeControl.pageIndicatorTintColor = [UIColor grayColor];
    _padgeControl.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height-20);
    _padgeControl.currentPage = _currentPhotoIndex;
    _padgeControl.hidden = self.photos.count==1||self.isHiddenPadgeControl==1;
    [self.view addSubview:_padgeControl];
}

/// 从写photos set方法
-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    for (int i = 0; i<_photos.count; i++) {
        CMPhoto *pt = _photos[i];
        pt.firstShow = i == _currentPhotoIndex;
    }
}

/// 从写currentPhotoIndex set方法
-(void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        CMPhoto *pt = _photos[i];
        pt.firstShow = i == _currentPhotoIndex;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    //设置pageView的当前页
    _padgeControl.currentPage = page;
}

/// 展示试图动画
-(void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    window.backgroundColor = [UIColor clearColor];
    [window.rootViewController addChildViewController:self];
    
    
}

-(void)setHiddenPadgeControl:(BOOL)hiddenPadgeControl{
    _hiddenPadgeControl = hiddenPadgeControl;
}

#pragma mark - 屏幕点击触发操作

/// 点击屏幕操作
-(void)dismissVC{
    [_padgeControl removeFromSuperview];
    
    [UIView animateWithDuration:.25 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        _collectionView.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

/// 长按屏幕设置操作
-(void)longTapWithInfo:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    UIImageView *saveImgeView = [info objectForKey:@"currentImageView"];
    //将图片空间复制全局图片控件
    _saveImageView = saveImgeView;
    
    //提示层
    CMActionSheet *alert = [[CMActionSheet alloc]initWithTitle:nil buttonTitles:@[@"保存图片", @"复制图片链接"] redButtonIndex:-1 delegate:self];
    [alert show];
}

#pragma mark - CMActionSheetDelegate
-(void)actionSheet:(CMActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    // 保存图片
    if(buttonIndex == 0){
        UIImageWriteToSavedPhotosAlbum(_saveImageView.image , self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    // 复制图片地址
    if(buttonIndex == 1){
        CMPhoto *photo = self.photos[_currentPhotoIndex];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = photo.srcImageUrl;
        [_hud showMessageWithText:@"复制图片地址成功"];
    }
}

/// 保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *text = nil;
    if(error)
    {
        text = @"保存图片失败";
    }
    else
    {
        text = @"保存图片成功";
    }
    [_hud showMessageWithText:text];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CMReuseIdentifier forIndexPath:indexPath];
    
    CMPhoto *photo = self.photos[indexPath.item];
    cell.photo = photo;
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth + CMBrowseSpace, screenHeight);
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CMPhotoViewDismissViewNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CMPhotoViewLongTapNotification object:nil];

}
@end
