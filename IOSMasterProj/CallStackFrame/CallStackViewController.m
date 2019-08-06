//
//  FrameViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/10.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "CallStackViewController.h"
#import "SMCallStack.h"

@interface CallStackViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CallStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"所有线程", @"主线程", @"当前线程"];
    int index = 0;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + 100 * index, 100 , 80, 30);
        button.tag = 10000 + index;;
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        index ++;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.numberOfLines = 0;
    [scrollView addSubview:label];
    self.label = label;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-22);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.bottom.equalTo(scrollView);
    }];
}


- (void)buttonClick:(UIButton *)button {
    NSString *stackFrame = [SMCallStack callStackWithType:button.tag - 10000];
    self.label.text = stackFrame;
}

@end
