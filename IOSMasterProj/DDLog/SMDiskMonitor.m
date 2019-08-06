//
//  SMDiskMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMDiskMonitor.h"

#include <notify.h>
#include <notify_keys.h>

static BOOL _cancel = YES;

@implementation SMDiskMonitor

+ (void)start {
    if (!_cancel) {
        return;
    }
    _cancel = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self registerSysNotification];
    });
}

+ (void)stop {
    _cancel = YES;
}

+ (void)registerSysNotification {
    int token = 0;
//    uint32_t status = notify_register_check(kNotifyVFSLowDiskSpace, &token);
//    if (NOTIFY_STATUS_OK == status) {
//
//    }
    uint32_t registerStatus = notify_register_dispatch(kNotifyVFSLowDiskSpace, &token, dispatch_get_global_queue(0, 0), ^(int token) {
        [self clearDiskCache];
        
        if (_cancel) {
            notify_cancel(token);
            return ;
        }
    });
    if (NOTIFY_STATUS_OK == registerStatus) {
        
    }
}

+ (void)clearDiskCache {
    NSLog(@"low disk space");
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [dirs objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray<NSString *> *filePaths = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    if (filePaths.count > 0) {
        for (NSString *path in filePaths) {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
}

@end
