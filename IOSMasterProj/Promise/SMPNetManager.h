//
//  SMPNetManager.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMPNetManager : AFHTTPSessionManager

+ (SMPNetManager *)sharedInstance;

+ (AnyPromise *)POST:(nullable NSString *)URLString
  parameters:(NSDictionary *)parameters;

- (AnyPromise *)POST:(nullable NSString *)URLString
          parameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
