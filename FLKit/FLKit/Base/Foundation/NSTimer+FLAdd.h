//
//  NSTimer+FLAdd.h
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (FLAdd)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti callback:(void(^)(NSTimer *timer))block repeats:(BOOL)yesOrNo;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti callback:(void(^)(NSTimer *timer))block repeats:(BOOL)yesOrNo;

@end
