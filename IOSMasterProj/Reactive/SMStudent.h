//
//  SMStudent.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCreditSubject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMStudentGender) {
    SMStudentGenderMale,
    SMStudentGenderFemale
};

typedef BOOL(^SatisfyActionBlock)(NSInteger credit);


@interface SMStudent : NSObject

@property (nonatomic, strong) SMCreditSubject *creditSubject;

+ (SMStudent *)create;

- (SMStudent *)name:(NSString *)name;

- (SMStudent *)gender:(SMStudentGender)gender;

- (SMStudent *)studentNumber:(NSUInteger)studentNumber;

- (SMStudent *)credit:(NSUInteger)credit;

- (SMStudent *)filterIsAstifyCredit:(SatisfyActionBlock)satisfyActionBlock;

- (SMStudent *)sendCredit:(NSUInteger(^)(NSUInteger credit))updateCreditBlock;

@end

NS_ASSUME_NONNULL_END
