//
//  SMMemoryMonitor.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/21.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMMemoryMonitor.h"
#import "SMCallLib.h"

#include <malloc/malloc.h>
#include <execinfo.h>
#import "SMCallStack.h"

#define stack_logging_type_free        0
#define stack_logging_type_generic    1    /* anything that is not allocation/deallocation */
#define stack_logging_type_alloc    2    /* malloc, realloc, etc... */
#define stack_logging_type_dealloc    4    /* free, realloc, etc... */
#define stack_logging_flag_zone        8    /* NSZoneMalloc, etc... */
#define stack_logging_type_vm_allocate  16      /* vm_allocate or mmap */
#define stack_logging_type_vm_deallocate  32    /* vm_deallocate or munmap */
#define stack_logging_flag_cleared    64    /* for NewEmptyHandle */
#define stack_logging_type_mapped_file_or_shared_mem    128

#define stack_max_pepth_sys 100

#define memory_chunk_threshold 50 * 1024 * 1024

/*
 * 0000 0000    0
 * 0000 0001    1
 * 0000 0010    2
 * 0000 0100    4
 * 0000 1000    8
 * 0001 0000    16
 * 0010 0000    32
 * 0100 0000    64
 * 1000 0000    128
 */

/**
 func         malloc/valloc/memalign          calloc                         realloc                   free/free_definite_size
 type            alloc|zone              alloc|zone|clear                alloc|dealloc|zone              dealloc|zone
 arg2               size                    size                            ptr                             ptr
 arg3               0                       0                               size                            0
 return_val         ptr                     ptr                             new_ptr                         0
 
 */

// malloc 源码： https://opensource.apple.com/source/libmalloc/libmalloc-53.1.1/src/malloc.c.auto.html

// void
//__disk_stack_logging_log_stack(uint32_t type_flags, uintptr_t zone_ptr, uintptr_t arg2, uintptr_t arg3, uintptr_t return_val, uint32_t num_hot_to_skip)

//static void (*origin__disk_stack_logging_log_stack)(uint32_t type_flags, uintptr_t zone_ptr, uintptr_t arg2, uintptr_t arg3, uintptr_t return_val, uint32_t num_hot_to_skip);

// 获得当前线程调用栈
NSString * recordBacktrace() {
    void *callStack[stack_max_pepth_sys];
    int depth = backtrace(callStack, stack_max_pepth_sys);
//    char **traceChar = backtrace_symbols(callStack, depth);  // 频繁调用这里会 crash
//    NSMutableString *stackString = [NSMutableString string];
    for (int i = 1; i < depth; i++) {
//        [stackString appendFormat:@"%s\n", traceChar[i]];
    }
//    free(traceChar);
//    return stackString;
    return nil;
}

static void smRecordMallocStack(vm_address_t address, size_t size) {
    
}

static void smRemoveMallocStack(vm_address_t address) {
    
}

static void hook__disk_stack_logging_log_stack (uint32_t type_flags, uintptr_t zone_ptr, uintptr_t arg2, uintptr_t arg3, uintptr_t return_val, uint32_t num_hot_to_skip){
    size_t size = 0;
    vm_address_t address;  // address
    
    if (type_flags & stack_logging_flag_zone) { // 所有的 type 都包含 stack_logging_flag_zone
        type_flags &= ~stack_logging_flag_zone;
    }
    if (type_flags == (stack_logging_type_alloc | stack_logging_type_dealloc)) {
        size = arg3;
        address = arg2;
        vm_address_t newAddress = return_val;
        if (address ==  newAddress) {
            smRemoveMallocStack(address);
            smRecordMallocStack(newAddress, size);
        }
    } else if (type_flags & stack_logging_type_alloc) {
        size = arg2;
        address = return_val;
        if (address) {
            smRecordMallocStack(address, size);
        }
    } else if (type_flags & stack_logging_type_dealloc) {
        size = 0;
        address = arg2;
        if (!address) return;
        // 移除
        smRemoveMallocStack(address);
    } else if (type_flags == (stack_logging_type_alloc | stack_logging_flag_cleared)) {
        size = arg2;
        address = return_val;
    }
    recordBacktrace();
    if (size > memory_chunk_threshold) {
        NSString *stackString = [SMCallStack callStackWithType:SMCallStackTypeCurrent]; //smGetCallStack();
        NSLog(@"large oom stack ==> \n%@", stackString);
    }
}

typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);

extern malloc_logger_t *malloc_logger;

static void (*origin_malloc)(size_t __size);
static void (*origin_calloc)(size_t __count, size_t __size);
static void (*origin_valloc)(size_t __size);
static void (*origin_realloc)(void *__ptr, size_t __size);
static void (*origin_block_copy)(const void *aBlock);

static void hook_malloc(size_t __size) {
    origin_malloc(__size);
}

static void hook_calloc(size_t __count, size_t __size) {
    origin_calloc(__count, __size);
}

static void hook_valloc(size_t __size) {
    origin_valloc(__size);
}

static void hook_realloc(void *__ptr, size_t __size) {
    origin_realloc(__ptr, __size);
}

static void hook_block_copy(const void *aBlock) {
    origin_block_copy(aBlock);
}

static void hook_c_malloc() {
    struct rebinding rebindings[] = {
        {
            "malloc",
            hook_malloc,
            (void *)&origin_malloc
        }, {
            "calloc",
            hook_calloc,
            (void *)&origin_calloc
        }, {
            "valloc",
            hook_valloc,
            (void *)&origin_valloc
        }, {
            "ralloc",
            hook_realloc,
            (void *)&origin_realloc
        }, {
            "_Block_copy",
            hook_block_copy,
            (void *)&origin_block_copy
        }
    };
    int result = rebind_symbols(rebindings, 5);
    if (result == 0) {
        malloc_logger = hook__disk_stack_logging_log_stack;
        NSLog(@"fish hook 【%@】 success.", @"malloc_zone_malloc");
    }
}

static uint64_t smGetAppMemoryBytes(void) {
    uint64_t userUsedMemory = 0;
    task_vm_info_data_t info;
    mach_msg_type_number_t taskInfoCount = TASK_VM_INFO_COUNT;
    kern_return_t kr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&info, &taskInfoCount);
    if (kr == KERN_SUCCESS) {
        userUsedMemory = (uint64_t)info.phys_footprint;
    }
    
    return userUsedMemory;
}

@interface SMMemoryMonitor () {
    NSMutableDictionary *_largeMallocSizeDictionary;
}

@end

@implementation SMMemoryMonitor

+ (void)hookMalloc {
    hook_c_malloc();
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SMMemoryMonitor * _sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
            _sharedInstance->_largeMallocSizeDictionary = [NSMutableDictionary dictionary];
        }
    });
    return _sharedInstance;
}

- (void)beginMonitor {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)endMoniter {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning:(NSNotification *)notication {
    CGFloat used = [self userUsedAppMemory];
    NSLog(@"收到内存警告，当前已使用物理内存 ====> %.2f", used);
}

+ (CGFloat)userUsedAppMemory {
    uint64_t usedMemory = smGetAppMemoryBytes();
    return usedMemory / 1024.0 / 1024.0;
}

- (CGFloat)userUsedAppMemory {
    uint64_t usedMemory = smGetAppMemoryBytes();
    return usedMemory / 1024.0 / 1024.0;
}

@end
