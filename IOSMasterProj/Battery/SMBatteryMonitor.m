//
//  SMBatteryMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMBatteryMonitor.h"


@implementation SMBatteryMonitor

+ (CGFloat)getBatteryInfo {
    UIDevice *device = [UIDevice currentDevice];
    return [device batteryLevel];
}

+ (void)startMonitor {
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
}

+ (void)stopMonitor {
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:NO];
}

@end
