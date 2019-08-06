//
//  LoginViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Additions.h"
#import "PersonalViewController.h"
#import "SMNetManager.h"
#import "SMUser.h"

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"请输入手机号:";
    [self.view addSubview:phoneLabel];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.view).offset(-20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(10);
        make.centerY.equalTo(phoneLabel.mas_centerY);
        make.width.mas_equalTo(150);
    }];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"请输入验证码:";
    [self.view addSubview:codeLabel];
    
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:codeTextField];
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.layer.borderWidth = 0.5;
    codeButton.layer.cornerRadius = 4;
    codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:codeButton];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_left);
        make.top.equalTo(phoneLabel.mas_bottom).offset(20);
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTextField.mas_left);
        make.centerY.equalTo(codeLabel.mas_centerY);
        make.width.mas_equalTo(150);
    }];
    
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeTextField.mas_right).offset(15);
        make.centerY.equalTo(codeLabel.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor blueColor];
    [self.view addSubview:_tipLabel];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 4;
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    [phoneTextField.rac_textSignal subscribeNext:^(NSString * x) {
        if (x.length > 11) {
            phoneTextField.text = [x substringToIndex:11];
        }
    }];
    
    [phoneTextField.rac_textSignal subscribeNext:^(NSString * x) {
        codeButton.enabled = [x isPhone];
        if (codeButton.enabled) {
            [codeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            codeButton.layer.borderColor = [UIColor blueColor].CGColor;
        } else {
            [codeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            codeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }];
    
    RACSignal *signal = [RACSignal combineLatest:@[phoneTextField.rac_textSignal, codeTextField.rac_textSignal] reduce:^id(NSString *phone, NSString *code){
        return @([phone isPhone] > 0 && code.length > 0);
    }];
    
    RAC(loginButton, enabled) = signal;
    
    [RACObserve(loginButton, enabled) subscribeNext:^(id x) {
        BOOL enabled = [x boolValue];
        if (enabled) {
            loginButton.layer.backgroundColor = [UIColor blueColor].CGColor;
        } else {
            loginButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        }
    }];
    
    @weakify(self);
    [[codeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 发送验证码
        @strongify(self);
        [self sendCodeWithPhone:phoneTextField.text];
    }];
    
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 登录
        @strongify(self);
        [self loginWithPhone:phoneTextField.text code:codeTextField.text];
    }];
    
}

- (void)sendCodeWithPhone:(NSString *)phone {
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSMutableDictionary *reqParameters = @{}.mutableCopy;
    [parameters setObject:@"ios" forKey:@"requestSource"];
    [parameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    [parameters setObject:@"mxd_appstore" forKey:@"channel"];
    [parameters setObject:@"loginService" forKey:@"serviceName"];
    [parameters setObject:@"sendMessage" forKey:@"methodName"];
    
    [reqParameters setObject:phone forKey:@"phoneNumber"];
    [reqParameters setObject:@"0086" forKey:@"countryCode"];
    [reqParameters setObject:@"127.0.0.1" forKey:@"registerIp"];
    NSTimeInterval registerTime = [NSDate date].timeIntervalSince1970;
    NSString *time = [NSString stringWithFormat:@"%.0f", registerTime];
    [reqParameters setObject:time forKey:@"registerTime"];
    [parameters setObject:[reqParameters yy_modelToJSONString] forKey:@"reqParams"];
    
    [[[SMNetManager sharedManager] POST:@"loan/proxy" parameters:parameters] subscribeNext:^(RACTuple * x) {
//        NSDictionary *response = x.second;
        self.tipLabel.hidden = YES;
    } error:^(NSError *error) {
        self.tipLabel.text = error.domain;
        self.tipLabel.hidden = NO;
    }];
}

- (void)loginWithPhone:(NSString *)phone code:(NSString *)code {
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSMutableDictionary *reqParameters = @{}.mutableCopy;
    [parameters setObject:@"ios" forKey:@"requestSource"];
    [parameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    [parameters setObject:@"mxd_appstore" forKey:@"channel"];
    [reqParameters setObject:phone forKey:@"phoneNumber"];
    [reqParameters setObject:code forKey:@"validateCode"];
    [reqParameters setObject:@"0086" forKey:@"countryCode"];
    [reqParameters setObject:@"127.0.0.1" forKey:@"registerIp"];
    [reqParameters setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appIdentifier"];
    NSTimeInterval registerTime = [NSDate date].timeIntervalSince1970;
    NSString *time = [NSString stringWithFormat:@"%.0f", registerTime];
    [reqParameters setObject:time forKey:@"registerTime"];
    [parameters setObject:@"loginService" forKey:@"serviceName"];
    [parameters setObject:@"login" forKey:@"methodName"];
    [parameters setObject:[reqParameters yy_modelToJSONString] forKey:@"reqParams"];
    
    @weakify(self);
    [[[SMNetManager sharedManager] POST:@"loan/proxy" parameters:parameters] subscribeNext:^(NSDictionary * x) {
        @strongify(self);
        NSDictionary *response = x;
        self.tipLabel.hidden = YES;
        SMUser *user = [SMUser yy_modelWithJSON:response];
        PersonalViewController *controller = [[PersonalViewController alloc] init];
        controller.user = user;
        [self.navigationController pushViewController:controller animated:YES];
    } error:^(NSError *error) {
        self.tipLabel.text = @"请求失败";
        self.tipLabel.hidden = NO;
    }];
}


@end
