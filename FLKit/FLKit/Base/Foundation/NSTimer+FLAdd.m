//
//  NSTimer+FLAdd.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSTimer+FLAdd.h"

@implementation NSTimer (FLAdd)

+ (void)timerSeletor:(NSTimer *)timer{
    if ([timer userInfo] != nil) {
        void(^Block)(NSTimer *timer) = [timer userInfo];
        Block(timer);
    }
}

// 每次定时器 会回调执行这个方法 “timerSeletor:” 并且传过去一个Block， 在定时器回调自己的时候，然后回调到调用者。
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti callback:(void(^)(NSTimer *timer))block repeats:(BOOL)yesOrNo
{
    return [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerSeletor:) userInfo:[block copy] repeats:yesOrNo];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti callback:(void (^)(NSTimer *))block repeats:(BOOL)yesOrNo{
    return [NSTimer timerWithTimeInterval:ti target:self selector:@selector(timerSeletor:) userInfo:[block copy] repeats:yesOrNo];
}

@end
