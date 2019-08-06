//
//  SMNetManager.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMNetManager.h"

@implementation SMNetManager

+ (SMNetManager *)sharedManager {
    static dispatch_once_t onceToken;
    static SMNetManager *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        if (!_sharedManager) {
            _sharedManager = [[self alloc] init];
            _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
            _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
            _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
        }
    });
    return _sharedManager;
}

- (instancetype)init {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self = [super initWithBaseURL:[[NSURL alloc] initWithString:@"http://fin-loan-api.dev.weimob.com"] sessionConfiguration:configuration];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)POST:(NSString *)URLString
         parameters:(NSDictionary *)parameters {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        [self POST:URLString
        parameters:parameters
          progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
               NSString *returnCode = [responseObject objectForKey:@"returnCode"];
               if ([returnCode isEqualToString:@"000000"]) {
                   [subscriber sendNext:[responseObject objectForKey:@"responseVo"]];
               } else {
                   NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"returnMsg"]
                                                        code:[returnCode integerValue]
                                                    userInfo:[responseObject objectForKey:@"responseVo"]];
                   [subscriber sendError:error];
               }
               
               dispatch_group_leave(group);
           }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [subscriber sendError:error];
               dispatch_group_leave(group);
           }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


@end
