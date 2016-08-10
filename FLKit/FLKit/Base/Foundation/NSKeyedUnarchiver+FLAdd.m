//
//  NSKeyedUnarchiver+FLAdd.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSKeyedUnarchiver+FLAdd.h"

@implementation NSKeyedUnarchiver (FLAdd)

+ (id)unarchiveObjectWithData:(NSData *)data
                    exception:(NSException * *)exception
{
    id obj;
    @try {
        obj =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException *exec) {
        *exception = exec;
    } @finally {
        
    }
    return obj;
}

+ (id)unarchiveObjectWithFile:(NSString *)path
                    exception:(NSException * *)exception{
    id obj;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } @catch (NSException *exce) {
        *exception = exce;
    } @finally {
        
    }
    return obj;
}
@end
