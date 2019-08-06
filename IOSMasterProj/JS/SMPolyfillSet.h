//
//  SMPolyfillSet.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/8/5.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SMPolyfillSetJSExports <JSExport>

+ (instancetype)createWithContext:(JSContext *)context;

//- (void)alert:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons;

JSExportAs(alert, - (void)alert:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons);

JSExportAs(share, - (void)share:(NSDictionary *)shareContent);


@end

@interface SMPolyfillSet : NSObject<SMPolyfillSetJSExports>

@property (nonatomic, readonly) JSContext *context;

@end

NS_ASSUME_NONNULL_END
