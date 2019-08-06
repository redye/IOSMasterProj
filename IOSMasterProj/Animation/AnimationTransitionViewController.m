//
//  AnimationTransitionViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/31.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "AnimationTransitionViewController.h"

@interface AnimationTransitionViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation AnimationTransitionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

#pragma mark -- View Controller Transitioning

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition1"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"
                                                                                                     applyAnimationTransform:NO];
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition2"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"
                                                                                                     applyAnimationTransform:NO];
    return animationController;
}

@end
