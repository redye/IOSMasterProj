//
//  SMLogIndicator.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/24.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMLogIndicator.h"
#import "LoggerViewController.h"
#import "SMLog.h"

@interface SMLogIndicator ()

@property (nonatomic, strong) UIView *indicatorView;

@end


@implementation SMLogIndicator


- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _indicatorView.layer.cornerRadius = 40;
//        _indicatorView.layer.backgroundColor = [UIColor orangeColor].CGColor;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 80, 80);
        gradientLayer.cornerRadius = 40;
        gradientLayer.type = kCAGradientLayerRadial;
        gradientLayer.colors = @[
                                 (__bridge id)[UIColor lightGrayColor].CGColor,
                                 (__bridge id)[UIColor darkGrayColor].CGColor,
                                 ];
        //    gradientLayer.locations = @[];
        gradientLayer.startPoint = CGPointMake(0.5, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 1);
        [_indicatorView.layer addSublayer:gradientLayer];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        [_indicatorView addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_indicatorView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        label.center = CGPointMake(40, 40);
        label.text = @"Logger";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        [_indicatorView addSubview:label];
    }
    return _indicatorView;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:pan.view.superview];
    pan.view.center = point;
}

- (void)tap {
    LoggerViewController *controller = [[LoggerViewController alloc] init];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)showIndicator {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) return;
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.indicatorView.frame) / 2 + 10, CGRectGetHeight(window.frame) / 2);
    [window addSubview:self.indicatorView];
    self.indicatorView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        self.indicatorView.alpha = 1;
    }];
}

- (void)closeIndicator {
    [self.indicatorView removeFromSuperview];
}

@end
