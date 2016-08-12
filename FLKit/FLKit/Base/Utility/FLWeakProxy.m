//
//  FLWeakProxy.m
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "FLWeakProxy.h"


@interface FLWeakProxy ()

@end

@implementation FLWeakProxy


- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target{
    return [[[self class] alloc] initWithTarget:target];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [_target methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    if (_target == nil)  return;
    [invocation invokeWithTarget:_target];
}

- (BOOL)isProxy{
    return YES;
}

- (BOOL)isKindOfClass:(Class)aClass{
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass{
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol{
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [_target respondsToSelector:aSelector];
}

-(NSString *)description{
    return [_target description];
}

-(NSString *)debugDescription{
    return [_target debugDescription];
}



@end
