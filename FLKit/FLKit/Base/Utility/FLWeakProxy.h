//
//  FLWeakProxy.h
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLWeakProxy : NSProxy

@property(nonatomic, weak, readonly)id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;


@end
