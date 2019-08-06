//
//  SMCPUMonitor.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/17.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCPUMonitor : NSObject

+ (void)updateCPU;

+ (integer_t)CPUTotalUsage;

@end

NS_ASSUME_NONNULL_END
