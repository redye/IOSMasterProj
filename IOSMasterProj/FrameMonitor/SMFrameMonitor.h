//
//  FrameMonitor.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMFrameMonitorDelegate <NSObject>

@optional
- (void)updateFps:(CGFloat)fps;

@end

@interface SMFrameMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)stopMonitor;

- (void)addDelegate:(id<SMFrameMonitorDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
