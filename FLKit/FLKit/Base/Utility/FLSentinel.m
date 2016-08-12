//
//  FLSentinel.m
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "FLSentinel.h"
#import <libkern/OSAtomic.h>


@implementation FLSentinel{
    int32_t _val;
}
- (int32_t)value{
    return _val;
}

- (int32_t)increase{
    return  OSAtomicIncrement32(&_val);
}
@end
