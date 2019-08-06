//
//  SMTableView.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMTableView : UIView

@property (nonatomic, strong) SMTableViewModel *viewModel;

- (instancetype)initWithViewModel:(SMTableViewModel *)viewModel;
- (void)updateWithViewModel:(SMTableViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
