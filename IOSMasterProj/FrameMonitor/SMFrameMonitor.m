//
//  FrameMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMFrameMonitor.h"

@interface SMFrameMonitor () {
    NSTimeInterval _lastTimestamp;
    NSInteger _totalCount;
    CGFloat _fps;
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, weak) id<SMFrameMonitorDelegate> delegate;

@end

@implementation SMFrameMonitor

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SMFrameMonitor *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[SMFrameMonitor alloc] init];
        }
    });
    return _sharedInstance;
}

- (void)startMonitor {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsCount:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopMonitor {
    if (_displayLink) {
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)fpsCount:(CADisplayLink *)displayLink {
    if (_lastTimestamp == 0) {
        _lastTimestamp = displayLink.timestamp;
    } else {
        _totalCount ++;
        NSTimeInterval useTime = displayLink.timestamp - _lastTimestamp;
        if (useTime < 1) return;
        _lastTimestamp = displayLink.timestamp;
        _fps = _totalCount / useTime;
        _totalCount = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(updateFps:)]) {
            [_delegate updateFps:_fps];
        }
    }
}

- (void)addDelegate:(id<SMFrameMonitorDelegate>)delegate {
    _delegate = delegate;
}

@end
