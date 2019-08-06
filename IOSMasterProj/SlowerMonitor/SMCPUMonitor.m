//
//  SMCPUMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/17.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMCPUMonitor.h"
#import "SMCallStack.h"

#define SingleThreadCPUUsageThreshold 70

@implementation SMCPUMonitor

+ (void)updateCPU {
    [self CPUUsageInfo:nil thresholdBlock:^(thread_t thread) {
        NSString *stackString = smStackOfThread(thread);
        NSLog(@"CPU useage overload thread stack：\n%@", stackString);
    }];
}

+ (integer_t)CPUTotalUsage {
    integer_t totalUsage = 0;
    [self CPUUsageInfo:&totalUsage thresholdBlock:nil];
    return totalUsage;
}

+ (void)CPUUsageInfo:(integer_t *)totalUsage thresholdBlock:(void(^)(thread_t thread))block {
    integer_t usage = 0;
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount;
    kern_return_t kr = task_threads(mach_task_self(), &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_basic_info_t basicInfo;
        thread_info_data_t threadInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        kr = thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr == KERN_SUCCESS) {
            basicInfo = (thread_basic_info_t)threadInfo;
            if (!(basicInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsages = basicInfo->cpu_usage / TH_USAGE_SCALE * 100;
                usage += cpuUsages;
                // cpu 利用率大于 70, 打印当前线程的调用栈
                if (cpuUsages > SingleThreadCPUUsageThreshold && block) {
                    block(threads[i]);
                }
            }
        }
    }
    if (totalUsage) {
        *totalUsage = usage;
    }
}

@end
