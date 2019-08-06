//
//  SMMemoryMonitor.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/21.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMMemoryMonitor : NSObject

+ (void)hookMalloc;

+ (instancetype)sharedInstance;

- (void)beginMonitor;

- (void)endMoniter;


/**
 获取 APP 当前已使用的物理内存

 @return 已使用的物理内存
 */
+ (CGFloat)userUsedAppMemory;

- (CGFloat)userUsedAppMemory;

@end

NS_ASSUME_NONNULL_END
