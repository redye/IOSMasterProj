//
//  SMNetManager.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMNetManager : AFHTTPSessionManager

+ (SMNetManager *)sharedManager;

- (RACSignal *)POST:(NSString *)URLString
         parameters:(nullable NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
