//
//  LogListViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/20.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "LogListViewController.h"
#import "SMCrashTool.h"
#import "LogDetailViewController.h"

@interface LogListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日志列表";
    NSString *dir = [SMCrashTool defaultCrashDir];
    self.dataArray = [SMCrashTool logFilesWithDir:dir];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [self.dataArray objectAtIndex:indexPath.row];
    NSString *filePath = [[SMCrashTool defaultCrashDir] stringByAppendingPathComponent:fileName];
    LogDetailViewController *controller = [[LogDetailViewController alloc] init];
    controller.filePath = filePath;
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
