//
//  SMTableView.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMTableView.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIView+Addition.h"

@interface SMTableView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *fixedView;
@property (nonatomic, strong) UIView *hintView;
@property (nonatomic, strong) UIView *guideView;

@property (nonatomic, assign) CGFloat startOffsetY;

@end

@implementation SMTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildTableView];
    }
    return self;
}

- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel {
    if (self = [super init]) {
        [self buildTableView];
        [self updateWithViewModel:viewModel];
    }
    return self;
}

- (void)dealloc {
    [self removeKVO];
}

#pragma mark - constructor
- (void)buildTableView {
    self.backgroundColor = [self.viewModel backgroundColor];
    [self addSubviews:@[self.tableView, self.headerView, self.fixedView, self.hintView, self.guideView]];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.viewModel.headerViewHeight);
    }];
    
    [self.fixedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.viewModel.fixedViewHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixedView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.tableView);
        make.height.mas_equalTo(self.viewModel.hintViewHeight);
    }];
    [self hideHintView:YES];
    
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self hideGuideView:YES];
}

#pragma mark - interface
- (void)updateWithViewModel:(SMTableViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self updateTableViewConstraints];
    
    [self addKVO];
    
    [self judgeIfNeedRefresh];
    
    if (self.viewModel.isAutoRefreshing) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    self.headerView.hidden = self.viewModel.headerViewHeight == 0;
    self.fixedView.hidden = self.viewModel.fixedViewHeight == 0;
}

#pragma mark - private
- (void)reloadData {
    [self.tableView reloadData];
}

- (void)updateTableViewConstraints {
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.headerViewHeight);
    }];
    if (self.viewModel.headerView) {
        [self.headerView addSubview:self.viewModel.headerView];
        [self.viewModel.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.headerView);
        }];
    }
    
    [self.fixedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.fixedViewHeight);
    }];
    if (self.viewModel.fixedView) {
        [self.fixedView addSubview:self.viewModel.fixedView];
        [self.viewModel.fixedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fixedView);
        }];
    }
    
    [self.hintView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewModel.hintViewHeight);
    }];
    if (self.viewModel.hintView) {
        [self.hintView addSubview:self.viewModel.hintView];
        [self.viewModel.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.hintView);
        }];
    }
    if (self.viewModel.guideView) {
        [self.guideView addSubview:self.viewModel.guideView];
        [self.viewModel.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.guideView);
        }];
    }
}

- (void)judgeIfNeedRefresh {
    if (self.viewModel.isCloseRefresh) {
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
    }
}

- (void)endRefreshRefreshing {
    [self reloadData];
    if (!self.viewModel.isCloseRefresh) {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)endLoadMoreRefreshing {
    [self reloadData];
    if (!self.viewModel.isCloseRefresh) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)hideHintView:(BOOL)isHide {
    self.hintView.hidden = isHide;
}

- (void)hideGuideView:(BOOL)isHide {
    self.guideView.hidden = isHide;
}

#pragma mark - properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UIView *)fixedView {
    if (!_fixedView) {
        _fixedView = [[UIView alloc] init];
    }
    return _fixedView;
}

- (UIView *)hintView {
    if (!_hintView) {
        _hintView = [[UIView alloc] init];
    }
    return _hintView;
}

- (UIView *)guideView {
    if (!_guideView) {
        _guideView = [[UIView alloc] init];
    }
    return _guideView;
}

- (SMTableViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SMTableViewModel alloc] initWithDefaultValue];
    }
    return _viewModel;
}

#pragma mark - KVO
- (void)addKVO {
    
}

- (void)removeKVO {
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.cell;
}

#pragma mark - UIGestureRecognizerDelegate

@end
