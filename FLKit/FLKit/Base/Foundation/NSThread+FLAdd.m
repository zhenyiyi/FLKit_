//
//  NSThread+FLAdd.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSThread+FLAdd.h"
#import <CoreFoundation/CoreFoundation.h>


#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif


static NSString * const FLThreadAutoreleasePoolKey = @"FLNSThreadAutoreleasePoolKey";
static NSString * const FLThreadAutoreleasePoolStackKey = @"FLNSThreadAutoreleasePoolStackKey";

// CFArrayCallBacks 添加对象的会 回调。
static  const void * PoolStackRetainCallBack( CFAllocatorRef allocator, const void *value ){
    return value;
}
// CFArrayCallBacks  释放对象的会 回调。
static void PoolStackReleaseCallBack( CFAllocatorRef allocator, const void *value ){
    CFRelease((CFTypeRef)value);
}

static inline void FLAutoReleasePoolPush(){
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    
    NSMutableArray *poolStack = dic[FLThreadAutoreleasePoolStackKey];
    if (! poolStack) {
        /*
         do not retain pool on push,
         but release on pop to avoid memory analyze warning
         */
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)(CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks));
        dic[FLThreadAutoreleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  //< create
    [poolStack addObject:pool]; //push
}

static inline void FLAutoReleasePoolPop(){
    
    NSMutableDictionary *dic = [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[FLThreadAutoreleasePoolStackKey];
    [poolStack removeLastObject]; //pop
}

// 回调函数，闭包。
static void AutoReleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    switch (activity) {
        case kCFRunLoopEntry:{
            FLAutoReleasePoolPush(); // 进入RunLoop的时候 添加自动释放池
        }
            break;
        case kCFRunLoopBeforeWaiting:{
            FLAutoReleasePoolPop();   // RunLoop 进行休息前，释放旧的释放池，然后添加自动释放池
            FLAutoReleasePoolPush();
        }
            break;
        case kCFRunLoopExit:{
            FLAutoReleasePoolPop();  //RunLoop退出的时候，释放自动 释放池
        }
            break;
        default:
            break;
    }
    
}


static void SetupAutoreleasepool(){
    
    // create observer, activities == kCFRunLoopEntry
    CFRunLoopObserverRef pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                                kCFRunLoopEntry,
                                                                YES,  // repeat
                                                                -0x7FFFFFFF, // before other observers
                                                                AutoReleasePoolObserverCallBack, nil);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), pushObserver, kCFRunLoopCommonModes);
    
    CFRunLoopObserverRef popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                               kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                                               YES,   // repeat
                                                               0x7FFFFFFF, // after other observers
                                                               AutoReleasePoolObserverCallBack, nil);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), popObserver, kCFRunLoopCommonModes);
    
}

/*
 
 <CFRunLoop>
 
 {  wakeup port = 0x4f07,
    current mode = (none),
    common modes = <CFBasicHash>{type = mutable set, count = 1,
    entries =>
	2 : <CFString>{contents = "kCFRunLoopDefaultMode"}
 }
 ,
 common mode items = <CFBasicHash>{type = mutable set, count = 2,
    entries =>
	0 : <CFRunLoopObserver>{activities = 0x1, repeats = Yes, order = -2147483647, callout = AutoReleasePoolObserverCallBack , context = <CFRunLoopObserver>}
	1 : <CFRunLoopObserver>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = AutoReleasePoolObserverCallBack , context = <CFRunLoopObserver>}
 }
 ,
 modes = <CFBasicHash>{type = mutable set, count = 1,
    entries =>
	2 : <CFRunLoopMode>{name = kCFRunLoopDefaultMode, port set = 0x4e03, timer port = 0x4f03,
	sources0 = (null),
	sources1 = (null),
	observers = <CFArray >{type = mutable-small, count = 2, values = (
	0 : <CFRunLoopObserver>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, callout = AutoReleasePoolObserverCallBack, context = <CFRunLoopObserver>}
	1 : <CFRunLoopObserver>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = AutoReleasePoolObserverCallBack, context = <CFRunLoopObserver>}
 )},
	timers = (null),
 }

 
 
 */

@implementation NSThread (FLAdd)


+(void)addAutoreleasePoolAtCurrentRunLoop{
    
    if ([NSThread isMainThread]) return; // The main thread already has autorelease pool.
    
    NSThread *thread = [NSThread currentThread];
    if (!thread) return;
    
    if (thread.threadDictionary[FLThreadAutoreleasePoolKey] != nil) return; // already added
    
    SetupAutoreleasepool();
    
    // mark the state ，ignore invoke again.
    thread.threadDictionary[FLThreadAutoreleasePoolKey] = FLThreadAutoreleasePoolKey;
    
    
}

/**
 *  thread.threadDictionary :
 *
 *  The thread object's dictionary. (read-only)
    You can use the returned dictionary to store thread-specific data.
    The thread dictionary is not used during any manipulations of the NSThread object—it is simply a place where you can store any interesting data.
    For example, Foundation uses it to store the thread’s default NSConnection and NSAssertionHandler instances. You may define your own keys for the dictionary.
   在操作线程对象的时候不能够使用字典， 只是一个地方,你可以存储任何有趣的数据。
 */


@end
