//
//  SMStudent.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMStudent.h"

@interface SMStudent ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) SMStudentGender gender;
@property (nonatomic, assign) NSUInteger studentNumber;
@property (nonatomic, assign) NSUInteger credit;
@property (nonatomic, assign) BOOL isAstify;

@property (nonatomic, copy) SatisfyActionBlock satisfyActionBlock;

@end

@implementation SMStudent

+ (SMStudent *)create {
    SMStudent *student = [[self alloc] init];
    
    return student;
}

- (SMStudent *)name:(NSString *)name {
    self.name = name;
    return self;
}

- (SMStudent *)gender:(SMStudentGender)gender {
    self.gender = gender;
    return self;
}

- (SMStudent *)studentNumber:(NSUInteger)studentNumber {
    self.studentNumber = studentNumber;
    return self;
}

- (SMStudent *)credit:(NSUInteger)credit {
    self.credit = credit;
    return self;
}

- (SMStudent *)filterIsAstifyCredit:(SatisfyActionBlock)satisfyActionBlock {
    if (satisfyActionBlock) {
        self.satisfyActionBlock = satisfyActionBlock;
        self.isAstify = satisfyActionBlock(self.credit);
    }
    return self;
}

- (SMStudent *)sendCredit:(NSUInteger (^)(NSUInteger))updateCreditBlock {
    if (updateCreditBlock) {
        self.credit = updateCreditBlock(self.credit);
        if (self.satisfyActionBlock) {
            self.isAstify = self.satisfyActionBlock(self.credit);
        }
    }
    return self;
}

- (SMCreditSubject *)creditSubject {
    if (!_creditSubject) {
        _creditSubject = [[SMCreditSubject alloc] init];
    }
    return _creditSubject;
}

@end
