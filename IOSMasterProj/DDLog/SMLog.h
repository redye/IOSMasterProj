//
//  SMLog.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMLog : NSObject

+ (void)hookNSLog;

+ (void)clearHook;

+ (NSString *)logPath;

+ (NSString *)logString;

+ (instancetype)sharedInstance;

+ (void)setLogShowEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
