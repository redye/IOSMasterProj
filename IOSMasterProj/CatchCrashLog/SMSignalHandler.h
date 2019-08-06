//
//  SMSignalHandler.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/15.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSignalHandler : NSObject

+ (void)registerSignalHander;

+ (void)registerExceptionHandler;

@end

NS_ASSUME_NONNULL_END
