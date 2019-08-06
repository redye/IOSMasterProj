//
//  CatchCrashLogViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/15.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "CatchCrashLogViewController.h"
#import "LogListViewController.h"

struct Test {
    NSInteger a;
    NSInteger b;
};


@interface CatchCrashLogViewController ()

@end

@implementation CatchCrashLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"数组越界", @"signal bus", @"signal abrt"];
    
    int index = 0;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 100 + 40 * index, 100, 30);
        button.tag = 10000 + index;;
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        index ++;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100 + 40 * (index + 2), 100, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"Show Log" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showCrashLog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button {
    NSInteger index = button.tag - 10000;
    if (index == 0) {
        NSArray *array = @[];
        [array objectAtIndex:1];
    } else if (index == 1) {
        char *s = "Hello World";
        *s = 'H';
    } else if (index == 2) {
        struct Test a = {1, 2};
        struct Test *test = &a;
        test->a = 2;
        test->b = 4;
        free(test);
    }
}

- (void)showCrashLog {
    LogListViewController *controller = [[LogListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
