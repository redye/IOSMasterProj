//
//  ViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"导航";
    [self.view addSubview:self.tableView];
    
    self.dataArray = @[@{
                           @"title": @"无侵入埋点",
                           @"className": @"LoggerViewController"
                        }, @{
                           @"title": @"堆栈调用",
                           @"className": @"CallStackViewController"
                        }, @{
                           @"title": @"捕获崩溃日志",
                           @"className": @"CatchCrashLogViewController"
                        }, @{
                           @"title": @"卡顿监听",
                           @"className": @"SlowerMonitorViewController"
                        }, @{
                           @"title": @"OOM 监测",
                           @"className": @"OOMViewController"
                        }, @{
                           @"title": @"DDLog",
                           @"className": @"DDLogViewController"
                        }, @{
                           @"title": @"帧率监控",
                           @"className": @"FrameViewController"
                        }, @{
                           @"title": @"电量检测",
                           @"className": @"BatteryViewController"
                        }, @{
                           @"title": @"Texture",
                           @"className": @"TextureExampViewController"
                        }, @{
                           @"title": @"响应式编程",
                           @"className": @"ReactiveViewController"
                       }, @{
                           @"title": @"Latti animation",
                           @"className": @"AnimationViewController"
                       }, @{
                           @"title": @"Promise",
                           @"className": @"PromiseViewController"
                       }, @{
                           @"title": @"Yoga",
                           @"className": @"YogaViewController"
                           }, @{
                           @"title": @"JavaScriptCore",
                           @"className": @"JSViewController"
                           }
                       ];
}

- (void)injected {
    [self viewDidLoad];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"className"];
    NSString *title = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    Class class = NSClassFromString(className);
    UIViewController *controller = [[class alloc] init];
    controller.title = title;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}


@end
