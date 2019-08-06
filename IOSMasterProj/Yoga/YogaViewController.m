//
//  YogaViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "YogaViewController.h"

@interface YogaViewController ()

@end

@implementation YogaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(self.contentView.bounds.size.width);
        layout.height = YGPointValue(self.contentView.bounds.size.height);
        layout.alignItems = YGAlignCenter;
        layout.justifyContent = YGJustifyCenter;
    }];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor lightGrayColor];
    [containerView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems = YGAlignCenter;
        layout.width = YGPointValue(CGRectGetWidth(self.contentView.bounds));
//        layout.height = YGPointValue(100);
//        layout.flex = 0.5;
    }];
    [self.contentView addSubview:containerView];
    
    for (int i = 0; i < 3; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor redColor];
        [containerView addSubview:itemView];
        [itemView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.flex = i + 1;
            layout.isEnabled = YES;
            layout.width = YGPointValue(100);
            layout.height = YGPointValue(80);
            layout.margin = YGPointValue(10);
        }];
    }
    
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
}


@end
