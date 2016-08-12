//
//  FLTransaction.h
//  FLKit
//
//  Created by fenglin on 16/8/11.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLTransaction : NSObject

+ (FLTransaction *)transactionWithTarget:(id )target selector:(SEL)selector;

- (void)commit;


@end
