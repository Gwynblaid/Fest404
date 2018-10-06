// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "InstagramAuthorizationViewController.h"
#import <WebKit/WebKit.h>
#import "NSDictionary+Requests.h"

@interface InstagramAuthorizationViewController ()<WKNavigationDelegate>

@end

@implementation InstagramAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:webView];
    NSDictionary *views = @{@"view" : webView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-0-|" options:0 metrics:nil views:views]];
    webView.navigationDelegate = self;
	NSDictionary *params = @{
								 @"client_id" : self.clientID,
								 @"redirect_uri" : self.redirectURI.absoluteString,
								 @"scope" : @"public_content",
								 @"response_type" : @"code"
								 };
    NSString *urlRequest = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?%@", params.getParams];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlRequest]]];
    // Do any additional setup after loading the view.
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(navigationAction.navigationType == WKNavigationTypeOther) {
        NSURL *url = navigationAction.request.URL;
        if([url.host isEqualToString:self.redirectURI.host]) {
            NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:false];
            __weak InstagramAuthorizationViewController * weakSelf = self;
            for(NSURLQueryItem *item in components.queryItems) {
                if([item.name isEqualToString:@"code"]) {
                    self.catchToken(item.value,^{
                        weakSelf.completion(weakSelf);
                    });
                }
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
