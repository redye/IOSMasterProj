//
//  UITableView+Statistic.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "UITableView+Statistic.h"
#import "SMHook.h"
#import "SMStatistic.h"
#import "UITableViewProxy.h"
#import <objc/runtime.h>

@implementation UITableView (Statistic)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelector = @selector(setDelegate:);
        SEL targetSelector = @selector(hook_setDelegate:);
        [SMHook hookClass:self originSelector:originSelector targetSelector:targetSelector];
    });
}

- (void)hook_setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate) {
        // proxy 要被强引用，设置 tableView 的 delegate 是 weak 引用，会被立即释放掉
        UITableViewProxy *proxy = (UITableViewProxy *)self.proxy;
        proxy.delegate = delegate;
        [self hook_setDelegate:proxy];
    } else {
        [self hook_setDelegate:delegate];
    }
}

- (id)proxy {
    id proxy = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(NSStringFromSelector(_cmd)));
    if (!proxy) {
        proxy = [[UITableViewProxy alloc] init];
        [self setProxy:proxy];
    }
    return proxy;
}

- (void)setProxy:(id)proxy {
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(NSStringFromSelector(@selector(proxy))), proxy, OBJC_ASSOCIATION_RETAIN);
}

@end
