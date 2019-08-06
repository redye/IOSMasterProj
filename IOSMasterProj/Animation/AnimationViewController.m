//
//  AnimationViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/30.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "AnimationViewController.h"
#import "AnimationTransitionViewController.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LOTAnimationView *animationView =[LOTAnimationView animationNamed:@"TwitterHeart"]; // [LOTAnimationView animationWithFilePath:[[NSBundle mainBundle] pathForResource:@"TwitterHeart" ofType:@"json"]];
    [animationView play];
    animationView.loopAnimation = YES;
    [self.contentView addSubview:animationView];
    
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
    }];
    
    LOTAnimatedControl *animationControl = [[LOTAnimatedControl alloc] initWithFrame:CGRectZero];
    LOTComposition *composition = [LOTComposition animationNamed:@"TwitterHeartButton"];
    [animationControl setAnimationComp:composition];
    animationControl.bounds = composition.compBounds;
    [animationControl addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:animationControl];
    
    [animationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)buttonClick:(LOTAnimatedControl *)button {
    @weakify(self);
    [button.animationView playWithCompletion:^(BOOL animationFinished) {
        @strongify(self);
        AnimationTransitionViewController *controller = [[AnimationTransitionViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
    }];
}

@end
