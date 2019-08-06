//
//  SMLayoutSpec.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMFlexDirection) {
    SMFlexDirectionRow,
    SMFlexDirectionColumn,
    SMFlexDirectionRowReverse,
    SMFlexDirectionColumnReverse
};

typedef NS_ENUM(NSInteger, SMJustifyContent) {
    SMJustifyFlexStart,
    SMJustifyFlexEnd,
    SMJustifyCenter,
    SMJustifySpaceBetween,
    SMJustifySpaceAround,
    SMJustifySpaceEvenly
};

typedef NS_ENUM(NSInteger, SMAlignItems) {
    SMAlignFlexStart,
    SMAlignFlexEnd,
    SMAlignFlexCenter,
    SMAlignStretch,
    SMAlignBaseline
};

typedef NS_ENUM(NSInteger, SMFlexWrap) {
    SMFlexNoWrap,
    SMFlexWrapWrap,
    SMFlexWrapReverse
};

@interface SMFlexboxLayoutSpec : ASLayoutSpec

@property (nonatomic, assign) SMFlexDirection flexDirection;

@property (nonatomic, assign) SMJustifyContent justifyContent;

@property (nonatomic, assign) SMAlignItems alignItems;

@property (nonatomic, assign) SMFlexWrap flexWrap;

@property (nonatomic, assign) CGFloat flex;

@property (nonatomic, assign) CGFloat flexGrow;

@property (nonatomic, assign) CGFloat flexShrink;

@property (nonatomic, assign) CGFloat flexBasis;

@property (nonatomic, assign) CGFloat spacing;

@end

NS_ASSUME_NONNULL_END
