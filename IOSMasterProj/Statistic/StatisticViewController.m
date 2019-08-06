//
//  HookViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation StatisticViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100, 100, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"打点" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 150) style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 50;
    [self.view addSubview:tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"INJECTION_BUNDLE_NOTIFICATION" object:nil];
}

- (void)refresh {
    NSLog(@"refresh ==>");
    [self viewDidLoad];
}

//- (void)injected {
//    NSLog(@"injected =====> %@", self);
//    [self viewDidLoad];
//}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"table view did selected at %ld", indexPath.row);
}

#pragma mark - actions
- (void)buttonClick:(UIButton *)button {
    NSLog(@"button click");
}

@end
