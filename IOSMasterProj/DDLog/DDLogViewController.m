//
//  DDLogViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "DDLogViewController.h"
#import "SMLog.h"
#import "SMDiskMonitor.h"
#import "SMCPUMonitor.h"

@interface DDLogViewController ()

@end

@implementation DDLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SMLog setLogShowEnabled:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100 + 40 , 100, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"DDLog" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 300, 30)];
    label.text = @"Capture Log";
    [self.view addSubview:label];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(20, 250 , 100, 30);
    startButton.backgroundColor = [UIColor orangeColor];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(150, 250 , 100, 30);
    stopButton.backgroundColor = [UIColor orangeColor];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
}

- (void)buttonClick:(UIButton *)button {
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    NSLog(@"这是个测试");
    
    NSLog(@"当前 CPU 利用率 %d", [SMCPUMonitor CPUTotalUsage]);
}

- (void)start {
    // iOS 10 之后不能获取 ASL 日志信息了
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    
#else
    [DDASLLogCapture start];
#endif
    
    NSLog(@"这是个测试2");
    
    [SMDiskMonitor start];
}

- (void)stop {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    
#else
    [DDASLLogCapture stop];
#endif
    
    [SMDiskMonitor stop];
}

- (void)lowDiskNotify {
    
}

@end
