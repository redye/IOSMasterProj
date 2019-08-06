//
//  SMLog.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMLog.h"
#import "SMFileManager.h"
#import "SMLogIndicator.h"

#include <sys/fcntl.h>

static int ns_log_origin_handler;

static void(*origin_ns_log)(NSString *format, ...);

static void hook_ns_log(NSString *format, ...) {
    
    // 写文件
    
    va_list va;
    va_start(va, format);
    NSLogv(format, va);
    va_end(va);
}

static void hook_c_ns_log() {
    struct rebinding rebindings[] = {
        {
            "NSLog",
            hook_ns_log,
            (void *)&origin_ns_log
        }
    };
    rebind_symbols(rebindings, 1);
}

static void redirect_ns_log_handler() {
    NSString *path = [SMLog logPath];
    const char *p = [path UTF8String];
    // 第一种方式
//    int fn = open(p, (O_RDWR | O_CREAT), 0644);
//    ns_log_origin_handler = dup(STDERR_FILENO);
//    dup2(fn, STDERR_FILENO);
    
    // 第二种方式
    ns_log_origin_handler = dup(STDERR_FILENO);
    freopen(p, "a+", stderr);
}

static void restore_ns_log_handler() {
    dup2(ns_log_origin_handler, STDERR_FILENO);
}

@interface SMLog () {
    NSString *_logFile;
    BOOL _showEnabled;
    SMLogIndicator *_logIndicator;
}

@end

@implementation SMLog

+ (void)hookNSLog {
    hook_c_ns_log();
//    redirect_ns_log_handler();
}

+ (void)clearHook {
    restore_ns_log_handler();
}

+ (instancetype)sharedInstance {
    static SMLog *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _logFile = [SMFileManager logPathAtDir:[SMFileManager defaultLogDir] name:@"logger.log"];
        _showEnabled = NO;
        _logIndicator = [[SMLogIndicator alloc] init];
        [SMFileManager createLogFileAtPath:_logFile];
    }
    return self;
}


+ (NSString *)logPath {
    return [SMLog sharedInstance]->_logFile;
}

+ (NSString *)logString {
    NSString *logString = [NSString stringWithContentsOfFile:[self logPath]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    return logString;
}

+ (void)setLogShowEnabled:(BOOL)enabled {
    [SMLog sharedInstance]->_showEnabled = enabled;
    if (enabled) {
        [[SMLog sharedInstance]->_logIndicator showIndicator];
    } else {
        [[SMLog sharedInstance]->_logIndicator closeIndicator];
    }
}


- (void)redirectNSLog {
    // 第三种方式
    ns_log_origin_handler = dup(STDERR_FILENO);
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];
    int pipeWriteHandle = [[pipe fileHandleForWriting] fileDescriptor];
    dup2(pipeWriteHandle, STDERR_FILENO);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectLogHandler:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)redirectLogHandler:(NSNotification *)notification {
    NSFileHandle *pipeReadHandle = notification.object;
    NSData *data = [notification.userInfo objectForKey:NSFileHandleNotificationDataItem];
    
    [self writeData:data toFile:self->_logFile];
    
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)writeData:(NSData *)data toFile:(NSString *)filePath {
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle closeFile];
}

@end
