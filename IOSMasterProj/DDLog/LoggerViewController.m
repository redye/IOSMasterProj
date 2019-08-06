//
//  LoggerViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/24.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "LoggerViewController.h"
#import "SMCrashTool.h"
#import "SMLog.h"

@interface LoggerViewController ()

@end

@implementation LoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [SMLog setLogShowEnabled:NO];
    
    NSString *log = [SMCrashTool logWithFilePath:[SMLog logPath]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.text = log;
    label.numberOfLines = 0;
    [scrollView addSubview:label];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-22);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.bottom.equalTo(scrollView);
    }];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        [SMLog setLogShowEnabled:YES];
    }];
}

@end
