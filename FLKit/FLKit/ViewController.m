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

#import "Person.h"
#import "NSObject+FLAddForKVO.h"

#import "RetainCycleTimer.h"




@interface ViewController ()
{
    NSThread *_myThread;
    
    RetainCycleTimer * timer;
}

@property (nonatomic, strong) Person *person;

@end

static void * kPerson = "perosn";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testKVO];
   

    timer = [[RetainCycleTimer alloc] init];
    [timer test];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        timer = nil;
    });
}


- (void)testHash{
    // 1.0
    NSString *str1 = [NSString stringWithFormat:@"skyming"];
    NSString *str2 = [NSString stringWithFormat:@"skyming"];
    NSLog(@"str1的地址--%p--str2的地址--%p",str1,str2);
    NSLog(@"== %d",str1 == str2);
    NSLog(@"isEqual--%d",[str1 isEqual:str2]);
    NSLog(@"isEqualToString--%d",[str1 isEqualToString:str2]);
    // 2.0
    UIImage *image1 = [UIImage imageNamed:str1];
    UIImage *image2 = [UIImage imageNamed:str2];
    NSLog(@"image1的地址--%p--image2的地址--%p",image1,image2);
    NSLog(@"== %d",image1 == image2);
    NSLog(@"isEqual--%d",[image1 isEqual:image2]);
    // 3.0
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:image1];
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];
    NSLog(@"imageView1地址--%p-imageView2地址--%p",imageView1,imageView2);
    NSLog(@"== %d",imageView1 == imageView2);
    NSLog(@"isEqual--%d",[imageView1 isEqual:imageView2]);
}

- (void)testKVO{
    
    self.person = [Person new];
    
    [self.person addObserverBlockforKeyPath:@"name" block:^(__weak id obj, id oldVal, id newVal) {
        
    }];
    
    [self.person addObserverBlockforKeyPath:@"name" block:^(__weak id obj, id oldVal, id newVal) {
        
    }];
    
    [self.person addObserverBlockforKeyPath:@"age" block:^(__weak id obj, id oldVal, id newVal) {
        
    }];
    
//    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionPrior context:kPerson]; 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.person.name = @"fenglin";
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.person.age = 26;
    });
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"Person : %@",((Person *)object).name);
}




#pragma mark -- TEST--NSKeyedUnarchiver+FLAdd
- (void)testNSKeyedUnarchiverFLAdd{
//    NSException *expetion = nil;
//    [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"]] exception:&expetion];
//    if (expetion != nil) {
//        NSLog(@"%@",expetion.reason);
//    }
//    NSString *path = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"] encoding:NSUTF8StringEncoding error:nil];
//    
//    [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"] exception:&expetion];
//    if (expetion != nil) {
//        NSLog(@"%@",expetion.reason);
//    }
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
