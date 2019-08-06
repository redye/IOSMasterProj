//
//  PersonalViewController.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : UIViewController

@property (nonatomic, strong) SMUser *user;

@end

NS_ASSUME_NONNULL_END
