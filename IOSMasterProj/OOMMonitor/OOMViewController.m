//
//  OOMViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/21.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "OOMViewController.h"
#import "SMMemoryMonitor.h"
#include <malloc/malloc.h>

@interface OOMViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation OOMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100 + 40 , 100, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"Malloc" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 30)];
    label.text = @"当前已使用物理内存：";
    [self.view addSubview:label];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(250, 200, 100, 30)];
    _label.text = [NSString stringWithFormat:@"%.2f M", [SMMemoryMonitor userUsedAppMemory]];
    [self.view addSubview:_label];
}

- (void)buttonClick:(UIButton *)button {
    int size = 51 * 1024 * 1024;
    char *info = malloc(size);
    memset(info, 1, size);
    self.label.text = [NSString stringWithFormat:@"%.2f M", [SMMemoryMonitor userUsedAppMemory]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        free(info);
        self.label.text = [NSString stringWithFormat:@"%.2f M", [SMMemoryMonitor userUsedAppMemory]];
    });
}

@end
