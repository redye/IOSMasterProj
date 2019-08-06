//
//  SMBatteryMonitor.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMBatteryMonitor : NSObject

+ (void)startMonitor;

+ (void)stopMonitor;

+ (CGFloat)getBatteryInfo;

@end

NS_ASSUME_NONNULL_END
