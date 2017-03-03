//
//  HTSplashADManager.m
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import "HTSplashADManager.h"
#import <UIKit/UIKit.h>

@interface HTSplashADManager ()

@property (nonatomic, strong) HTSplashData * currentSplashData;

@end

@implementation HTSplashADManager

+ (instancetype)sharedInstance {
    static HTSplashADManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HTSplashADManager alloc] init];
    });
    
    return sharedInstance;
}

- (HTSplashData *)currentSplashData{
    if (!_currentSplashData) {
         NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:splashKey];
        _currentSplashData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _currentSplashData;
}

/**
 更新广告资源，更新成功之后会将先前的资源覆盖
 */
- (void)updateSplashData:(HTSplashData *)splashData{
    NSString *imageName = [self splashImageName:splashData];
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        [self downloadSplash:splashData];
    }else{
        _currentSplashData = splashData;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:splashData];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:splashKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 删除已有的广告资源
 */
- (void)deleteSplashData{
    [self deleteOldImage];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:splashKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  下载新图片
 */
- (void)downloadSplash:(HTSplashData *)splashData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:splashData.imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *imageName = [self splashImageName:splashData];//保存文件的名称

        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的路径
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"广告图片保存成功");
            NSString *oldImageName = [self splashImageName:_currentSplashData];
            NSString *newImageName = [self splashImageName:splashData];
            if (![oldImageName isEqualToString:newImageName]) {
                [self deleteOldImage];
            }
            _currentSplashData = splashData;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:splashData];
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:splashKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            NSLog(@"广告图片保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage{
    NSString *imageName = [self splashImageName:self.currentSplashData];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}


/**
 检查广告资源是否过期
 */
- (BOOL)isSplashExpired{
    if (!self.currentSplashData) {
        return NO;
    }
    NSTimeInterval expire = self.currentSplashData.expireTime;
    NSTimeInterval current = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000;
    if (current >= expire) {
        //如果过期，删除广告资源信息
        [self deleteSplashData];
        return YES;
    }
    return NO;
}
/**
 获取广告图片名字
 */
- (NSString *)splashImageName:(HTSplashData *)splashData{
    NSString *imageUrl = splashData.imageUrl;
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    return imageName;
}


/**
 *  获取当前广告图片文件路径
 */
- (NSString *)getSplashDataFilePath{
    if ([self isSplashExpired]) {
        return nil;
    }
    NSString *imageName = [self splashImageName:self.currentSplashData];
    return [self getFilePathWithImageName:imageName];
}


/**
 获取当前广告信息
 */
- (HTSplashData *)getSplashData{
    if ([self isSplashExpired]) {
        return nil;
    }
    return self.currentSplashData;
}


@end
