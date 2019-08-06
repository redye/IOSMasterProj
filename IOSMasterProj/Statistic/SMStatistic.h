//
//  SMLogger.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SMStatistic : NSObject

+ (instancetype)create;

- (SMStatistic *)message:(NSString *)message;


- (void)save;


@end

NS_ASSUME_NONNULL_END
