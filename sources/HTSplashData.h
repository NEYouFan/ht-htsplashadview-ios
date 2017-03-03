//
//  HTSplashData.h
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTSplashData : NSObject

/**
 广告图片的url
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 广告跳转链接等url，如果为空，说明没有跳转链接，则点击广告页时无效，广告结束时走原先的页面跳转流程到app首页
 */
@property (nonatomic, copy) NSString *linkUrl;

/**
 广告倒计时时间
 */
@property (nonatomic, assign) NSTimeInterval countdownTime;

/**
 广告过期时间，如果广告过期，会自动被本地缓存删除
 */
@property (nonatomic, assign) NSTimeInterval expireTime;

/**
 是否显示倒计时button
 */
@property (nonatomic, assign) BOOL showCountdown;


@end
