//
//  SMCreditSubject.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMCreditSubject.h"

@interface SMCreditSubject ()

@property (nonatomic, strong) NSMutableArray *actionBlocks;

@property (nonatomic, assign) NSUInteger credit;

@end

@implementation SMCreditSubject

- (SMCreditSubject *)sendNext:(NSUInteger)credit {
    self.credit = credit;
    for (SubscribeNextActionBlock block in self.actionBlocks) {
        block(self.credit);
    }
    return self;
}

- (SMCreditSubject *)subscribeNext:(SubscribeNextActionBlock)actionBlock {
    if (actionBlock) {
        [self.actionBlocks addObject:actionBlock];
        actionBlock(self.credit);
    }
    return self;
}

- (NSMutableArray *)actionBlocks {
    if (!_actionBlocks) {
        _actionBlocks = [NSMutableArray array];
    }
    return _actionBlocks;
}

@end
