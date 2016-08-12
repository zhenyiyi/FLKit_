//
//  NSObject+FLAddForKVO.m
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSObject+FLAddForKVO.h"
#import <objc/runtime.h>


/**
 *  使用KVO的注意事项 : observer 不能被释放。否则回调的时候会crash。
 */
static const void * kObserverKey = "ObserverKey";

typedef  void (^ObserverBlock)(__weak id obj, id oldVal, id newVal);

@interface FLObserverTarget : NSObject

@property (nonatomic, copy) ObserverBlock block;

- (id)initTargetWithblock:(ObserverBlock)block;

@end

@implementation FLObserverTarget

- (id)initTargetWithblock:(ObserverBlock)block{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}


/**
 *  NSKeyValueChangeKindKey：这是change中永远会包含的键值对，它的值时一个NSNumber对象，具体的数值有NSKeyValueChangeSetting、NSKeyValueChangeInsertion、NSKeyValueChangeRemoval、NSKeyValueChangeReplacement这几个，其中后三个是针对于to-many relationship的
 
 文／卖萌凉（简书作者）
 原文链接：http://www.jianshu.com/p/d104daf7a062
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (_block == nil) return;
    BOOL prior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (prior) return;  // 只改变之前 return;
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if ([oldVal isKindOfClass:[NSNull class]]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if ([newVal isKindOfClass:[NSNull class]]) newVal = nil;
    _block(object, oldVal, newVal);
}

@end

@implementation NSObject (FLAddForKVO)

/**
 *  ‘使用者’调用一次这个，如果有值改变，那么我就需要回调‘使用者’，可能观察的 keyPath 是一样的。那么保存的时候就不能够使用map关联key， 应当使用key关联数组。
 */
- (void)addObserverBlockforKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block{
    if (keyPath == nil | block == nil) return;
    NSMutableDictionary *targets = [self __allObserverObject];
    FLObserverTarget *target = [[FLObserverTarget alloc]initTargetWithblock:block];
    NSMutableArray *keyPathArr = targets[keyPath];
    if (keyPathArr == nil) {
        keyPathArr = [NSMutableArray array];
        targets[keyPath] = keyPathArr;
    }
    [keyPathArr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (NSMutableDictionary *)__allObserverObject{
     NSMutableDictionary * targets =  objc_getAssociatedObject(self, kObserverKey);
    if (targets == nil) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, kObserverKey, targets, OBJC_ASSOCIATION_RETAIN);
    }
    return targets;
}



- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath{
    if (keyPath == nil) return;
    NSMutableDictionary *targets = [self __allObserverObject];
    NSMutableArray *keyPathArr = targets[keyPath];
    [keyPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [targets removeObjectForKey:keyPath];
}

- (void)removerObserverBlocks{
    NSMutableDictionary *targets = [self __allObserverObject];
    [targets enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *array, BOOL * _Nonnull stop) {
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [targets removeAllObjects];
}



@end
