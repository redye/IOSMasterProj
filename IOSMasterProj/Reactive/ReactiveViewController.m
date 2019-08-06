//
//  ReacctiveViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ReactiveViewController.h"
#import "SMStudent.h"
#import "LoginViewController.h"

@interface ReactiveViewController ()

@property (nonatomic, strong) UILabel *astifyLabel;

@property (nonatomic, strong) UILabel *currentCreditLabel;

@property (nonatomic, strong) UILabel *colorIndictorLabel;

@property (nonatomic, strong) SMStudent *student;

@end

@implementation ReactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"分数随机" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(200);
    }];
    
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        [self.student.creditSubject sendNext:arc4random() % 100];
//        [self.view endEditing:YES];
    }];
    
    _currentCreditLabel = [[UILabel alloc] init];
    [self.view addSubview:_currentCreditLabel];
    [_currentCreditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(button.mas_bottom).offset(20);
        make.width.mas_equalTo(50);
    }];
    
    _colorIndictorLabel = [[UILabel alloc] init];
    [self.view addSubview:_colorIndictorLabel];
    [_colorIndictorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentCreditLabel.mas_right).offset(20);
        make.top.equalTo(button.mas_bottom).offset(20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    _astifyLabel = [[UILabel alloc] init];
    [self.view addSubview:_astifyLabel];
    [_astifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colorIndictorLabel.mas_right).offset(20);
        make.top.equalTo(button.mas_bottom).offset(20);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.student = [[[[[[SMStudent create] name:@"June"]
        gender:SMStudentGenderFemale]
       studentNumber:1006]
      credit:70]
     filterIsAstifyCredit:^BOOL(NSInteger credit) {
         if (credit >= 70) {
             weakSelf.astifyLabel.text = [NSString stringWithFormat:@"%ld: 及格", credit];
             return YES;
         } else {
             weakSelf.astifyLabel.text = [NSString stringWithFormat:@"%ld: 不及格", credit];
             return NO;
         }
     }];
    
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        if (credit >= 70) {
            weakSelf.astifyLabel.text = @"及格";
        } else {
            weakSelf.astifyLabel.text = @"不及格";
        }
    }];
    
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        weakSelf.currentCreditLabel.text = [NSString stringWithFormat:@"%ld", credit];
    }];
    
    [self.student.creditSubject subscribeNext:^(NSUInteger credit) {
        if (credit <= 60) {
            self.colorIndictorLabel.backgroundColor = [UIColor redColor];
        } else if (credit <= 80) {
            self.colorIndictorLabel.backgroundColor = [UIColor orangeColor];
        } else {
            self.colorIndictorLabel.backgroundColor = [UIColor greenColor];
        }
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入内容语文成绩";
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.currentCreditLabel.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.placeholder = @"请输入内容数学成绩";
    [self.view addSubview:textField2];
    [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.mas_right).offset(20);
        make.top.equalTo(self.currentCreditLabel.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    [self.view addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(textField.mas_bottom).offset(20);
    }];
    
    RACSignal *signal1 = textField.rac_textSignal;
    RACSignal *signal2 = textField2.rac_textSignal;
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[signal1, signal2]];
    [combineSignal subscribeNext:^(RACTuple * x) {
        CGFloat chineseScore = [x.first floatValue];
        CGFloat mathScore = [x.second floatValue];
        if (chineseScore >= 60 && mathScore >= 60) {
            scoreLabel.text = @"及格";
        } else {
            scoreLabel.text = @"不及格";
        }
    }];
    
    [combineSignal subscribeNext:^(RACTuple * x) {
        NSString *first = x.first;
        NSString *second = x.second;
        scoreLabel.hidden = !(first.length > 0 && second > 0);
    }];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        LoginViewController *controller = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)buttonClick:(UIButton *)button {
    [self.student.creditSubject sendNext:arc4random() % 100];
}

@end
