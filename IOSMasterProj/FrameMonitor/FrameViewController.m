//
//  FrameViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "FrameViewController.h"
#import "SMFrameMonitor.h"

#include <os/signpost.h>

@interface FrameViewController ()<SMFrameMonitorDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"开始监控", @"结束监控"];
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
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 200, 30)];
    _label.text = @"当前帧率：";
    [self.view addSubview:_label];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = false;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_tableView];
    
    [[SMFrameMonitor sharedInstance] addDelegate:self];
    
    [NSThread currentThread];
    [NSThread mainThread];
    
//    OS_SIGNPOST_INTERVAL_BEGIN
}

- (void)buttonClick:(UIButton *)button {
    NSInteger index = button.tag - 10000;
    if (index == 0) {
        [[SMFrameMonitor sharedInstance] startMonitor];
    } else {
        [[SMFrameMonitor sharedInstance] stopMonitor];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    os_log_t log = os_log_create("com.apple.trailablazer", "Networking");
    os_signpost_id_t intervalId = os_signpost_id_generate(log);
    os_signpost_interval_begin(log, intervalId, "Parsing", "Parsing started SIZE: %ld", data.length);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    sleep(arc4random() % 5);
    os_signpost_interval_end(log, intervalId, "Parsing", "Parsing Finished.");
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", (long)indexPath.row];
    if (indexPath.row % 15 == 0) {
//        usleep(200 * 1000);
    }
    return cell;
}

#pragma mark - SMFrameMonitorDelegate
- (void)updateFps:(CGFloat)fps {
    self.label.text = [NSString stringWithFormat:@"当前帧率： %.2f", fps];
//    NSLog(@"当前帧率： %.2f", fps);
}

@end
