//
//  SMCellNode.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/6/3.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMCellNode.h"

@implementation SMCellNode

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageNode = [[ASImageNode alloc] init];
        [self addSubnode:_imageNode];
        
        _textNode = [[ASTextNode alloc] init];
        [self addSubnode:_textNode];
        
        _subtextNode = [[ASTextNode alloc] init];
        [self addSubnode:_subtextNode];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *rightLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    rightLayout.spacing = 5.0;
    rightLayout.alignItems = ASStackLayoutAlignItemsStart;
    rightLayout.children = @[self.textNode, self.subtextNode];
    
    _imageNode.style.preferredSize = CGSizeMake(70, 70);
    _imageNode.cornerRadius = 35;
    _imageNode.borderWidth = 0.5;
    _imageNode.borderColor = [UIColor lightGrayColor].CGColor;
    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    layoutSpec.alignItems = ASStackLayoutAlignItemsCenter;
    layoutSpec.justifyContent = ASStackLayoutJustifyContentStart;
    layoutSpec.spacing = 10;
    layoutSpec.children = @[self.imageNode, rightLayout];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 15, 10, 15) child:layoutSpec];
}

@end
