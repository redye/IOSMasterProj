//
//  SMCallLib.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#ifndef SMCallLib_h
#define SMCallLib_h

#import <Foundation/Foundation.h>
#include <mach/task.h>
#include <mach/mach_init.h>
#include <mach/thread_act.h>
#include <mach/thread_info.h>
#include <mach/vm_map.h>
#include <pthread/pthread.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>

#ifdef __LP64__
typedef struct mach_header_64       machHeaderByCPU;
typedef struct segment_command_64   segmentComandByCPU;
typedef struct section_64           sectionByCPU;
typedef struct nlist_64             nlistByCPU;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT_64

#else
typedef struct mach_header      machHeaderByCPU;
typedef struct segment_command  segmentComandByCPU;
typedef struct section          sectionByCPU;
typedef struct nlist            nlistByCPU;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT

#endif

#ifndef SEG_DATA_CONST
#define SEG_DATA_CONST  "__DATA_CONST"
#endif


#endif /* SMCallLib_h */
