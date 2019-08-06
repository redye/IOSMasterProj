//
//  SMViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/31.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    [self adjustContentViewFrame];
}

- (void)adjustContentViewFrame {
    if ([self.contentView isDescendantOfView:self.view]) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        BOOL navigationBarHidden = self.navigationController.navigationBarHidden;
        CGFloat navigationBarHeight = navigationBarHidden == NO ? CGRectGetHeight(navigationBar.frame):0;
        //顶部状态条高度
        if (navigationBarHeight > 0) {
            if (IS_IPHONE_X) {
                navigationBarHeight += 44;
            } else {
                navigationBarHeight += 20;
            }
        }
        CGFloat tabBarHeight = 0; //[self.tabBarController isShow:self]?CGRectGetHeight(self.tabBarController.tabBar.frame):0;
        if (tabBarHeight <= 0 && navigationBar.superview == self.view) {
            tabBarHeight = CGRectGetHeight(navigationBar.frame);
        }
        CGRect frame = CGRectMake(0, navigationBar.translucent == NO?0:navigationBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - navigationBarHeight - tabBarHeight);
        if (CGRectEqualToRect(frame, self.contentView.frame) == NO) {
            self.contentView.frame = frame;
        }
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = BackgroundColor;
    }
    return _contentView;
}

- (void)dealloc {
    NSLog(@"dealloc --- %@ --- %s", [self class], __func__);
}

@end
