//
//  SMLogMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMLagMonitor.h"
#import "SMCallStack.h"
#import "SMCPUMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface SMLagMonitor () {
    @private
    int _timeoutCount;
    CFRunLoopObserverRef _runLoopObserver;
    
    @public
    dispatch_semaphore_t _dispatchSemaphore;
    CFRunLoopActivity _runLoopActivity;
}

@property (nonatomic, strong) NSTimer *cpuMonitorTimer;

@end

@implementation SMLagMonitor

+ (instancetype)sharedInstance {
    static SMLagMonitor *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    });
    return _sharedInstance;
}

- (void)beginMonitor {
    
    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                            target:self
                                                          selector:@selector(updateCPUInfo)
                                                          userInfo:nil
                                                           repeats:YES];
    if (_runLoopObserver) {
        return;
    }
    
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    _runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                               kCFRunLoopAllActivities,
                                               YES,
                                               0,
                                               &runLoopObserverCallback,
                                               &context);
    
    // 添加到主线程的 common 模式 下观察
    CFRunLoopAddObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    
    _dispatchSemaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程开启一个持续的 loop 用来进行监控
        while (YES) {
            // 返回值为 0 表示在超时时间内成功接收到信号
            // 非 0 表示超时。超时时间内 runloop 的状态没有发生变化
            // 超时的原因：上一个 runloop 的状态是 kCFRunLoopBeforeSources 或者是 kCFRunLoopAfterWaiting 表示遭遇到卡顿
            // kCFRunLoopBeforeSources 进入睡眠前的状态
            // kCFRunLoopAfterWaiting 唤醒后的状态
            long semaphoreWait = dispatch_semaphore_wait(self->_dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->_runLoopObserver) {
                    self->_timeoutCount = 0;
                    self->_dispatchSemaphore = 0;
                    self->_runLoopActivity = 0;
                    return ;
                }
                if (self->_runLoopActivity == kCFRunLoopBeforeSources || self->_runLoopActivity == kCFRunLoopAfterWaiting) {
                    // 上报堆栈信息
                    NSLog(@"monitor trigger");
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                        [SMCallStack callStackWithType:SMCallStackTypeMain];
                        // PLCrashReported 收集堆栈信息
                        PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                        PLCrashReporter *reporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                        NSData *data = [reporter generateLiveReport];
                        NSError *error = nil;
                        PLCrashReport *report = [[PLCrashReport alloc] initWithData:data error:&error];
                        NSString *reportString = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
                        NSLog(@"卡顿堆栈 ===> %@", reportString);
                    });
                    
                }
            }
            self->_timeoutCount = 0;
        }
    });
}

- (void)endMonitor {
    [self.cpuMonitorTimer invalidate];
    self.cpuMonitorTimer = nil;
    if (!_runLoopObserver) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}

#pragma mark - private
- (void)updateCPUInfo {
    [SMCPUMonitor updateCPU];
}

static void runLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    SMLagMonitor *lagMonitor = (__bridge SMLagMonitor *)info;
    lagMonitor->_runLoopActivity = activity;
    
    dispatch_semaphore_t dispatchSemaphor = lagMonitor->_dispatchSemaphore;
    dispatch_semaphore_signal(dispatchSemaphor);
}

@end
