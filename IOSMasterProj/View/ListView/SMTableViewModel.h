//
//  SMTableViewModel.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/16.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMTableViewModel : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat fixedViewHeight;
@property (nonatomic, assign) CGFloat hintViewHeight;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *fixedView;
@property (nonatomic, strong) UIView *hintView;
@property (nonatomic, strong) UIView *guideView;

@property (nonatomic, assign) BOOL isAutoRefreshing;
@property (nonatomic, assign) BOOL isCloseRefresh;

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) UITableViewCell *cell;

- (instancetype)initWithDefaultValue;

@end

NS_ASSUME_NONNULL_END
