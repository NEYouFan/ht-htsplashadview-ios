//
//  HTSplashADView.h
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSplashADManager.h"


/**
 广告页面展示结束之后的回调，用户自行根据信息决定下一步动作
 
 @param splashData 详见HTSplashData
 @param gotoAd 是否需要跳转到广告link的页面
 */
typedef void (^HTSplashFinishedBlock)(HTSplashData *splashData, BOOL gotoAd);


@interface HTSplashADView : UIView


/**
 广告展示页面初始化，需传入HTSplashFinishedBlock 自定义广告页面展示结束之后的动作

 @param frame frame
 @param block HTSplashFinishedBlock
 */
- (instancetype)initWithFrame:(CGRect)frame finished:(HTSplashFinishedBlock)block;


/**
 展示广告页
 */
- (void)show;

@end
