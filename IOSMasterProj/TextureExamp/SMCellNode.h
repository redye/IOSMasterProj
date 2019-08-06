//
//  SMCellNode.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCellNode : ASCellNode

@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *textNode;
@property (nonatomic, strong) ASTextNode *subtextNode;

@end

NS_ASSUME_NONNULL_END
