//
//  NSObject+FLAddForArc.h
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FLAddForArc)

- (instancetype)arcDebugRetain;

- (oneway void)arcDebugRelease;

- (instancetype)arcDebugAutorelease;

- (NSUInteger)arcDebugRetainCount;


@end
