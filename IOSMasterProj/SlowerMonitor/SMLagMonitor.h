//
//  SMLogMonitor.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLagMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)beginMonitor;

- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
