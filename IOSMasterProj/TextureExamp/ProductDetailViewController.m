//
//  ProductDetailViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SMCellNode.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SMCellNode *cellNode = [[SMCellNode alloc] init];
    cellNode.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 100);
    cellNode.backgroundColor = [UIColor whiteColor];
    cellNode.style.width = ASDimensionMake(ASDimensionUnitPoints, CGRectGetWidth(self.contentView.bounds));
//    cellNode.style.height = ASDimensionMake(ASDimensionUnitPoints, 120);
    cellNode.textNode.attributedText = [[NSAttributedString alloc] initWithString:self.product[@"title"]
                                                                   attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1]
                                                                                }];
    cellNode.subtextNode.attributedText = [[NSAttributedString alloc] initWithString:self.product[@"subtitle"]
                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                   NSForegroundColorAttributeName: [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1]
                                                                                   }];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.product[@"pictureUrl"]]
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                  if (image) {
                                                      cellNode.imageNode.image = image;
                                                  }
                                              }];

    [self.contentView addSubnode:cellNode];
    
}


@end
