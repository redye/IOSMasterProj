//
//  UIViewController+Statistic.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "UIViewController+Statistic.h"
#import "SMHook.h"
#import "SMStatistic.h"

@implementation UIViewController (Statistic)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelectorAppear = @selector(viewWillAppear:);
        SEL targetSelectorAppear = @selector(hook_viewWillAppear:);
        [SMHook hookClass:self originSelector:originSelectorAppear targetSelector:targetSelectorAppear];
        
        SEL originSelectorDisappear = @selector(viewWillDisappear:);
        SEL targetSelectorDisappear = @selector(hook_viewWillDisappear:);
        [SMHook hookClass:self originSelector:originSelectorDisappear targetSelector:targetSelectorDisappear];
        
    });
}

- (void)hook_viewWillAppear:(BOOL)animation {
    [self insertToViewWillAppear];
    [self hook_viewWillAppear:animation];
}

- (void)hook_viewWillDisappear:(BOOL)animated {
    [self insertToViewWillDisappear];
    [self hook_viewWillDisappear:animated];
}


- (void)insertToViewWillAppear {
    [[[SMStatistic create]
      message:[NSString stringWithFormat:@"%@ Appear", NSStringFromClass([self class])]]
     save];
}

- (void)insertToViewWillDisappear {
    [[[SMStatistic create]
      message:[NSString stringWithFormat:@"%@ Disappear", NSStringFromClass([self class])]]
     save];
}


@end
