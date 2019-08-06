//
//  AppDelegate.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "AppDelegate.h"
#include <execinfo.h>
#import "SMMemoryMonitor.h"
#import "SMLog.h"
#import "SMSignalHandler.h"
#import "SMCPUMonitor.h"

@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#if DEBUG
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"];
    [bundle load];
#endif
    
//    [self startBackgroundTask];
    
    [[SMMemoryMonitor sharedInstance] beginMonitor];
    
    // DDLog
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//    [DDLog addLogger:[DDOSLogger sharedInstance]];
//#else
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
//#endif
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    [fileLogger setDoNotReuseLogFiles:YES];
    NSLog(@"log path ==> %@\n", [fileLogger currentLogFileInfo].filePath);
    [DDLog addLogger:fileLogger];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [SMMemoryMonitor hookMalloc];
    
    [SMLog hookNSLog];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SMLog setLogShowEnabled:NO];
    });
    
    [SMSignalHandler registerSignalHander];
    
    [SMSignalHandler registerExceptionHandler];
    
    NSLog(@"当前 CPU 利用率 %d", [SMCPUMonitor CPUTotalUsage]);
    
    return YES;
}



//- (void)injected {
//    NSLog(@"injected =====> %@", self);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


// 后台保活3分钟
- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTaskWithAppilcation:application];
    }];
}

- (void)startBackgroundTask {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@" ====== timer working ======");
    }];
    [timer fire];
}

- (void)endBackgroundTaskWithAppilcation:(UIApplication *)application {
    NSLog(@"************************* end ******************************");
//    NSLog(@"stack frame ==> %@", [NSThread callStackSymbols]);
    NSMutableString *crashString = [NSMutableString string];
    void *callStack[128];
    int i, frames = backtrace(callStack, 128);
    char **traceChar = backtrace_symbols(callStack, frames);
    for (i = 0; i < frames; i++) {
        [crashString appendFormat:@"%s\n", traceChar[i]];
    }
    free(traceChar);
    NSLog(@"stack frame ===> %@", crashString);
    NSLog(@"************************* end ******************************");
    [application endBackgroundTask:self.backgroundTaskIdentifier];
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
