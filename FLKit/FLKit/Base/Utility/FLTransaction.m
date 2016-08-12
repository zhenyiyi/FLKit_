//
//  FLTransaction.m
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "FLTransaction.h"

@interface FLTransaction ()

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL sel;
@end

static NSMutableSet *targetSet = nil;


static void RunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    if (targetSet.count == 0) return;
    NSSet *currentSet = targetSet;
    targetSet = [NSMutableSet new];

    [currentSet enumerateObjectsUsingBlock:^(FLTransaction  * _Nonnull  obj, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [obj.target performSelector:obj.sel];
#pragma clang diagnostic pop
    }];
}

static void SetUpRunLoopObserver(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        targetSet = [[NSMutableSet alloc] init];
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                                kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                                                true, 0xFFFFFF, RunLoopObserverCallBack, nil);
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation FLTransaction

+ (FLTransaction *)transactionWithTarget:(id )target selector:(SEL)selector{
    if (target == nil || selector == nil) return nil;
    FLTransaction *tracsaction = [FLTransaction new];
    tracsaction.target = target;
    tracsaction.sel = selector;
    SetUpRunLoopObserver();
    return tracsaction;
}

- (void)commit{
    [targetSet addObject:self];
}

/**
 
 *
 *  @return <#return value description#>
 */
- (NSUInteger)hash{
    NSUInteger v1 = (NSUInteger)((void *) _sel);
    NSUInteger v2 = (NSUInteger)_target;
    return v1 ^ v2;
}

- (BOOL)isEqual:(id)object{
    if (self == object) return YES;
    if (![object isMemberOfClass:[self class]]) return NO;
    FLTransaction *trancsaction = object;
    return  trancsaction.target == self.target && trancsaction.sel == self.sel;
}
@end
