//
//  NSNotificationCenter+FLAdd.h
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (FLAdd)



- (void)postNotificationOnMainThread:(NSNotification *)notification;


- (void)postNotificationOnMainThread:(NSNotification *)notification
                        waitUtilDone:(BOOL)wait;



- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject;

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo;

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo
                            waitUtilDone:(BOOL)wait;

@end
