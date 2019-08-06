//
//  SMCrashTool.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/20.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCrashTool : NSObject

+ (NSString *)defaultCrashDir;

+ (NSString *)crashDirWithName:(NSString *)dirName;

+ (void)saveCrashLog:(NSString *)log;

+ (void)saveCrashLog:(NSString *)log path:(NSString *)path;

+ (NSArray *)logFilesWithDir:(NSString *)dir;

+ (NSString *)logWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
