//
//  CMLoadingView.m
//  CMPhotoBrower
//
//  Created by chuanmao.Chen on 16/4/22.
//  Copyright © 2016年 chuanmao.Chen. All rights reserved.
//

#import "CMLoadingView.h"

@implementation CMLoadingView{
    NSTimer *_time;
    CGFloat _angle;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-30)/2, ([UIScreen mainScreen].bounds.size.height-30)/2, 30, 30);
        self.hidden = NO;
        
    }
    return self;
}

-(void)makeRotation{
    
    _angle += 6.0f;
    self.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    if (_angle > 360.f) {
        _angle = 0;
    }
}
-(void)startAnimation{
    self.hidden = NO;
    _time = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(makeRotation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_time forMode:NSRunLoopCommonModes];
}

-(void)stopAnimation{
    [_time invalidate];
    self.hidden = YES;

    
}


-(void)drawRect:(CGRect)rect{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"CMLoadingPic.bundle" withExtension:nil];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage *image = [UIImage imageNamed:@"browseLoading"
                                      inBundle:imageBundle
                 compatibleWithTraitCollection:nil];
    
    [image drawInRect:CGRectMake(0,0,rect.size.width,rect.size.height)];
}
@end
