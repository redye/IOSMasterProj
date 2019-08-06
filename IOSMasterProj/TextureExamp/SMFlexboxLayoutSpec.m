//
//  SMLayoutSpec.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMFlexboxLayoutSpec.h"

@interface SMFlexboxLayoutSpec ()


@end

@implementation SMFlexboxLayoutSpec

- (ASLayout *)calculateLayoutThatFits:(ASSizeRange)constrainedSize {
    ASLayout *layout = [ASLayout layoutWithLayoutElement:self size:constrainedSize.min];
    
    return layout;
}


@end
