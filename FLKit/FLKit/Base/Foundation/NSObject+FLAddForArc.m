//
//  NSObject+FLAddForArc.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSObject+FLAddForArc.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

/*
 * 在Objective-C中定义了6种类型的修饰符，可用于修饰正式协议中的方法，
    以便程序员可以显示地指出远程消息的行为意图：
    Oneway
    in
    out
    inout
    bycopy
    byref
 *
 *
 
    同步和异步的消息
    考虑下面的只有返回值的方法：
    -(BOOL)canDance;
    当在同一个应用程序中发送canDance消息的时候，在对应的方法被调用后，其返回值会立直接返回给消息的发送者。但是当消息的接收者是在远端的程序中时，那么实际上就需要两个消息：一个消息是的远端对象调用对应的方法；另外一个则是把远端计算结果发送回来的消息
 
    
    通常来讲，大多数的远程消息都是和上面一样的双向远程过程调用（RPC）。发送消息的应用程序会一直等待，直到接收消息的程序调用方法完毕，并返回所请求的信息。即使方法没有返回值，也是要等待接收方调用完毕的。这样的好处是两端的通信程序是同步的。正是由于这样的原因，这种往返式的消息被成为同步消息。同步消息是缺省的消息机制。
 
    然而，上述同步消息中的等待并不是在所有情况下都是必要的或者说是好的做法。有时候，只需要发送消息给远端对象，而不用等待期处理完毕。这样以来，发送方可以继续做别的事情，接收方可以在自己有能力的时候再进行消息的处理。Objective-C中提供了一种返回值修饰符，以表示该方法是用于异步消息的。
 
    -(oneway void)waltzAtWill;
 
    尽管oneway是一种修饰符，他可以和特定的类型联合起来使用，如oneway float 或者是oneway id，但是真正有意义的用法是和void联合起来使用：oneway void。异步消息是不能有返回值的。
 
 */
@implementation NSObject (FLAddForArc)

- (instancetype)arcDebugRetain{
    return [self retain];
}

//使用 oneway 的作用是 异步消息，不需要等待。这一般是线程之间通信的接口定义。表示单向的调用。
- (oneway void)arcDebugRelease{
    [self release];
}

- (instancetype)arcDebugAutorelease{
    return [self autorelease];
}

- (NSUInteger)arcDebugRetainCount{
    return self.retainCount;
}
@end
