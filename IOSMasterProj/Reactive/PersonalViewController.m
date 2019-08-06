//
//  PersonalViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "PersonalViewController.h"

@interface SMUserNode : ASDisplayNode

@property (nonatomic, strong) ASNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *nickNameTextNode;
@property (nonatomic, strong) ASTextNode *phoneTextNode;

@end

@implementation SMUserNode

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageNode = [ASNetworkImageNode new];
        _imageNode.contentMode = UIViewContentModeScaleAspectFill;
        _nickNameTextNode = [ASTextNode new];
        _phoneTextNode = [ASTextNode new];
        
        [self addSubnode:_imageNode];
        [self addSubnode:_nickNameTextNode];
        [self addSubnode:_phoneTextNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *verticalLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalLayout.spacing = 5;
    verticalLayout.alignItems = ASStackLayoutAlignItemsStart;
    verticalLayout.children = @[self.nickNameTextNode, self.phoneTextNode];
    
    self.imageNode.style.preferredSize = CGSizeMake(70, 70);
    self.imageNode.cornerRadius = 35;
    ASStackLayoutSpec *horizontalLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    horizontalLayout.spacing = 10;
    horizontalLayout.alignItems = ASStackLayoutAlignItemsCenter;
    horizontalLayout.children = @[self.imageNode, verticalLayout];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 15, 0, 15) child:horizontalLayout];
}

- (void)updateWithUser:(SMUser *)user {
    if (user.headImg && user.headImg.length) {
        self.imageNode.URL = [NSURL URLWithString:user.headImg];
    } else {
        self.imageNode.image = [UIImage imageNamed:@"pink_pig"];
    }
    
    self.nickNameTextNode.attributedText = [[NSAttributedString alloc] initWithString:user.nickName
                                                                           attributes:@{
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:16]
                                                                                        }];
    self.phoneTextNode.attributedText = [[NSAttributedString alloc] initWithString:user.phone
                                                                        attributes:@{
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:16]
                                                                                    }];
}

@end

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SMUserNode *userNode = [SMUserNode new];
    userNode.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [userNode updateWithUser:self.user];
    userNode.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 200);
    [self.view addSubnode:userNode];
}


@end
