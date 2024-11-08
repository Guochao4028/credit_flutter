//
//  WebSignViewController.m
//  Runner
//
//  Created by 郭超 on 2023/3/23.
//

#import "WebSignViewController.h"
#import "RealnameHelper.h"
#import "UitilClass.h"
#import <WebKit/WebKit.h>

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight \
({\
CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];\
CGRect rectNav = self.navigationController.navigationBar.frame;\
( rectStatus.size.height+ rectNav.size.height);\
})\

@interface WebSignViewController ()<WKNavigationDelegate, RealnameDelegate>
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) WKWebViewConfiguration *configuration;
@property (strong, nonatomic) WKUserContentController *userContentController;
@end

@implementation WebSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, width, height-100) configuration:self.configuration];
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    [self reloadUrl:self.realnameUrl];
}

//在页面即将展示的时候添加监听
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//在页面消失之前释放
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)reloadUrl:(NSString *)url {
   
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}

//监听处理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
       
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)closeCtrl {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)handleRequest:(NSURLRequest *)request {
    URL_HANDLE_RESULT handleResult = [RealnameHelper handleRealnameURL:request.URL delegate:self];
    return handleResult != URL_HANDLE_RESULT_CANCEL;
}

#pragma mark - RealnameDelegate
- (void)realnameJumptoAlipay {
}

- (void)realnameZhimaCallback:(NSString *)callbackUrl {
    [self reloadUrl:callbackUrl];
}

- (void)realnameResult:(REALNAME_RESULT)result {
    if (result == REALNAME_RESULT_SUCCESS) {
      
        NSLog(@"实名成功");
    }else if(result == REALNAME_RESULT_FAILED){
        
        NSLog(@"实名失败");
    }
}

- (void)signResult:(BOOL)result {
    if (result) {
        NSLog(@"签署成功");
    } else {
        NSLog(@"签署失败");
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SignResult" object:nil userInfo:@{@"result":@(result)}];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"---------->");
    NSLog(@"%@", navigationAction.request.URL.absoluteString);
    BOOL isAllow = [self handleRequest:navigationAction.request];

    if (isAllow) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        
    }
}

#pragma mark - lazyLoading
//初始化配置
- (WKWebViewConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _configuration.preferences = preferences;
        _configuration.userContentController = self.userContentController;
        _configuration.allowsInlineMediaPlayback = YES;
        if (@available(iOS 13.0, *)) {
            _configuration.defaultWebpagePreferences.preferredContentMode = WKContentModeMobile;
        }
    }
    return _configuration;
}

- (WKUserContentController *)userContentController{
    if (!_userContentController) {
        _userContentController = [[WKUserContentController alloc] init];
        //交互关键代码
       // [_userContentController addScriptMessageHandler:self name:@"webViewApp"];
    }
    return _userContentController;
}


#pragma mark - dealloc
- (void)dealloc {
    
}

@end
