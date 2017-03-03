//
//  HTSplashData.m
//  HTSplashADView
//
//  Created by 陶泽宇 on 2017/2/24.
//  Copyright © 2017年 陶泽宇. All rights reserved.
//

#import "HTSplashData.h"

@implementation HTSplashData

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.linkUrl forKey:@"linkUrl"];
    [encoder encodeDouble:self.countdownTime forKey:@"countDownTime"];
    [encoder encodeDouble:self.expireTime forKey:@"expireTime"];
    [encoder encodeBool:self.showCountdown forKey:@"showCountDown"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        self.linkUrl = [decoder decodeObjectForKey:@"linkUrl"];
        self.showCountdown = [decoder decodeBoolForKey:@"showCountDown"];
        self.countdownTime = [decoder decodeDoubleForKey:@"countDownTime"];
        self.expireTime = [decoder decodeDoubleForKey:@"expireTime"];
    }
    return  self;
}


@end
