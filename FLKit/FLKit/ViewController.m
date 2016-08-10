//
//  ViewController.m
//  FLKit
//
//  Created by fenglin on 16/8/10.
//  Copyright © 2016年 cys. All rights reserved.
//

#import "ViewController.h"
#import "NSThread+FLAdd.h"
#import "NSTimer+FLAdd.h"
#import "NSKeyedUnarchiver+FLAdd.h"






@interface ViewController ()
{
    NSThread *_myThread;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"]);
    [self testNSKeyedUnarchiverFLAdd];
    
   
}


#pragma mark -- TEST--NSKeyedUnarchiver+FLAdd
- (void)testNSKeyedUnarchiverFLAdd{
    NSException *expetion = nil;
    [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"]] exception:&expetion];
    if (expetion != nil) {
        NSLog(@"%@",expetion.reason);
    }
    NSString *path = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"] encoding:NSUTF8StringEncoding error:nil];
    
    [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"] exception:&expetion];
    if (expetion != nil) {
        NSLog(@"%@",expetion.reason);
    }
}


#pragma mark --- TEST-- NSTimer+FLAdd
- (void)testTimer{
    
    [NSTimer scheduledTimerWithTimeInterval:1 callback:^(NSTimer *timer) {
        NSLog(@"timer");
    } repeats:YES];
}



#pragma mark -- TEST -- NSThread+FLAdd
- (void)testThread{
    
    _myThread = [[NSThread alloc] initWithTarget:self selector:@selector(executeOnTheThread) object:nil];
    [_myThread start];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSelector:@selector(print) onThread:_myThread withObject:nil waitUntilDone:NO];
    });
}

- (void)executeOnTheThread{
    
    [NSThread addAutoreleasePoolAtCurrentRunLoop];
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}


- (void)print{
    NSLog(@"print");
}
@end
