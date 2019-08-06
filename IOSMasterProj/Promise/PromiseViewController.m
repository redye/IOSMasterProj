//
//  PromiseViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "PromiseViewController.h"
#import "SMPNetManager.h"
#import "SMUser.h"

@interface PromiseViewController ()

@end

@implementation PromiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.backgroundColor = ThemeColor;
    [self.contentView addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSMutableDictionary *parameters = @{}.mutableCopy;
        NSMutableDictionary *reqParameters = @{}.mutableCopy;
        [parameters setObject:@"ios" forKey:@"requestSource"];
        [parameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
        [parameters setObject:@"mxd_appstore" forKey:@"channel"];
        [reqParameters setObject:@"18888888888" forKey:@"phoneNumber"];
        [reqParameters setObject:@"0000" forKey:@"validateCode"];
        [reqParameters setObject:@"0086" forKey:@"countryCode"];
        [reqParameters setObject:@"127.0.0.1" forKey:@"registerIp"];
        [reqParameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appIdentifier"];
        NSTimeInterval registerTime = [NSDate date].timeIntervalSince1970;
        NSString *time = [NSString stringWithFormat:@"%.0f", registerTime];
        [reqParameters setObject:time forKey:@"registerTime"];
        [parameters setObject:@"loginService" forKey:@"serviceName"];
        [parameters setObject:@"login" forKey:@"methodName"];
        [parameters setObject:[reqParameters yy_modelToJSONString] forKey:@"reqParams"];
        
        AnyPromise *promise = [SMPNetManager POST:nil parameters:parameters];
        
        promise.thenInBackground(^(NSDictionary *response) {
            NSLog(@"response ==> %@", response);
//            return [SMUser yy_modelWithJSON:response];
            return [SMPNetManager POST:nil parameters:parameters];
        }).thenInBackground(^(NSDictionary *response) {
            NSLog(@"response 2 --");
            return [SMUser yy_modelWithJSON:response];
        }).then(^(SMUser *user) {
            NSLog(@"user ==> %@", user.nickName);
            return [NSError errorWithDomain:@"Test" code:-1 userInfo:nil];
        }).catch(^(NSError *error) {
            NSLog(@"error ==> %@", error);
        }).ensure(^{
            NSLog(@"ensure");
        });;
    }];
 
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}


@end
