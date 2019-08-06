//
//  SMUser.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/30.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMUser.h"

@implementation SMUser

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId": @"wid"
             };
}

@end
