//
//  NSBundle+FLAdd.h
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides extensions for `NSBundle` to get resource by @2x or @3x...
 
 Example: ico.png, ico@2x.png, ico@3x.png. Call scaledResource:@"ico" ofType:@"png"
 on iPhone6 will return "ico@2x.png"'s path.
 */
@interface NSBundle (FLAdd)

/**
 An array of NSNumber objects, shows the best order for path scale search.
 e.g. iPhone3GS:@[@1,@2,@3] iPhone5:@[@2,@3,@1]  iPhone6 Plus:@[@3,@2,@1]
 */
+(NSArray<NSNumber *> *)preferredScales;


@end
