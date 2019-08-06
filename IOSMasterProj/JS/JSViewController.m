//
//  JSViewController.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/8/5.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SMPolyfillSet.h"

@interface JSViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) SMPolyfillSet *polyfillSet;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    _webView.delegate = self;
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:_webView];
}

- (JSContext *)currentContext {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    return context;
}

- (void)addMethonds:(JSContext *)context {
    __weak typeof(self) weakSelf = self;
    
    
    _polyfillSet = [SMPolyfillSet createWithContext:context];
    context[@"PolyFill"] = _polyfillSet;
    
    context[@"alert"] = ^(NSString *title, NSString *message) {
        [weakSelf alert:title message:message];
    };
}

- (void)alert:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
    });
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"web view did started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"web view did finished");
    
    JSContext *context = [self currentContext];
    [self addMethonds:context];
    
    JSValue *getNumber = context[@"getNumber"];
    JSValue *number = [getNumber callWithArguments:@[@(1)]];
    NSLog(@"number ==> %@", [number toNumber]);
//    [context evaluateScript:[NSString stringWithFormat:@"alert('当前值', '%@')", [number toNumber]]];
    
    [context evaluateScript:@"var i = 4 + 8;"];
    NSNumber *i = [context[@"i"] toNumber];
    NSLog(@"i ==> %@", i);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"web view did failed");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
