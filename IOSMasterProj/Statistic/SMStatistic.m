//
//  SMLogger.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMStatistic.h"


@interface SMStatistic ()

@property (nonatomic, copy) NSString *message;

@end


@implementation SMStatistic


static SMStatistic *_instance = nil;
+ (instancetype)create {
    if (!_instance) {
        _instance = [[SMStatistic alloc] init];
    }
    return _instance;
}

- (SMStatistic *)message:(NSString *)message {
    NSLog(@"logger message ====> %@ \n", message);
    self.message = message;
    return self;
}


- (void)save {
    
}

@end
