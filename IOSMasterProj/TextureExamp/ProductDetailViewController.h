//
//  ProductDetailViewController.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/29.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "SMViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailViewController : SMViewController

@property (nonatomic, strong) NSDictionary *product;

@end

NS_ASSUME_NONNULL_END
