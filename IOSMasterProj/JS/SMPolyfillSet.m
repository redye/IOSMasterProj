//
//  SMPolyfillSet.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/8/5.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "SMPolyfillSet.h"


@interface SMPolyfillSet ()

@property (nonatomic, strong) JSContext *context;

@end

@implementation SMPolyfillSet

+ (instancetype)createWithContext:(JSContext *)context {
    SMPolyfillSet *polyfillSet = [[SMPolyfillSet alloc] init];
    polyfillSet.context = context;
    return polyfillSet;
}

- (void)alert:(NSString *)title
      message:(NSString *)message
      buttons:(NSArray *)buttons {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakSelf = self;
        [buttons enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:[obj objectForKey:@"title"]
                                                             style:[[obj objectForKey:@"style"] integerValue]
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               NSString *method = [obj objectForKey:@"callback"];
                                                               NSArray *args = @[@(idx)];
                                                               JSValue *callback = weakSelf.context[method];
                                                               [callback callWithArguments:args];
                                                           }];
            [controller addAction:action];
        }];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
    });
}

- (void)share:(NSDictionary *)shareContent {
    NSLog(@"share ==> %@", shareContent);
}

@end
