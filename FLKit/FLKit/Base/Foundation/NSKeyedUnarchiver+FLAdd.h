//
//  NSKeyedUnarchiver+FLAdd.h
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedUnarchiver (FLAdd)

+ (id)unarchiveObjectWithData:(NSData *)data
                    exception:(NSException * *)exception;

+ (id)unarchiveObjectWithFile:(NSString *)path
                    exception:(NSException * *)exception;


@end
