//
//  SMFileManager.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/23.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMFileInfo : NSObject

@property (nonatomic, copy) NSString *dirName;


@end

@interface SMFileManager : NSObject

+ (NSString *)defaultLogDir;

+ (NSString *)logDirWithName:(NSString *)name;

+ (NSString *)logPathAtDir:(NSString *)dir name:(NSString *)name;

+ (BOOL)createLogFileAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
