//
//  FLSentinel.h
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLSentinel : NSObject

@property (nonatomic, readonly) int32_t value;

- (int32_t)increase;


@end
