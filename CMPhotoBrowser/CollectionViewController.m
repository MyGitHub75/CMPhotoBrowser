//
//  CollectionViewController.m
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/20.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "CMPhotoBrowser.h"
#import "CMPhoto.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()
@property (nonatomic,strong)NSMutableArray *smallUrlArray;
@end

@implementation CollectionViewController

-(NSMutableArray *)smallUrlArray{
    if (_smallUrlArray == nil) {
        _smallUrlArray= [NSMutableArray array];
    }
    return _smallUrlArray;
}
static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing = 10;

    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *name = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [name setTitle:@"清除缓存" forState:UIControlStateNormal];
//    [name setImage:<#(UIImage *)#> forState:UIControlStateNormal];
    name.frame = CGRectMake(0, 400, 100, 50);
//    <#name#>.titleLabel.font = [UIFont systemFontOfSize:<#float#>];
    [name addTarget:self action:@selector(clearAllcaches) forControlEvents:UIControlEventTouchUpInside];
    name.backgroundColor = [UIColor grayColor];
    [self.collectionView addSubview:name];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2gb9f9j20da0gm40t.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2hj86bj20gk0gk414.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2izm5gj20dt0gltbe.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2k7k1hj20er0glabv.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2leqhxj20et0gkdht.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2mdjq0j20d60ghtaz.jpg",
                       @"http://ww1.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2o49cwj20d80gj769.jpg",
                       @"http://ww3.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2qjocsg205706ikjl.gif",
                       @"http://ww2.sinaimg.cn/thumbnail/6aaeb4b8gw1f32b2ymkhxg206i0847wi.gif",
                       @"https://b-ssl.duitang.com/uploads/item/201112/15/20111215183154_CeRuv.jpg"];
    [self.smallUrlArray addObjectsFromArray:arr];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView reloadData];
    
}

-(void)clearAllcaches{
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [self.collectionView reloadData];
    }];
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return _smallUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
 
    [cell.imageViews sd_setImageWithURL:[NSURL URLWithString:_smallUrlArray[indexPath.item]]];
    cell.imageViews.tag = indexPath.row + 100;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *bigUrlArray = @[@"http://ww2.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2gb9f9j20da0gm40t.jpg",
                             @"http://ww2.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2hj86bj20gk0gk414.jpg",
                             @"http://ww2.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2izm5gj20dt0gltbe.jpg",
                             @"http://ww4.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2k7k1hj20er0glabv.jpg",
                             @"http://ww2.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2leqhxj20et0gkdht.jpg",
                             @"http://ww4.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2mdjq0j20d60ghtaz.jpg",
                             @"http://ww1.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2o49cwj20d80gj769.jpg",
                             @"http://ww3.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2qjocsg205706ikjl.gif",
                             @"http://ww2.sinaimg.cn/bmiddle/6aaeb4b8gw1f32b2ymkhxg206i0847wi.gif",
                             @"https://b-ssl.duitang.com/uploads/item/201112/15/20111215183154_CeRuv.thumb.700_0.jpg"];
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < [_smallUrlArray count];i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        
        CMPhoto *browseItem = [[CMPhoto alloc]init];
        browseItem.srcImageUrl = bigUrlArray[i];// 大图url地址
        browseItem.placeholder = imageView;// 小图
        
        [browseItemArray addObject:browseItem];
    }
    CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CMPhotoBrowser *bvc = [[CMPhotoBrowser alloc]init];
    bvc.currentPhotoIndex = cell.imageViews.tag - 100;
    bvc.photos = browseItemArray;
    [bvc show];
}


@end
