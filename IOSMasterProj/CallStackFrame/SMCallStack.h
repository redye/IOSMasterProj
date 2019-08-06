//
//  SMCallStack.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCallLib.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMCallStackType) {
    SMCallStackTypeAll,   // 所有线程
    SMCallStackTypeMain, // 主线程
    SMCallStackTypeCurrent // 当前线程
};

@interface SMCallStack : NSObject

/**
 获取堆栈

 @param type 线程类型
 @return 堆栈字符串
 */
+ (NSString *)callStackWithType:(SMCallStackType)type;

extern NSString *smStackOfThread(thread_t thread);

@end

NS_ASSUME_NONNULL_END
