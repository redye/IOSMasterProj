//
//  SMPNetManager.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMPNetManager.h"

@implementation SMPNetManager

+ (SMPNetManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static SMPNetManager *_sharedInstance;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[SMPNetManager alloc] init];
        }
    });
    return _sharedInstance;
}

- (instancetype)init {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self = [super initWithBaseURL:[[NSURL alloc] initWithString:@"http://fin-loan-api.dev.weimob.com"] sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    }
    return self;
}

+ (AnyPromise *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    return [[SMPNetManager sharedInstance] POST:URLString parameters:parameters];
}

- (AnyPromise *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    AnyPromise *promise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        [self POST:URLString && URLString.length > 0 ? URLString : @"loan/proxy"
        parameters:parameters
          progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSString *returnCode = [responseObject objectForKey:@"returnCode"];
               if ([returnCode isEqualToString:@"000000"]) {
                   adapter([responseObject objectForKey:@"responseVo"], nil);
               } else {
                   NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"returnMsg"]
                                                        code:[returnCode integerValue]
                                                    userInfo:[responseObject objectForKey:@"responseVo"]];
                   adapter(nil, error);
               }
           }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               adapter(nil, error);
           }];
    }];
    return promise;
}

@end
