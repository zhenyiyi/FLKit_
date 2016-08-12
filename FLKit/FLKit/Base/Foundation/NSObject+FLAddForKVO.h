//
//  NSObject+FLAddForKVO.h
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FLAddForKVO)

- (void)addObserverBlockforKeyPath:(NSString *)keyPath block:(void(^)(__weak id obj, id oldVal, id newVal))block;

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath;

- (void)removerObserverBlocks;



@end
