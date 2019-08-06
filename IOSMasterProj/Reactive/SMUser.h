//
//  SMUser.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/30.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMUser : NSObject

@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger isnewUser;

@end

NS_ASSUME_NONNULL_END
