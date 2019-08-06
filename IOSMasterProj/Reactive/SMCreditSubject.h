//
//  SMCreditSubject.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SubscribeNextActionBlock)(NSUInteger credit);

@interface SMCreditSubject : NSObject

- (SMCreditSubject *)sendNext:(NSUInteger)credit;

- (SMCreditSubject *)subscribeNext:(SubscribeNextActionBlock)actionBlock;

@end

NS_ASSUME_NONNULL_END
