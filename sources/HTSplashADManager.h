//
//  HTSplashADManager.h
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTSplashData.h"

static NSString *const splashKey = @"HTSplashKey";

@interface HTSplashADManager : NSObject

+ (instancetype)sharedInstance;

/**
 更新广告资源，更新成功之后会将先前的资源覆盖

 @param data 详见HTSplashData
 */
- (void)updateSplashData:(HTSplashData *)data;

/**
 删除已有的广告资源
 */
- (void)deleteSplashData;

/**
 获取当前广告图片文件路径
 */
- (NSString *)getSplashDataFilePath;


/**
 获取当前广告信息
 */
- (HTSplashData *)getSplashData;

@end
