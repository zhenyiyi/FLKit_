//
//  NSNotificationCenter+FLAdd.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "NSNotificationCenter+FLAdd.h"
#import <pthread.h>


@implementation NSNotificationCenter (FLAdd)

- (void)__postNotifation:(NSNotification *)noti{
    
}

- (void)postNotificationOnMainThread:(NSNotification *)notification{
    if (pthread_main_np()) return [self postNotification:notification];
    [self postNotificationOnMainThread:notification waitUtilDone:NO];
}


- (void)postNotificationOnMainThread:(NSNotification *)notification
                        waitUtilDone:(BOOL)wait{
    if (pthread_main_np()) return [self postNotification:notification];
    [[self class] performSelectorOnMainThread:@selector(__postNotifation:) withObject:nil waitUntilDone:wait];
}



- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject{
    if (pthread_main_np()) return [self postNotificationName:aName object:anObject];
    [self postNotificationNameOnMainThread:aName object:anObject userInfo:nil waitUtilDone:NO];

}

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo{
    if (pthread_main_np()) return [self postNotificationNameOnMainThread:aName object:anObject userInfo:aUserInfo waitUtilDone:NO];
    [self postNotificationNameOnMainThread:aName object:anObject userInfo:aUserInfo waitUtilDone:NO];
}

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo
                            waitUtilDone:(BOOL)wait{
    if (pthread_main_np()) return [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (aName != nil) info[@"name"] = aName;
    if (anObject != nil) info[@"object"] = anObject;
    if (aUserInfo != nil) info[@"userInfo"] = aUserInfo;
    [self performSelectorOnMainThread:@selector(__postNotifationName:) withObject:info waitUntilDone:wait];
}

- (void)__postNotifationName:(NSDictionary *)info{
    [[NSNotificationCenter defaultCenter] postNotificationName:info[@"name"] object:info[@"object"] userInfo:info[@"userInfo"]];
}

@end
