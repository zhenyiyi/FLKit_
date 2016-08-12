//
//  RetainCycleTimer.m
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "RetainCycleTimer.h"
#import "FLWeakProxy.h"
#import "YYWeakProxy.h"



@interface RetainCycleTimer ()

@property (nonatomic, strong)NSTimer *myTimer;

@end


//typedef id(^WeakReference)(void);
//
//WeakReference makeWeakReference(id object){
//    __weak id weakRef = object;
//    return ^{
//        return  weakRef;
//    };
//}

@implementation RetainCycleTimer

- (void)test{
    
    
 
    
    
//    _myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(execute:) userInfo:nil repeats:YES];
//    [_myTimer fire];
//    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
//    NSTimer *myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(execute:) userInfo:nil repeats:YES];
//    [myTimer fire];
//    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
    
//    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[[YYWeakProxy alloc] initWithTarget:self] selector:@selector(execute:) userInfo:nil repeats:YES];
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[[FLWeakProxy alloc] initWithTarget:self] selector:@selector(execute:) userInfo:nil repeats:YES];
}

- (void)execute:(NSTimer *)timer{
    NSLog(@"AA");
}

-(void)dealloc{
    NSLog(@"dealloc");
    
    [_myTimer invalidate];
    _myTimer = nil;
}



@end
