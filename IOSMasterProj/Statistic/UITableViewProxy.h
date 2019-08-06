//
//  UITableViewProxy.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewProxy : NSObject<UITableViewDelegate>

@property (nonatomic, weak) id<UITableViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
