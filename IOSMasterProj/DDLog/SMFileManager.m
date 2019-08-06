//
//  SMFileManager.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMFileManager.h"


@implementation SMFileInfo


@end

@implementation SMFileManager

+ (NSString *)defaultLogDir {
    return [self logDirWithName:@"Logger"];
}

+ (NSString *)logDirWithName:(NSString *)name {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    dir = [dir stringByAppendingPathComponent:name];
    return dir;
}

+ (NSString *)logPathAtDir:(NSString *)dir name:(NSString *)name {
    NSAssert(dir && dir.length > 0, @"Logger dir must set.");
    NSAssert(name && name.length > 0, @"Logger name must set.");
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'--'HH'-'mm'-'ss'-'SSS'";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@", applicationName, dateString, name]];
}

+ (BOOL)createLogFileAtPath:(NSString *)path {
    
    NSAssert(path && path.length > 0, @"Logger path must set.");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = YES;    
    if (![fileManager fileExistsAtPath:path]) {
        success = [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return success;
}

@end
