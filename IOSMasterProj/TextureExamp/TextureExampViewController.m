//
//  TextureExampViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/28.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "TextureExampViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <SDWebImage/SDWebImage.h>
#import "ProductDetailViewController.h"
#import "SMCellNode.h"

@interface TextureExampViewController ()

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TextureExampViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
//    _tableNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableNode.dataSource = (id<ASTableDataSource>)self;
    _tableNode.delegate = (id<ASTableDelegate>)self;
    [self.view addSubnode:_tableNode];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSUTF8StringEncoding error:nil];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dic) {
            self.dataArray = [dic objectForKey:@"data"];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableNode.frame = self.view.bounds;
}

#pragma mark - ASTableDataSource, ASTableDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^{
        
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        
        SMCellNode *node = [[SMCellNode alloc] init];
        node.selectionStyle = UITableViewCellSelectionStyleNone;
        node.textNode.attributedText = [[NSAttributedString alloc] initWithString:dic[@"title"]
                                                                       attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1]
                                                                                    }];
        node.subtextNode.attributedText = [[NSAttributedString alloc] initWithString:dic[@"subtitle"]
                                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                       NSForegroundColorAttributeName: [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1]
                                                                                       }];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:dic[@"pictureUrl"]]
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      if (image) {
                                                          node.imageNode.image = image;
                                                      }
                                                  }];
        return node;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    ProductDetailViewController *controller = [[ProductDetailViewController alloc] init];
    controller.title = dic[@"title"];
    controller.product = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
