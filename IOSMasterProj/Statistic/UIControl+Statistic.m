//
//  UIControl+Statistic.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "UIControl+Statistic.h"
#import "SMHook.h"
#import "SMStatistic.h"

@implementation UIControl (Statistic)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelectorAction = @selector(sendAction:to:forEvent:);
        SEL targetSelectorAction = @selector(hook_sendAction:to:forEvent:);
        [SMHook hookClass:self originSelector:originSelectorAction targetSelector:targetSelectorAction];
    });
}

- (void)hook_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    [self insertSendAction:action to:target forEvent:event];
    [self hook_sendAction:action to:target forEvent:event];
}

- (void)insertSendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionName = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);

        [[[SMStatistic create]
          message:[NSString stringWithFormat:@"%@ %@", targetName, actionName]]
         save];
    }
}

@end
