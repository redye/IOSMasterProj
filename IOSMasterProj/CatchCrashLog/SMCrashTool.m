//
//  SMCrashTool.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/20.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMCrashTool.h"

@implementation SMCrashTool

+ (NSString *)defaultCrashDir {
    return [self crashDirWithName:@"CrashLog"];
}

+ (NSString *)crashDirWithName:(NSString *)dirName {
    NSString * crashDir  = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dirName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashDir]){
        [[NSFileManager defaultManager] createDirectoryAtPath:crashDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return crashDir;
}

+ (void)saveCrashLog:(NSString *)log {
    [self saveCrashLog:log path:[self defaultCrashDir]];
}

+ (void)saveCrashLog:(NSString *)log path:(NSString *)path {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSString * savePath = [path stringByAppendingFormat:@"/signal_%@.log",timeString];
    
    BOOL sucess = [log writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"result => %d \n path => %@ \n",sucess, savePath);
}

+ (NSArray *)logFilesWithDir:(NSString *)dir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    if (!error) {
        return list;
    }
    return nil;
}

+ (NSString *)logWithFilePath:(NSString *)filePath {
    NSError *error = nil;
    NSString *log = [NSString stringWithContentsOfFile:filePath
                                              encoding:NSUTF8StringEncoding
                                                 error:&error];
    if (!error) {
        return log;
    }
    return nil;
}

@end
