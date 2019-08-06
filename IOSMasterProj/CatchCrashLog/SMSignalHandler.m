//
//  SMSignalHandler.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/15.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMSignalHandler.h"
#include <sys/signal.h>
#import <UIKit/UIKit.h>
#import "SMCallStack.h"
#import "SMCrashTool.h"

typedef void (*SignalHandler) (int signal, siginfo_t *info, void *context);

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGSYS,
    SIGPIPE
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

static SignalHandler s_fatal_signal_origin_handlers[] = {
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
};

static NSUncaughtExceptionHandler *originExceptionHandler = NULL;

@implementation SMSignalHandler

+ (void)registerSignalHander {
    backupOriginHandler();
    
    registerSignalHandler();
}

+ (void)registerExceptionHandler {
    registerExceptionHandler();
}

+ (void)saveCrashLog:(NSString *)crashLog {
    [SMCrashTool saveCrashLog:crashLog];
}


static void backupOriginHandler() {
    for (int i = 0; i < s_fatal_signal_num; i++) {
        struct sigaction old_action;
        sigaction(s_fatal_signals[i], NULL, &old_action);
        if (old_action.sa_sigaction) {
            s_fatal_signal_origin_handlers[i] = old_action.sa_sigaction;
        } else {
            s_fatal_signal_origin_handlers[i] = NULL;
        }
    }
}

static void registerExceptionHandler(void) {
    originExceptionHandler = NSGetUncaughtExceptionHandler();
    
    NSSetUncaughtExceptionHandler(&uncatchExceptionHandler);
}

static void uncatchExceptionHandler(NSException *exception) {
    [SMSignalHandler saveCrashLog:[[exception callStackSymbols] description]];
    
    if (originExceptionHandler) {
        originExceptionHandler(exception);
    }
}

static void registerSignalHandler(void) {
    for (int i = 0; i < s_fatal_signal_num; i++) {
//        signal(s_fatal_signals[i], handleSignalException);
        struct sigaction action;
        action.sa_sigaction = signalExceptionHandler;
        action.sa_flags = SA_NODEFER | SA_SIGINFO;
        sigemptyset(&action.sa_mask);
        sigaction(s_fatal_signals[i], &action, 0);
    }
}

static void signalExceptionHandler(int signal, siginfo_t *info, void *context) {
    
    NSMutableString *mStr = [NSMutableString string];
    [mStr appendString:@"Signal Exception:\n"];
    [mStr appendFormat:@"Signal %@ was raised.\n", signalName(signal)];
    [mStr appendString:@"Call Stack: \n"];
    
    // 调用栈
    // 过滤掉第一样，因为第一行是 signalExceptionHandler 帧
    NSArray *callStacks = [NSThread callStackSymbols];
    for (NSUInteger i = 1; i < callStacks.count; i++) {
        [mStr appendFormat:@"%@\n", callStacks[i]];
    }
    
    [mStr appendString:@"Thread info: %@\n"];
    [mStr appendFormat:@"%@\n", [[NSThread currentThread] description]];
    
    [SMSignalHandler saveCrashLog:mStr];
    
    clearSignalHandler();
    
    SignalHandler originHandler = findOriginHandler(signal);
    if (originHandler) {
        originHandler(signal, info, context);
    }
    
    kill(getpid(), SIGKILL);
//    exit(0);
}

static NSString *signalName(int signal) {
    NSString *signalName = nil;
    switch (signal) {
        case SIGABRT:
            signalName = @"SIGABRT";
            break;
        case SIGBUS:
            signalName = @"SIGBUS";
            break;
        case SIGFPE:
            signalName = @"SIGASIGFPEBRT";
            break;
        case SIGILL:
            signalName = @"SIGILL";
            break;
        case SIGSEGV:
            signalName = @"SIGSEGV";
            break;
        case SIGTRAP:
            signalName = @"SIGTRAP";
            break;
        case SIGTERM:
            signalName = @"SIGTERM";
            break;
        case SIGKILL:
            signalName = @"SIGKILL";
            break;
            
        default:
            break;
    }
    return signalName;
}

static SignalHandler findOriginHandler(int signal) {
    for (int i = 0; i < s_fatal_signal_num; i++) {
        if (signal == s_fatal_signals[i]) {
            return s_fatal_signal_origin_handlers[i];
        }
    }
    return NULL;
}

static void clearSignalHandler() {
    for (int i = 0; i < s_fatal_signal_num; i++) {
        signal(s_fatal_signals[i], SIG_DFL);
    }
}

@end
