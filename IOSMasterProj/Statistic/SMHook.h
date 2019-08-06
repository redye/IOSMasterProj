//
//  SMHook.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMHook : NSObject

/**
 hook class 的方法

 @param classObject 目标类
 @param originSelector 源方法
 @param targetSelector 目标方法
 */
+ (void)hookClass:(Class)classObject originSelector:(SEL)originSelector targetSelector:(SEL)targetSelector;

@end

NS_ASSUME_NONNULL_END
