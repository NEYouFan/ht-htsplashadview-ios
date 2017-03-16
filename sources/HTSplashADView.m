//
//  HTSplashADView.m
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import "HTSplashADView.h"


@interface HTSplashADView ()

@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *countButton;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy) HTSplashFinishedBlock block;

@end

@implementation HTSplashADView

- (instancetype)initWithFrame:(CGRect)frame finished:(HTSplashFinishedBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        // 1.广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        _adView.image = [UIImage imageWithContentsOfFile:[[HTSplashADManager sharedInstance] getSplashDataFilePath]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAd)];
        [_adView addGestureRecognizer:tap];
        [self addSubview:_adView];

        // 2.跳过按钮
        if ([HTSplashADManager sharedInstance].getSplashData.showCountdown) {
            CGFloat btnW = 60;
            CGFloat btnH = 30;
            NSUInteger showtime = [[HTSplashADManager sharedInstance] getSplashData].countdownTime;
            _countButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 24, btnH, btnW, btnH)];
            [_countButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
            [_countButton setTitle:[NSString stringWithFormat:@"跳过 %lu", (unsigned long)showtime] forState:UIControlStateNormal];
            _countButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _countButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
            _countButton.layer.cornerRadius = 4;
            [self addSubview:_countButton];
        }
        
    }
    return self;
}


- (NSTimer *)countTimer{
    if (!_countTimer) {
        _countTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countdownTime) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (void)show
{
    if ([HTSplashADManager sharedInstance].getSplashData == nil) {
        [self dismiss:NO];
        return;
    }
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

// 定时器倒计时
- (void)startTimer
{
    _count =  [[HTSplashADManager sharedInstance] getSplashData].countdownTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}


- (void)countdownTime
{
    _count --;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%lu",(unsigned long)_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss:NO];
    }
}

- (void)gotoAd{
    if ([HTSplashADManager sharedInstance].getSplashData.linkUrl == nil) {
        return;
    }
    [self dismiss:YES];
}

// 移除广告页面
- (void)dismiss:(BOOL)gotoAd
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.block) {
            if (gotoAd) {
                self.block([[HTSplashADManager sharedInstance] getSplashData], YES);
            }else{
                self.block([[HTSplashADManager sharedInstance] getSplashData], NO);
            }
        }
    }];
    
}

@end
