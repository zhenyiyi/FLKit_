//
//  NSBundle+FLAdd.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSBundle+FLAdd.h"
#import <UIKit/UIKit.h>


@implementation NSBundle (FLAdd)

+ (NSArray<NSNumber *> *)preferredScales{
    static NSArray *scaleArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat scale = [UIScreen mainScreen].scale;
        if (scale <= 1) {
            scaleArray =  @[@1,@2,@3];
        }else if (scale <= 1) {
            scaleArray = @[@2,@3,@1];
        }else{
            scaleArray = @[@3,@2,@1];
        }
    });
    return scaleArray;
}


@end
