//
//  LogDetailViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/20.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "LogDetailViewController.h"
#import "SMCrashTool.h"
#import "Masonry.h"

@interface LogDetailViewController ()

@end

@implementation LogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日志详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *log = [SMCrashTool logWithFilePath:self.filePath];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.text = log;
    label.numberOfLines = 0;
    [scrollView addSubview:label];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
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




@end
